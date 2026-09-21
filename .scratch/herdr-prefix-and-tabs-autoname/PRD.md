# PRD: herdr-prefix-and-tabs-autoname

Status: ready-for-agent

A single Herdr plugin that names tabs after what is actually running in them, and prefixes
workspaces, tabs and agents with the number their jump shortcut uses.

**Priority, and what gets cut first.** Tab auto-naming is the purpose of this plugin. The
`[N] ` prefixes on workspaces, tabs and agents are a plus. If something proves too costly,
agent numbering is the first thing to drop — it is the most fragile part of the design, for
reasons recorded below.

## Problem Statement

I drive Herdr keyboard-only. Jumping is bound to three indexed scales — `ctrl+N` for tabs,
`prefix+N` for workspaces, `prefix+alt+N` for agents — but nothing on screen tells me which
number belongs to which thing. So the fast path is not fast: I either count positions in the
tab bar or open a picker, which is the thing the shortcut was supposed to replace.

The tab labels make it worse, because they actively lie. Some tabs show a name frozen from
weeks ago: a tab currently running the session `herdr-full-namer-plugin` still displays
`herdr-create-plugin`. Others show nothing useful at all — just `1`, which is Herdr's
fallback when no custom name is set. I cannot tell from the tab bar which tab holds which
agent session, or which tab is just a shell.

I already tried to solve this by combining two community plugins, one for agents and
workspaces (`kakigakki/herdr-auto-namer`) and one for tabs (`qu8n/herdr-automatic-rename`).
They fight. The conflict is silent and one-directional: once the tab plugin rewrites a label
to `[1] foo`, the other plugin reads the changed label as a manual rename and freezes that
item permanently, never self-healing. Running both correctly requires disabling the very
numbering I want. The stale labels I see today are the debris of that experiment.

And when I do want to name something myself, I want that to stick. A tab where I keep git,
navigation and monitoring panes side by side has no single process worth naming it after — the
name I would give it describes what I do there, and no automatic rule can derive that.

## Solution

One plugin owns naming for all three scopes, so there is no second writer to fight with.

Tab labels describe what is running, by precedence:

1. If an agent is running in the tab, the tab adopts the agent's **session name** — the tab
   for a Claude session named `herdr-config` reads `[1] herdr-config`.
2. Otherwise the tab takes the name of its **foreground process**, including the pane's own
   shell — a tab sitting at a prompt reads `[1] bash`, a tab running Neovim reads `[1] nvim`.
3. If there is no process at all, the tab reads `[1] NN`. This is a rare edge case rather than
   a normal state, because a pane almost always has at least its shell.

Every workspace, tab and agent label is prefixed with the number that its jump shortcut uses,
in the form `[N] `. Looking at the tab bar tells me what to press.

**A name I set by hand always wins.** Renaming anything by hand pins it: the plugin stops
deriving that name and keeps only its number up to date. Renaming it to an empty name unpins
it and automatic naming resumes. Pins survive restarts.

Names track reality. When I rename a session mid-flight, close a tab, reorder workspaces or an
agent exits, labels reconcile on their own. Nothing freezes, and a label that drifted for any
reason gets corrected on the next reconcile.

## User Stories

