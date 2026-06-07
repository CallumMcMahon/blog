# Dependency cooldowns

It recently came to my attention that some people didn't get the memo after the recent supply chain attacks.

For non-technical managers out there, or security policy makers within orgs, the TLDR is "enforce dependency cooldowns as a required default".

For technical staff: there's a two line addition to each of your package managers' dependency files.
In uv for example:

```
# uv pyproject.yaml
[tool.uv]
exclude-newer = "7 days"


# pnpm-workspace.yaml
minimumReleaseAge: 10080 # 7 days in minutes
packages: []
```

This enforces that you can't accidentally re-build your env, pulling in recently compromised packages.

The basic ideas for why this is a good thing:

- you don't need bleeding edge package versions for nearly all use-cases.
- without this, you're downloading just-released software at the same time security tooling can scan it
- adding a lag to the release flow, between when scanners inspect new software versions and you downloading it, gives security firms time to flag malware
- you don't end up as the beta tester for discovering new malware, an experience I'm [all too familiar with]()

This programmatically enforced safeguard is much less prone to human error. There's no longer a need to manually enforce this "safe time buffer" via PR reviews. Your less cautious coworker trying out new packages locally are less likely to accidentally walk over a malware landmine.

## Wider discussion

I firmly believe a sane default cooldown of say 7 days will be implemented as default across package managers at some point. These cooldown features are relatively new, and I get the impression that package manager maintainers are waiting for more community feedback before changing such a public-facing default. Given the [numerous]() supply chain attacks recently, showing no sign of slowing down, it seems reckless to not proactively choose to protect yourself, or your org.

Another way of thinking about it is like CI test suites. In theory we could just trust the person pushing new code to take ownership of it working as intended, not breaking tests. But even if you charitably assumed they always diligently run tests locally, there's always a chance that their local setup and CI have accidentally diverged. Trust but verify. Adding a cooldown period acts as a similar gating mechanism between package author's sign-off and use out in the world.

## Q&A

Q: What if I actually _do_ need a bleeding edge version of a specific package crucial to my application?
A: They've already thought of this, with a per-package opt-out mechanism
<fold out showing demo for pydantic ai>

Q: Isn't this just letting unaware developers act as beta testers for you?
A: As mentioned above, the intended flow is that this buys security teams time to vet things before the masses update versions. _Other developers_ aren't the intended fall-guy here.

Q: Isn't this just absolving developers of the responsibility to read code they download and execute from external sources?
A: You definitely should still do both. I still look at star count, number of active package contributors, and a moderate glance at code quality to know what I'm getting myself into. A 7 day wait won't save you from a vibe-coded buggy mess that takes you down for non-malicious reasons.

Q: Who are these supposed secirity scanning companies we're now suggesting we rely on?
A: Plenty such companies exist, each doing this work already to prove to new and potential clients that they can save you from attackers. This just acts as a better mechanism for using their findings.

Q: Isn't this just patching inherently insecure dev workflows of running any code un-sandboxed on the user's local machine? What about dev containers?
A: To an extent yes! However developers rightfully complain about the ergonomics of iterating on local code through many abstraction layers of containers. If you have ergonomic recommendations such as leveraging apple's new native containers, do reach out!

Stay safe out there folks!
