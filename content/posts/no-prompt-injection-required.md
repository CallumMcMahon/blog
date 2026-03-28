+++
date = '2026-03-24T20:00:00Z'
draft = false
title = 'No Prompt Injection Required'
subtitle = 'How a supply chain attack on PyPI got us through a Cursor-launched MCP server the old-fashioned way.'
+++

*Originally published on [FutureSearch](https://futuresearch.ai/blog/no-prompt-injection-required), cross-posted for reference.*

Earlier today I got taken out by malware on my local machine. After identifying the malicious payload, I reported it directly to the PyPI security team, who credited our report and quarantined the package, as well as to the LiteLLM maintainers. I wrote a [blog post](https://futuresearch.ai/blog/litellm-pypi-supply-chain-attack) that became the primary source cited by The Register, Hacker News, Snyk, and others. The play-by-play is pretty interesting when looking back.

It started with my machine stuttering hard, something that really shouldn't be happening on a 48GB Mac. `htop` taking 10s of seconds to load, CPU pegged at 100%, all signs I'll be working on my local env for a while... After failing to software reset my Mac, I took a final picture for evidence and hard reset.

So far, the clues had been Cursor asking me for network access right as the machine was freezing up, the process list showing a bunch of python commands all exec-ing a base64 encoded string, and 11k processes running. I set ulimit to 16k for ML workloads so this was partly expected.

On restart, I asked Claude to investigate. After going down a rabbit-hole on the wrong shutdown due to my force-shutdown not generating the expected logs, I presented it with the start of the base64 string. Just enough to decode `import subprocess\nimport tempfile` before the remaining text went offscreen. Claude then became adamant that this was its own doing, the standard Claude Code way of running bash commands to escape control characters. Despite the many bugs I've encountered with that CLI, I wasn't buying this explanation. Further CC probing eventually found the offending cause, the rogue package buried within my `uv` cache, something I would have never found on my own!

Two minutes later, it had reproduced the entire malware trigger within a local container to double check its claims this time. And a further two minutes later I had a blog posted on our [site](https://futuresearch.ai/blog/litellm-pypi-supply-chain-attack) detailing the specifics of the malware to share as a warning to others. Claude even proactively suggested the emails of both the PyPI security team who were quick to quarantine the package, as well as the LiteLLM maintainers.

## What actually happened

The root cause was mundane. MCP clients like Cursor, Claude Code and others use (local) MCP servers via some "executor" tool such as `uvx` for Python or `npx` for Node.js. When you run an MCP via `uvx`, it automatically downloads dependencies of that MCP and runs the given command. Unfortunately, our (mostly deprecated) MCP server had an unpinned dependency of a litellm package. When my Cursor IDE tried to autoload the MCP server, `uvx` stepped in to download the latest litellm version, which was malware uploaded to PyPI by hackers just minutes earlier. The seamless ergonomics of `uvx` meant I became one of the lucky beta testers of the freshly released malware.

A sloppy, likely vibe-coded mistake in the actual malware implementation led it to turn into a fork bomb. It installs a file called `litellm_init.pth` in `site-packages`. Python automatically executes `.pth` files on every interpreter startup. The first thing it does is:

```python
subprocess.Popen([sys.executable, "-c", "import base64; exec(base64.b64decode(...))"])
```

That child Python process also triggers `litellm_init.pth`, since it's still in `site-packages`, which spawns another child, which spawns another. Thus leading to the only sign I would have noticed that the malware was running.

As [Andrej Karpathy](https://x.com/karpathy/status/2036487306585268612) pointed out on X, without this error it would have gone unnoticed for much longer. The malware's own poor quality is what made it visible.

## The takeaway

We've since moved to a remote MCP architecture. The server doesn't run on the user's machine anymore, which collapses this entire attack surface. No local code execution means a poisoned dependency can't touch your filesystem or request network access from your OS, and it's much more localized to one, audited version that we have under control. However, sometimes you can't reliably do that, there are [advantages and disadvantages of local vs. remote MCP servers](https://futuresearch.ai/blog/mcp-leaks-docker-containers), and in that case you still need to do what you can to mitigate this risk.

I don't think there is anything new to say here, it's the same thing we have been doing everywhere else to keep us safe: reduce the attack surface, pin your dependencies, or even better use lock files with checksums, audit packages before upgrading, and when Claude tells you everything is fine, maybe ask it twice.

There's definitely an irony here about how Simon Willison has been hammering on about [the lethal trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/) for almost a year now surrounding MCP servers, yet MCP servers got us via regular old supply chain attacks, no tricking of LLMs required.

**Follow-up:** We analysed the blast radius of this attack. [47,000 downloads in 46 minutes, 88% of dependent packages unprotected](https://futuresearch.ai/blog/litellm-hack-were-you-one-of-the-47000).