1. As a keyboard-only Herdr user, I want every workspace label prefixed with its jump number, so that I can press `prefix+N` without counting positions.
2. As a keyboard-only Herdr user, I want every tab label prefixed with its jump number, so that I can press `ctrl+N` without counting positions.
3. As a keyboard-only Herdr user, I want every agent label prefixed with its jump number, so that I can press `prefix+alt+N` without opening the agent panel.
4. As a user running an agent in a tab, I want the tab to adopt that agent's session name, so that the tab bar tells me which piece of work lives where.
5. As a user with several Claude sessions open, I want each tab to show its own distinct session name, so that I can distinguish `syxr-63-pre-sdd` from `syxr-63-erd-update` at a glance.
6. As a user who renames a session mid-flight, I want the tab label to follow the new name within a couple of seconds, so that the label never describes work I already moved on from.
7. As a user in a tab with no agent, I want the tab named after its foreground process, so that I can tell a shell prompt from a running Neovim without focusing it.
8. As a user sitting at a plain prompt, I want the tab to read the shell's name rather than a placeholder, so that "there is a shell here" is stated plainly.
9. As a user in a pane with no process at all, I want the tab to read `NN`, so that the empty case is explicit rather than blank.
10. As a user whose agent just exited, I want the tab to fall back to the foreground process name, so that a dead session's name does not linger.
11. As a user who starts an agent in an existing shell tab, I want the tab to switch from the process name to the session name, so that the label upgrades as soon as better information exists.
12. As a user who names a tab by hand, I want that name kept, so that a tab holding git, navigation and monitoring panes can say what I use it for instead of naming one arbitrary process.
13. As a user with a hand-named tab, I want its number kept up to date anyway, so that pinning the name does not cost me the shortcut.
14. As a user who wants automatic naming back on a pinned item, I want renaming it to an empty name to release the pin, so that pinning is reversible without editing state by hand.
15. As a user who restarts Herdr, I want my pins to survive, so that reattaching does not silently re-derive names over the ones I chose.
16. As a user who renames a workspace or an agent by hand, I want that name preserved with only the prefix managed, so that manual naming means the same thing in every scope.
17. As a user who has not named a workspace, I want it named after its working directory's base name, so that workspaces read the way they do today.
18. As a user who changes a workspace's working directory, I want its name to follow, so that naming it once does not freeze it forever.
19. As a user who hand-edits a label to `[wip] something`, I want my bracketed word preserved, so that only the plugin's own numeric prefix is treated as machine-owned.
20. As a user, I want the plugin never to double-prefix a label, so that repeated reconciles cannot produce `[1] [1] foo`.
21. As a user, I want the plugin to leave a label untouched when the computed name already matches, so that it does not generate rename churn or log noise.
22. As a user who closes a tab in the middle of a workspace, I want every remaining tab's prefix to match what the shortcuts now do, so that the numbers never go stale after a close.
23. As a user who moves a tab, I want its prefix to reflect its new jump number, so that reordering does not silently break my muscle memory.
24. As a user who creates a new workspace, I want it named and prefixed immediately, so that I never have an unlabeled workspace in the switcher.
25. As a user who closes a workspace, I want the remaining workspaces renumbered to match `prefix+N`, so that the prefixes stay truthful.
26. As a user who starts or stops an agent anywhere, I want agent numbers everywhere to stay correct, so that a global numbering scheme does not leave stale numbers behind in other workspaces.
27. As a user with more than nine agents, I want the ones past the ninth to make clear that no indexed shortcut reaches them, so that I do not press a chord expecting a jump that cannot happen.
28. As a user with more than nine tabs in one workspace, I want the tabs past the ninth to make the same thing clear, for the same reason.
29. As a user reattaching to a persistent session, I want labels reconciled once on startup, so that anything that drifted while the plugin was not running is corrected.
30. As a user with the stale labels left over from my previous plugin experiment, I want them replaced on first run, so that I do not have to clear them by hand.
31. As a user, I want the plugin never to freeze permanently because a label changed underneath it, so that I do not silently lose naming the way I did with the previous two plugins.
32. As a user who installs a competing naming plugin, I want this plugin to refuse to start and say why, so that two writers cannot quietly corrupt every pin.
33. As a user with several agents sharing a base name like `claude`, I want all of them renamed successfully, so that Herdr's rejection of duplicate agent names does not leave one agent unnamed.
34. As a user in a tab split into several panes, I want one deterministic label, so that the name does not flicker as I move between panes.
35. As a user in a tab with several panes where only one runs an agent, I want the agent's session name to win, so that the most informative name is chosen.
36. As a user working in a worktree-backed workspace, I want naming to behave the same as anywhere else, so that worktrees are not a special case I have to remember.
37. As a user with a long session name, I want the base name shortened and the prefix left intact, so that the number — the part I act on — is never what gets cut.
38. As a user, I want burst activity such as opening several tabs at once to settle into correct labels, so that I am not left with a half-renamed tab bar.
39. As a user, I want naming to cost no perceptible latency, so that the plugin never makes Herdr feel slower than it does today.
40. As a user, I want the naming rules in a config file rather than compiled in, so that I can change the shell-name behaviour or the length cap without rebuilding.
41. As a user, I want to turn prefixes off per scope, so that I can keep tab naming — the part I actually wanted — if agent numbering turns out to be more trouble than it is worth.
42. As a user, I want to disable the plugin and get Herdr's own defaults back, so that turning it off is not a one-way door.
43. As a user, I want to know at a glance whether the plugin is running, so that "labels look wrong" is diagnosable.
44. As a user, I want the plugin to leave my real Herdr session alone while its tests run, so that running the suite is never a risk to work in progress.

