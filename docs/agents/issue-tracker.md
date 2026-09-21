# Issue tracker: Local Markdown

Issues and PRDs for this repo live as markdown files in `.scratch/`.

This repo's GitHub remote (`ngvior/ngvior-configs`) has Issues enabled but deliberately
unused. Do not call `gh issue` — the markdown files under `.scratch/` are the only source
of truth. There is no remote request surface, so pull requests are not a triage input.

Issue files are committed, not throwaway. `.scratch/` is intentionally absent from
`.gitignore` so the queue survives a fresh clone.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- The PRD is `.scratch/<feature-slug>/PRD.md`
- Implementation issues are `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01`
- Triage state is recorded as a `Status:` line near the top of each issue file (see `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

Create a new file under `.scratch/<feature-slug>/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue
number directly.
