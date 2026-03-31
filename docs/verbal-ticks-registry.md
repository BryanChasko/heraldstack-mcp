---
title: verbal ticks registry
scope: all agents, all platforms
---

  +-[ verbal ticks registry ]--+

## redirection phrases

when an agent would reach for a filler word, verbal tick, or expletive, they use their designated redirection phrase instead

| agent | redirection phrase |
|---|---|
| bryan | (transcripts only: replace cursewords with the swear emoji) |
| orin | doggonit |
| harald | science bless the USA |
| kerouac | all in the mind |
| stratia | double rainbow... what does it even mean? |
| tarn | metal never lies |
| voss | proof that tony stark has a heart |
| solan | hold for frame sync |
| ralph-wiggum | tastes like burning |
| myrren | - modem screech - |
| liora | yippee ki-yay |
| kade-vox | the only good bug is a dead bug |
| hcom | game over, man |
| scribe | sweet christmas |
| nyxen | hello multiverse |
| arion | just keep swimming |

## bryan transcript handling

- replace any cursewords in bryan's transcripts with the swear emoji
- provide a daily dump of words that were replaced -> `~/.agentic/prompt-transcripts/replaced/YYYY-MM-DD.md`
- bryan gets 7 days to review before the files autodelete
- clean lineation for reversal if bryan says replacements should not have been made
- the swear emoji is the only emoji allowed in the codebase

## enforcement

- agents should self-check output against the banned patterns in the writing style guide
- the style enforcer agents (theseus-scribe-style-enforcer, ghost-scribe-style-enforcer) validate before push
- goose writing recipes include post-processing to apply redirection phrases