## Implementation Decisions

**One plugin, three scopes, single writer.** The plugin owns naming for workspaces, tabs and
agents. Coexistence with `herdr-auto-namer` or `herdr-automatic-rename` is not merely a
non-goal — it breaks correctness, because pin detection depends on being the only writer. The
plugin detects a known competing namer at startup and refuses to run with a clear message,
rather than starting and misreading the other plugin's writes as user intent.

**Written in Rust.** This is a daemon that stays resident for days beside a dozen agents, with
essentially no CPU load, so idle footprint and long-uptime robustness dominate; iteration speed
is a one-time cost, and the end-to-end-only test strategy makes the feedback loop
process-driven regardless of language. Rust also matches Herdr's own implementation and the
prior art of the installed file viewer plugin, and lets the API types be generated from the
JSON Schema Herdr publishes — which matters here, because every fact in this document was
obtained by probing that schema and could change on upgrade. Generated types turn the next such
change into a compile error instead of a silent misparse. Cost accepted: a Rust toolchain must
be installed, as none is present today.

**Talks the socket API directly.** Event subscription exists as a socket request with per-event
opt-in, but no CLI wraps it — the available CLI surface for the API is limited to snapshot and
schema. The plugin therefore speaks the session's unix socket itself, subscribing only to the
events it needs.

**Hosting.** The reconciler is a long-lived process started by a plugin action that spawns it
detached, guarded by a pidfile so invoking the action twice does not produce two writers. No
daemon or service section was found in the plugin manifest format, so this uses only the
sections known to exist.

**State and configuration live where Herdr puts them.** Herdr exposes a plugin state directory
and a plugin config directory to plugins. Pin state persists in the state directory — per
session, managed by Herdr. The naming rules live in the config directory as a config file
rather than compiled in: the shell-name behaviour, the length cap, and whether prefixes are
enabled per scope are all settings. This is what separates a plugin that could be published
later from one that would have to be rewritten first, and the prior art proves it — the only
reason the previous tab plugin could coexist with anything at all was that its numbering was a
toggle.

**Prefixes are positional — established by test, not assumption.** Whether an indexed jump
follows a record's `number` field or its position was settled by manual key press, since focus
requests address targets by id and the CLI cannot observe keybinding routing. In a workspace
whose tabs were numbered 1, 3, 13, 14, 4, 11 in listing order, pressing the shortcut for 4
focused the **fourth tab in listing order** (`number` 14), not the tab whose `number` is 4. The
tab `number` field must therefore never be used for prefixes: it is a display-stable slot id
that the shortcuts ignore. Prefixes are 1-based positions, and positions are contiguous, so
every target up to the ninth is reachable.

**Agent numbering is global, and that is the fragile part.** Agent order is a single flat
sequence across all workspaces, not a per-workspace count. Observed live: the agent listing
groups by workspace in workspace order and follows tab order within each, matching the
workspace-grouped panel sort. Two consequences follow, and both are why this is the first
feature to cut. With a dozen agents open, everything past the ninth is unreachable by chord.
And because the sequence is global, an agent starting or exiting anywhere renumbers agents in
every other workspace — far more churn than tabs, which renumber only within their own
workspace. Agents also expose no number field of their own, so their ordering is observable
only while the panel sort groups by workspace; under any other sort the plugin omits agent
prefixes rather than emitting numbers that jump elsewhere.

**Positional prefixes mean structural churn.** Creating, closing or moving one tab shifts the
correct prefix of every later tab in that workspace, so a reconcile renumbers a whole workspace
rather than the one item that changed. Structural event bursts coalesce into a single pass,
with a debounce on the order of 200 ms.

**Name resolution order, all scopes.** A pinned manual name wins; then the derived name; then
nothing. For tabs the derived name is the precedence chain in the Solution section. For
workspaces it is the base name of the working directory.

