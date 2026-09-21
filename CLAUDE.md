# ngvior-configs

Personal configuration repo. Each top-level directory holds the config for one tool:
`ghostty/`, `herdr/`, `nvim/`, `opencode/`, and `skills/`.

## Agent skills

### Issue tracker

Issues live as markdown files under `.scratch/<feature-slug>/` in this repo. There is no
remote issue surface in use, so pull requests are not a triage input. See
`docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles are used verbatim — `needs-triage`, `needs-info`,
`ready-for-agent`, `ready-for-human`, `wontfix` — recorded as a `Status:` line in each
issue file. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` and `docs/adr/` at the repo root. See
`docs/agents/domain.md`.
