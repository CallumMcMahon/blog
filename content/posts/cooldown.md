+++
date = '2026-06-07T12:00:00+00:00'
draft = false
title = "Dependency cooldowns"
subtitle = "A two-line default that buys security teams time before you pull in a compromised package"
+++

It recently came to my attention that some people didn't get the memo after the recent supply chain attacks.

For non-technical managers out there, or security policy makers within orgs, the TLDR is "enforce dependency cooldowns as a required default".

For technical staff: there's a two line addition to each of your package managers' dependency files.
In uv for example:

```toml
# pyproject.toml
[tool.uv]
exclude-newer = "7 days"
```

```yaml
# pnpm-workspace.yaml
minimumReleaseAge: 10080 # 7 days in minutes
packages: []
```

For a more comprehensive list across package managers, [see here](https://nesbitt.io/2026/03/04/package-managers-need-to-cool-down.html).
This enforces that you can't accidentally re-build your env, pulling in recently compromised packages.

The basic ideas for why this is a good thing:

- you don't need bleeding edge package versions for nearly all use-cases.
- without this, you're downloading just-released software at the same time security tooling can scan it
- adding a lag to the release flow, between when scanners inspect new software versions and you downloading it, gives security firms time to flag malware
- you don't end up as the beta tester for discovering new malware, an experience I'm [all too familiar with](/posts/litellm-pypi-supply-chain-attack/)

This programmatically enforced safeguard is much less prone to human error. There's no longer a need to manually enforce this "safe time buffer" via PR reviews. Your less cautious coworker trying out new packages locally are less likely to accidentally walk over a malware landmine.

## Wider discussion

I firmly believe a sane default cooldown of say 7 days will be implemented as default across package managers at some point. These cooldown features are relatively new, and I get the impression that package manager maintainers are waiting for more community feedback before changing such a public-facing default. Given the [numerous](https://ringmast4r.substack.com/p/we-may-be-living-through-the-most) supply chain attacks recently, showing no sign of slowing down, it seems reckless to not proactively choose to protect yourself, or your org.

Just last week vscode started [applying a 2 hour cooldown period](https://code.visualstudio.com/updates/v1_123#_delayed-extension-autoupdates) between new extension versions releasing and when the auto-update mechanism triggers.

It's just another gating mechanism like a CI test suite. You're happy to wait 5 minutes for CI to finish due to the guarantees it provides, think of dependency cooldown similarly. With the ever-accelerating speed of development happening currently, [slow down](https://youtu.be/RjfbvDXpFls?si=Z0kSNPCh4mHvunNk&t=723) just a bit, it's good for you.

## Q&A

Q: What if I actually _do_ need a bleeding edge version of a specific package crucial to my application?

A: They've already thought of this, with a per-package opt-out mechanism

<details><summary>Per-package opt-out demo (pydantic-ai)</summary>

```toml
exclude-newer-package = { pydantic-ai = "2006-12-02T02:07:43Z" }
# or
exclude-newer-package = { pydantic-ai  = false }
```

</details>

---

Q: Isn't this just letting unaware developers act as beta testers for you?

A: As mentioned above, the intended flow is that this buys security teams time to vet things before the masses update versions. _Other developers_ aren't the intended fall-guy here.

---

Q: Isn't this just absolving developers of the responsibility to read code they download and execute from external sources?

A: You definitely should still do both. I still look at star count, number of active package contributors, and a moderate glance at code quality to know what I'm getting myself into. A 7 day wait won't save you from a vibe-coded buggy mess that takes you down for non-malicious reasons.

---

Q: Who are these supposed security scanning companies we're now suggesting we rely on?

A: Plenty such companies exist, each doing this work already to prove to new and potential clients that they can save you from attackers. This just acts as a better mechanism for using their findings.

---

Q: Isn't this just patching inherently insecure dev workflows of running any code un-sandboxed on the user's local machine? What about dev containers?

A: To an extent yes! However developers rightfully complain about the ergonomics of iterating on local code through many abstraction layers of containers. If you have ergonomic recommendations such as leveraging apple's new native containers, do reach out!

Stay safe out there folks!