**Workspaces derive their own base name from the working directory.** Herdr shows a derived
name only while no custom name is set, so the moment the plugin writes a label it destroys its
own ability to read that derived value afterwards. The plugin therefore computes the base name
from the workspace's working directory itself on every reconcile, replicating the derivation
rather than reading it back. Without this, writing a prefix once would silently freeze the name
against later working-directory changes.

**Pin detection compares the stripped base, never the whole label.** Because the plugin keeps
rewriting the prefix of a pinned item to keep its number correct, its own writes change the
label continuously. Pin detection therefore compares the live label with the prefix removed
against the base the plugin last wrote. A difference means the user renamed it. This is the
same shape of guard that froze the previous plugin, and it is sound only because of the
single-writer invariant enforced at startup — which is why that check is not optional.

**Unpinning is a rename to an empty name.** It reuses a command that already exists rather than
inventing new surface, and it is also how the plugin restores Herdr's defaults when disabled:
clearing a label returns a tab to Herdr's numeric fallback and a workspace to its derived name.

**Reconciles are idempotent.** Each pass computes desired labels from current state and issues a
rename only where the live label differs. Running a pass twice produces no second rename.

**Prefix format and strip rule.** The prefix is `[`, a decimal number, `]`, and one space. When
computing a base name, strip a leading prefix matching exactly bracketed digits followed by one
space; leave any other bracketed text intact as user content.

**Length cap is ours to choose — Herdr imposes none.** The rename requests carry no length
constraint and Herdr stores labels verbatim; an earlier reading of a truncated stored name as
evidence of Herdr truncating was wrong, since that value had already been written shortened by
the previous plugin. The plugin caps the base name itself, around 24 characters by default and
configurable, and never lets the prefix be what gets removed.

**Tab session names come from the stripped terminal title.** Not from the agent session identity
field, which carries an opaque UUID and is absent on some panes entirely. The stripped title is
present on every agent pane and already has Herdr's status glyph removed.

**Multi-pane tabs are named from one pane, chosen independently of focus.** Prefer a pane
running an agent; where none does, use the first pane in a stable order rather than the focused
one, so the label does not flicker as focus moves.

**Agent rename collisions need two phases.** Herdr rejects a manual agent name already held by
another agent, so renaming several agents that share a base name requires passing through a
temporary name.

**Linux only in v1**, declared in the manifest. Built from source at install time via the
manifest's build step invoking Cargo; no prebuilt release pipeline. The prebuilt-binary path
with a build fallback is documented as the upgrade route if the plugin is ever published, but is
not implemented.

## Testing Decisions

**Chosen strategy: end-to-end only, against a real disposable Herdr session.** This was decided
deliberately over a pure-planner unit seam. The tradeoffs were stated and accepted: it is
slower, exposed to timing flake, and weak at isolating ordering edge cases. What it buys is that
it tests the only thing that matters here — the label a human reads — through the same API a
human's eyes go through, against real Herdr rather than a fixture of it. The feature is "the
label matches reality", so mocking reality would test the wrong thing.

**What makes a good test here.** Assert only on observable labels, read back through the public
listing surfaces for workspaces, tabs and agents. Never assert on the plugin's internal state,
its event handling, or how many renames it issued along the way — a plugin that reaches the
right labels by a different route is still correct. Each test states a world, lets the plugin
converge, and asserts the labels.

**One entry point.** The suite runs under Cargo's test runner, with helpers that drive the Herdr
CLI and poll for convergence. Same toolchain as the plugin, assertions in the same language as
the code.

**Isolation is real, and enforced.** Herdr's session listing exposes each session's own
directory and socket path, and the CLI can be pointed at a specific session through its
socket-path environment variable. Each run creates a uniquely named throwaway session, discovers
its socket, builds its world through the CLI, links and enables the plugin, and tears the
session down afterwards by stopping and then deleting it. On top of that the suite refuses to
run at all when the socket it is given belongs to the default session — an interlock, because a
mis-set environment variable renaming six tabs of live work is an accident that should be
impossible by construction rather than avoided by discipline.

**Synthesising agents without running real ones.** Herdr exposes requests to report pane agent
lifecycle state and pane agent session identity directly. Tests use those to manufacture a
detected agent in a plain shell pane — no real agent process, no token cost, no dependence on
agent startup timing. The session name that tabs adopt comes from the pane's terminal title, so
tests set it by writing a title escape sequence into the pane.

