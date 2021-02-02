---
layout: post
title:  "Panning Calculations"
date:   2021-01-31 18:15:43 +0000
categories: audio gotracker
---
Multichannel audio panning is a scientific study all by itself. I knew this before I started in on building a music tracker and I understood that I shouldn't cut corners when building out the panning/positioning, as retrofitting a correct solution on top of a poor solution would be more effort than writing it correctly the first time.

However, laziness and instant gratification got the better part of me and instead of building a reasonable solution in on the first go, I only spent enough time to get a minimum viable solution in place... and the longer I put off completely gutting the panning/positioning/channel separation system and replacing it with the correct solution, the worse the situation gets.