# Content preparation and editorial gate

The bundle contains **390 original AI-authored draft records**, each with exactly
two translated examples. It is a development starter, not the approximately
3,000-word curated launch corpus. No German-language human editorial review has
occurred. Beta is blocked until both requirements are satisfied.

`tool/author_content.py` is the original authoring source. Running it regenerates
`assets/content/vocabulary.json`. Do not run it over an editor's changes without
first integrating those edits into the source. Bundled JSON is the runtime source
of truth; no authoring scripts run on the user's device.

## Editorial work required

1. Expand to 2,900–3,100 genuinely useful, distinct vocabulary records. Do not pad
   with inflections, arbitrary compounds, duplicated senses or generated filler.
   Reorder usefulness ranks after curating the complete set.
2. A qualified German-language editor must examine every headword, grammatical
   type, gender/article, plural, English meaning and both original example pairs.
   Check register, naturalness, idiomatic use, capitalization, punctuation and
   translation fidelity. `—` marks nouns without a usual plural in the taught sense.
3. Review both directions of quiz answers. Equivalent or overlapping senses must
   share an English `answerKey`, even when display labels differ. Review the
   German `answerKey` too; these keys are equivalence groups, not identifiers.
   A record's multiple senses share a displayed meaning, not multiple records.
4. Record corrections in the versioned authoring source and increment `version`.
   Keep every released ID; ranks and example text can change. A released ID must
   never be reused for another lemma or grammatical type. Add new IDs for new
   records. Validate against the last shipped JSON using `--previous`.
5. After actual human approval, set the corpus `editorialStatus` to `approved`.
   Record reviewer, ISO review date, substantive notes, all reviewed IDs and the
   SHA-256 of the **final JSON file bytes** in `editorial_review.json`. Change the
   manifest status to `approved`. Review approval becomes stale after any corpus
   byte changes; repeat review for changed content and update the manifest.
6. Run `python tool/validate_content.py --release`. Structural success alone is
   not linguistic approval. A manifest documents a human process; a script cannot
   authenticate that process or establish linguistic accuracy.

## Import shape

See the first record in `assets/content/vocabulary.json`. `id` is stable across
content versions. `rank` is a unique integer from 1 to record count. English is
required; the translations list and example translation maps support future
languages. Nouns require `article` and `plural`. Exactly two nonempty German
examples with complete translations are required.

Each record is first-party draft prose written for this project; no dictionary
definitions or sentence corpus has been copied. Headwords and inflections are
linguistic facts. The usefulness order is provisional and needs full-corpus review.