**Flake control.** Convergence is awaited by polling labels until stable or a timeout expires,
never by a fixed sleep. Assertion failures report the full observed label set, because with a
reconciler the interesting information is which labels were wrong together.

**Scenarios to cover.** Prefixes correct on all three scopes; the full tab precedence chain
including the shell case and the empty case; a session renamed mid-flight; an agent starting in
a shell tab and exiting again; a tab closed from the middle and a tab moved; a workspace closed;
an agent started in one workspace renumbering agents in another; a workspace whose working
directory changes; pinning by hand and confirming the base is preserved while the number keeps
updating; unpinning by renaming to empty; a pin surviving a restart; refusal to start when a
competing namer is present; idempotence, by reconciling twice and asserting nothing changed; no
double-prefixing when starting against labels that already carry a prefix; the stale-leftover
migration; preservation of a non-numeric bracketed user prefix; several agents sharing one base
name; a multi-pane tab where one pane runs an agent; prefixes disabled per scope by config; and
restoration of defaults when the plugin is disabled.

**Prior art.** There is no existing test suite to follow — this is a new project. The closest
prior art is the convention used by the installed file viewer plugin, which pins behaviour to
numbered acceptance criteria referenced from its own manifest and records which behaviours were
verified against which Herdr version on which platform. Mirror that: number the acceptance
criteria and record the Herdr version each was verified against, because the findings behind
this PRD came from reading live API output rather than documentation and will need rechecking
after an upgrade.

## Out of Scope

- Coexisting with `herdr-auto-namer` or `herdr-automatic-rename`. The plugin refuses to run
  alongside them by design.
- Making the tenth and later tabs of a workspace, or the tenth and later agents, reachable.
  Only nine indexed slots exist; that is a limit of Herdr's keybindings, not something a naming
  plugin can fix. The plugin's job is to stop pretending otherwise.
- Naming panes. Only workspaces, tabs and agents.
- macOS and Windows.
- Publishing the plugin, and any release, packaging or distribution pipeline beyond building
  from source. The path is documented, not built.
- Colours, status glyphs, icons, or any visual treatment beyond the text label.
- Naming across several named Herdr sessions at once. Tests use a throwaway session, but the
  plugin targets the session it runs in.
- Changing keybindings. The existing indexed bindings are the contract this plugin serves.

## Further Notes

**The plugin lives in its own repository.** Not inside the configuration repo that holds this
PRD — its own directory alongside the user's other projects, with its own git history, so that
publishing it later is a decision rather than an extraction. A licence goes in from the first
commit, because retrofitting one over existing history is avoidable pain. The configuration
repo's documented convention — one top-level directory per tool's config — therefore stays as
it is.

**Issues stay here for now.** This PRD and any follow-up issues remain in the configuration
repo's local markdown tracker, so there is one queue rather than two. The natural time to move
them to the plugin repository's own issue surface is when it is published, not before.

**One-time migration.** Stale custom names persist in Herdr's session state for several
workspaces and tabs, left by the earlier plugin experiment. First run must overwrite them rather
than treat them as user intent. This is exactly the case the reconciler design is meant to
handle, and it doubles as an acceptance test for it — note that these leftovers must *not* be
read as pins, since they were not written by this plugin.

**Findings came from live inspection, not documentation.** The positional routing of indexed
jumps, the tab `number` non-contiguity, the opaque session identity field, the stripped terminal
title as the real source of session names, the numeric fallback label, the absence of any length
constraint on renames, the event list, and the plugin state and config directories were all
established against a running Herdr 0.7.5. Recheck them after any upgrade, above all whether
indexed jumps are still positional — a change there silently invalidates every prefix.

**Open questions to settle during implementation.** Four things are known-unverified and should
be resolved before the code that depends on them is written:

1. Whether the pane-updated event fires when a terminal title changes. This decides whether a
   mid-flight session rename is observable by event, or whether that single input needs a
   low-frequency poll.
2. Whether linking a local plugin runs the manifest's build step, which determines the shape of
   the development loop.
3. Whether the agent listing order is *guaranteed* to match panel order, or merely happens to
   today. This is load-bearing now that agent numbering is global.
4. Whether Herdr's plugin id validation accepts the chosen id. Herdr validates plugin ids and
   derives an installation subdirectory from them, so the id's character set is constrained.
