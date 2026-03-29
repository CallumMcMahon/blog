+++
date = '2026-03-27T20:00:00+00:00'
draft = false
title = "The busiest week of my career"
subtitle = "Links to all the places I got mentioned"
+++

The week started out slow, I was ramping back up from a week of holidays.

On my Tuesday morning 10am meeting with my manager, we brought back up the topic of project "Sell Callum".
The idea being that I often squirrel away solving the thorny problems slowing the team down,
then carry on with my work without tooting my own horn. Basically I should increase my visibility.

Not 30 minutes later I inadvertently become patient zero for the [biggest malware event](https://techcrunch.com/2026/03/26/delve-did-the-security-compliance-on-litellm-an-ai-project-hit-by-malware/) in quite a while.
A [minute-by-minute timeline](posts/litellm-attack-transcript/)
of what I was doing on my computer as this was happening if you want to follow along.

Whilst I was trying to sort out this mess, I got my manager back on a call

<div style="background:color-mix(in srgb, currentColor 10%, transparent); border-radius:8px; padding:12px 16px; font-size:0.9rem; line-height:1.8;">
<strong>Callum:</strong> pretty sure <del>CC</del> Cursor just inadvertently created a fork bomb that crashed my computer<br>
<strong>Callum:</strong> <em>&lt;tries to call my manager&gt;</em><br>
<strong>Manager:</strong> on a call<br>
<strong>Manager:</strong> urgent?<br>
<strong>Callum:</strong> yep
</div>

As noted in the linked transcript, partway through the call I re-activate the malware,
giving me mere seconds to say my goodbyes to my manager before my laptop locks up again requiring
another restart!

Once the threat was contained, we got to spreading the word asap.
I got my personal AI to write the [initial blog post](/posts/litellm-pypi-supply-chain-attack) as it already had all the details necessary to
explain the situation.
I don't use twitter, so my manager sent out the initial tweet warning people, linking to my blog post.

The story then gets [Quote Tweeted](https://x.com/karpathy/status/2036487306585268612) by Andrej Karpathy, co-founder of OpenAI, who comments on the contents of my blog post. He claimed the malware's bug was due to vibe-coding and mentions me by name, which gets picked up by everyone else from here on out.

Karpathy's tweet then gets [Quote tweeted](https://x.com/elonmusk/status/2036593141663551828) by Elon Musk.

By the end of the day I get out a [post-mortem](/posts/no-prompt-injection-required),
which goes into more details about how I got affected so quickly.

By end of wednesday, I've written up my final piece on the malware, a
[minute-by-minute timeline](https://runsondata.com/posts/litellm-attack-transcript/)
showing the exact prompts I was using to get my local Claude Code session to identify the
malware, clean it up, and write the advisory blog post.

I end up posting this thursday mid-afternoon to [Hacker News](https://news.ycombinator.com/item?id=47531967), a site I've read daily for years.
As my very first post, it makes it straight to the #1 spot.
With comments from a bunch of awesome people I admire.

I clocked off thursday evening 11pm to wind down with some tech YouTube. The first video
on my feed is none other than [The Primeagen](https://www.youtube.com/watch?v=mx3g7XoPVNQ) talking about the malware, mentioning me by name throughout the video.

By friday it had been picked up by sites such as [TechCrunch](https://techcrunch.com/2026/03/26/delve-did-the-security-compliance-on-litellm-an-ai-project-hit-by-malware/), [Inc.com](https://www.inc.com/chloe-aiello/malware-in-an-open-source-project-could-have-infected-thousands-the-twist-it-was-certified-by-delve/91322506),
and even a [mention](https://simonwillison.net/2026/Mar/26/response-to-the-litellm-malware-attack/) on Simon Willison's blog.

Not quite what we had in mind for project Sell Callum, but I'll take it.
