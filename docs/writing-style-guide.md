---
title: heraldstack writing style guide (agent context)
scope: all agents, all platforms
canonical: see STYLE_GUIDE.md in repo root for full reference
---

  +-[ heraldstack writing style guide ]--+

this is the token-efficient agent-context version. injected into agent reasoning via qdrant.
full rule set lives at: https://github.com/BryanChasko/heraldstack-mcp/blob/main/STYLE_GUIDE.md

---

## voice

- future-facing tense: "builds", "runs", "ships" -- not past tense
- concise. revise to remove "and". no periods at end of readme paragraphs
- no filler, no coded language (no "master", "spearheaded")

## format

- lowercase plain ascii. no emoji except swear emoji
- no numbered lists unless the order is a required sequence
- no bold inside list items

## banned verbal ticks

"absolutely" "actual" "actually" "real" "like" "aligns" "surpassing" "unfortunately" "impacting" "uh"

each agent has a redirection phrase -- see verbal-ticks-registry.md

## revision process

1. get stream of consciousness out first
2. revise for audience + future generations
3. check against banned patterns above
4. verify future-facing tone throughout
