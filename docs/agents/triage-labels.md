# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the
actual strings used in this repo's issue tracker.

This repo tracks issues as local markdown (see `issue-tracker.md`), so there are no tracker
labels to apply. The role string goes in the `Status:` line near the top of the issue file:

```markdown
Status: ready-for-agent
```

| Label in mattpocock/skills | String in our tracker | Meaning                                  |
| -------------------------- | --------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`        | Maintainer needs to evaluate this issue  |
| `needs-info`               | `needs-info`          | Waiting on reporter for more information |
| `ready-for-agent`          | `ready-for-agent`     | Fully specified, ready for an AFK agent  |
| `ready-for-human`          | `ready-for-human`     | Requires human implementation            |
| `wontfix`                  | `wontfix`             | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), write the
corresponding string from the right-hand column into the issue's `Status:` line.

Exactly one role applies at a time — replace the previous value rather than appending.

Edit the right-hand column to match whatever vocabulary you actually use.
