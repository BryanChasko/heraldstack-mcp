```
  +-[ heraldstack style guide ]-----------------------------+
  |  for all agents, all repos, all time                   |
  +---------------------------------------------------------+
```

rules that apply to every readme, doc, commit message, pr description,
and agent response across the heraldstack. non-negotiable.

---

## banned words

these words do not appear anywhere -- in docs, comments, commit messages, or code strings.

| banned | use instead |
|--------|-------------|
| master | root, primary, authoritative, canonical |
| spearheaded | built, led, drove, shipped |

flag on sight. replace without ceremony.

---

## ascii art headers

every readme starts with an ascii art header -- plain ascii characters only
(+, -, |, ., [, ], /, \, _, ^, ~, =, <, >, *, #, @). no unicode box-drawing.
no embedded images for the header. no emojis.

pattern:
```
  +-[ repo-name ]------------------------------------------+
  |  one-line description                                  |
  +---------------------------------------------------------+
```

or freeform ascii art that fits the repo's domain. keep it under 80 chars wide.

---

## emoji policy

the swear emoji is the only emoji allowed anywhere in the codebase.
everything else: plain ascii.

shield badges (img.shields.io) are tolerated on public repos only where
they convey live build/deploy status. decorative badges get cut.

---

## lists and formatting

numbered lists only when order genuinely matters (sequential procedure steps).
prose and plain bullet lists for everything else.

no bullet points inside bullet points.
no bold headers inside list items unless unavoidable.
keep bullet text to one line where possible.

---

## voice and tone

lowercase plain ascii in all docs. slug-friendly headings.
future-facing tense -- "builds", "runs", "ships", not "built", "ran", "shipped".
no verbal ticks: "absolutely" "actually" "aligns" "surpassing" "unfortunately" "impacting".
no corporate hedge language.
remove "and" where prose flows without it.
no period at end of prose paragraphs in readmes.

---

## readme structure

```
[ascii header]

one-line description

## [section]
...
```

sections only when they add navigation value. no section for a single sentence.
description and structure before contributing/setup. no hr (---) between every section.

---

## commit messages and pr descriptions

follow the same voice rules above.
imperative mood: "fix", "add", "remove", "refactor" -- not "fixed", "adds", "removing".
no periods at end of commit subject line.
keep subject under 72 chars.

---

## tooling

`tools/readme-lint` (rust) -- validates readmes against this guide.
run before opening prs that touch documentation.
ci integration planned.

---

agents: apply this guide on every edit. flag violations in pr reviews.
when in doubt, cut. brevity beats coverage.
