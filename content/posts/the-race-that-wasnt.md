+++
date = '2026-03-28T20:37:28+00:00'
draft = false
title = "The cutest running race that wasn't"
+++

I've been spending the past few weekends building out my new hobby project, [Race Roundup](/posts/race-roundup),
which involves collecting data from every running event across the nation.

To give you a sense of numbers, so far I've collected and analysed 1.7k events, mostly over the next 12 months.
I'm sure there's more out there I'll continue to find, but assume this is the vast majority of them.

As part of the data collection process, I have my AI system complain to me when it sees
an event that it can't easily enter into the form I get it to fill out. This is very helpful
for finding edge cases I had previously overlooked in the "form" (known as a data model).

An example that came up today, was a couple dozen events that all refused to have a "distance" amount entered.
Investigating further revealed I'd forgotten about time-based events. Think events of the form
"Run to your heart's content for 12 hours straight, furthest distance travelled wins".
After generalising my form to allow both distance _and_ time events, a single entry still didn't fit.

That event: the [Treehouse 10k's Fun Run](https://treehouse10k.org.uk/run-info/#funrun) happening tomorrow!

From the site's description of the event:
> Fun Runners can run as many laps as they like, and will receive a medal showing the distance that they achieved.

For every assumption you think you can make about the world, there's a toddler in a dinosaur costume about to violate your data model.
