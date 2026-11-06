# Better commit messages for push-new-notes.sh

## Goal (original)

`./push-new-notes.sh` automatically pushes the notes I take to a git repo. The
commit messages are not useful when looking at commit history. I want messages
that show the files that were changed and what was changed.

## Evidence gathered (from ~/projects/notas, last 300-400 commits)

| Fact | Number |
| --- | --- |
| Commits touching exactly 1 file | 214 / 300 |
| Commits touching 2 files / 3 / >5 | 61 / 17 / 4 |
| Multi-file commits that are a to-do move (`uberall-todo` -> `todo-concluded`) | 39 / 101 |
| Commits that flip `[ ]` -> `[x]` in place | 85 / 400 |
| Single-file commits with >2 changed lines | 72 / 298 |
| New note files (`A`) / deletions (`D`) / renames (`R`) | 52 / 1 / 0 |
| Commits polluted by tracked junk (`:w` 26, `bookmarks.md.bak` 12) | 38 / 400 |
| Commits spanning 2+ top-level buckets | 21 / 400 |
| Cleaned content-line length | p50 47, p75 93, p90 179, max 3777 |
| Added lines containing a URL / URL-only | 774 / 20 |
| Added-line markdown prefixes | `- ` 891, `- [ ] ` 376, `- [x] ` 259, `**` 250, `---` 198, `## ` 181 |

Other findings:

- Cron runs the script every 10 min (Ansible-managed:
  `~/.config/ansible/pull/arch-samsung2/roles/light_workstation/tasks/cron.yml:46`).
- `~/.cron-errors/push-new-notes-error-logs.txt` is 2437 lines, nearly all
  `Could not resolve hostname github.com`. Because the script is
  `pull && add && commit && push`, an offline tick commits **nothing** — edits
  batch up until the network returns.
- The healthcheck ping (`push-new-notes.sh:10`) runs unconditionally, outside
  the `&&` chain, so healthchecks.io reports OK even on failed pushes.
- The move pattern is script-generated: `~/.scripts/todo:21-23` removes the line
  from `uberall-todo.md` and appends `"$cmd" - $(date +%Y-%m-%d_%R)` to
  `todo-concluded.md` (no seconds).
- `:w` is a stale snapshot of `to-do-compra-moveis-casa-2026-04-18.md` (same
  frontmatter `id`), created by a stray nvim `:w`. Tracked.
- `.obsidian/` is fully gitignored; `_attachment/` and Excalidraw never appear
  in commits — so no binary-diff handling is needed.
- Nothing parses these commit messages: no git hooks, no CI, GitHub remote only.
- Mobile clients also commit: `GitJournal <app@gitjournal.io>` and something
  producing `Updated Note <path>` (most recently 2026-08-03).
- `git-filter-repo` is **not** installed. git 2.55.0.
- `~/.claude/settings.json` runs a shellcheck PostToolUse hook, so POSIX
  compliance is enforced on every edit.

## Status (2026-08-04)

Done and live:

- `~/.scripts/git-commit-message.sh` written; `~/.scripts/push-new-notes.sh`
  rewritten. Both pass `dash -n` and `shellcheck -s sh` clean.
- Noise untracked and pushed (commit `367a00f8`).
- Backtested over the last 300 commits: 300/300 generated, 0 subjects over 100
  chars, 0 unbounded bodies, 1 empty output (the `acbad562` merge commit, which
  correctly falls back). Table:
  `scratchpad/backtest-final.txt`.
- Dry-run on a throwaway clone with a local bare remote covered: no-op tick,
  single-file add, two-bucket split, checkbox tick, completion move, new note,
  root-level file, offline (commits locally, retries, no ping), offline
  recovery, mid-rebase guard (refuses, HEAD unchanged, nothing staged), and a
  real rebase conflict (aborts, repo left clean, local commit kept, **zero
  conflict markers written into any note**).

Deviations from the design above, found while building:

- Extra verb `mark [<state>]` for Obsidian checkbox states other than
  `[x]`/`[ ]` — `[?]`, `[~]`, `[/]`. These are frequent (15 of 300 commits) and
  would otherwise read as ordinary edits.
- `[]` (empty brackets, no space) and `--`/`***` bullet runs also get stripped;
  both appear in the notes.
- Body is capped at 10 lines and each body snippet at 120 chars, ending with
  `… and N more changes`. Without a cap, commit `81186c44` produced a 150-line
  body.
- Backfill uses `git rebase --rebase-merges` because one merge commit
  (`acbad562`, position 141) falls inside the 200-commit window; a plain rebase
  would flatten it, changing history shape rather than only messages.
- The backfill `--exec` tolerates a failed generator (`|| true`) so a commit
  with an empty diff keeps its original message instead of stopping the rebase.

Backfill done, but over **141 commits, not 200**. The first attempt with
`--rebase-merges` re-created merge `acbad562` and its tree came out different:
the original merge deliberately dropped an `imdb` line from `pessoal/bangs.md`
that still existed on its second parent, and a re-created merge cannot reproduce
a hand resolution. The tree comparison caught it, the rebase was reset to the
backup, and the window was reduced to `acbad562..HEAD` — merge-free, so all 141
intermediate trees came out byte-identical. Anything older than 2026-07-18 keeps
its timestamp subject; going deeper would mean altering note content.

Result: old head `367a00f8` -> new head `c18cfee7`, 7250 commits before and
after, top-level tree unchanged, `backup/pre-backfill-2026-08-04` pushed to
GitHub, cron paused during the rewrite (so no tick could interleave a pull with
the diverged remote) and restored byte-identical afterwards.

Remaining: the healthchecks.io grace setting, and the phone re-clone.

## Decisions

### 1. Message source: extract from the diff, no LLM

Pure git + POSIX shell. Deterministic, instant, offline, no note content leaves
the machine. Justified because the notes are prose: the added line already reads
like a commit message.

### 2. Subject grammar

```
<bucket>: <file>: <verb> "<snippet>"            single logical change
<bucket>: <src> -> <dst> "<snippet>"            line moved between files
<bucket>: <file>: <verb> "<snippet>" (+N more)  several real changes, one file
<bucket>: <f1>, <f2>, <f3> (+X/-Y)              several files, snippets in body
<bucket>: <file>: new (N lines)                 new note
<bucket>: <file>: deleted
<bucket>: <file>: renamed from <old>
<bucket>: <file>: reordered (N lines)           every change cancels out
<b1>, <b2>: N notes (+X/-Y)                     backfill only: multi-bucket commit
```

- **Bucket** = top-level dir (`pessoal`, `trabalho`, `estudo`); root-level files
  use the label `notas`. Always present.
- **File label** = basename without extension.
- **Verbs**: `add`, `drop`, `done` (a `[ ]` -> `[x]` flip), `edit`, `new`,
  `deleted`, `renamed from`, `reordered`, and `->` for moves.
- No timestamp anywhere — git already stores committer date. Use
  `git log --format='%h %ad %s' --date=short` when dates are wanted.

### 3. Snippet derivation

1. Classify from `git diff --cached --name-status -M` (file level: A/M/D/R) and
   the `-U0` line diff (line level).
2. Cancel out moved text: any line whose normalised text appears both added and
   removed is a move, not a change — within a file (-> `reordered`) or across
   files (-> `src -> dst`). Normalisation strips a trailing
   ` - YYYY-MM-DD_HH:MM` and folds `[x]` to `[ ]`.
3. Strip markdown noise from the snippet: leading `- `, `* `, `> `, `#`+, `**`,
   `- [ ] `, `- [x] `, and the bookmarks table tag `|P| ` / `|A| ` / `|W| `.
4. Skip content-free candidate lines (`---`, blank) when choosing the headline.
5. Collapse `http(s)://host/...` to `(host)`.
6. Headline the first surviving real change; on multi-file commits, list
   filenames only and put per-file snippets in the body.

### 4. Length budget

Subject capped at **100 chars**. On overflow, truncate the **filename first**
(floor 20 chars, then `…`), then the snippet — content is what gets scanned, so
it keeps ~50 chars minimum, covering the median line in full.

### 5. Body

Only when it adds information:

- single-file, single-change -> **no body at all**
- multi-file -> one `  <file>: <verb> "<snippet>"` line per file
- one file, several real changes -> one line per change

No `--stat` in the body; `git log --stat` renders it better on demand.

### 6. Granularity: one commit per bucket per run

A run touching both `pessoal/` and `trabalho/` produces two commits so work and
personal history never interleave (5% of runs). Buckets committed in
alphabetical order. Paths are collected from `git status --porcelain -z`, grouped
by bucket, and staged as explicit `./`-prefixed paths after `--` (defeats git
pathspec magic on names like `:w`, and `core.quotepath` mangling of
`programação`).

### 7. Control flow: commit first, then sync

```sh
guard: if .git/rebase-merge, .git/rebase-apply or MERGE_HEAD exists
       -> notify-send + exit 1 (touch nothing)
for each bucket with changes (alphabetical):
       git add -A -- <paths>; git commit -q -m "$(generated)"
git pull --rebase -q || { git rebase --abort; notify-send; exit 1; }
git push -q && curl -s https://hc-ping.com/<uuid>
```

- Every 10-min tick makes a small topical commit whether or not there's network,
  so an offline afternoon becomes 12 clean commits instead of one fat batch.
- A rebase failure always leaves the repo clean (`--abort`) and is loud
  (`notify-send`); offline is silent and retried next tick.
- `DISPLAY=:0`, `XDG_RUNTIME_DIR=/run/user/$(id -u)` and
  `DBUS_SESSION_BUS_ADDRESS` are exported inside the script, following
  `profile-selector:9-11`, because the Ansible-managed cron line sets no
  environment and `notify-send` would otherwise fail silently. The Ansible cron
  entry stays untouched.
- **Healthcheck is now strict**: pings only after a successful push, so it means
  "notes reached GitHub". Ticks with no changes still ping (`git push` exits 0
  when there is nothing to push).

### 8. Code layout

- **New:** `~/.scripts/git-commit-message.sh` — reads the staged diff (or
  `--commit <sha>` for backtest/backfill) and prints a message to stdout.
  Testable in isolation, no commits involved.
- **Rewritten:** `~/.scripts/push-new-notes.sh` — stays ~30 lines; falls back to
  a timestamp message if the generator fails, so a sync is never lost.
- Both `#!/bin/sh`, dash-compatible per CLAUDE.md.

### 9. Untrack the noise (fixes the cause, not the symptom)

- `git rm --cached -- ./:w`
- add `*.bak` and `:w` to `~/projects/notas/.gitignore`

Removes 9.5% of polluted commits and keeps the generator free of special cases.
Both files remain in history; `add-bookmark` keeps writing its `.bak` locally.

### 10. Verification before going live

1. **Backtest:** run the generator with `--commit` over the last 300 commits and
   review the old-vs-new table in one pass.
2. **Dry run:** clone `notas` into the scratchpad with a local bare remote and
   exercise the full script there — bucket splitting, rebase, push — with zero
   risk to GitHub.

### 11. Backfill the last 200 commit messages

Rewriting history, in this order:

1. Deploy the new `push-new-notes.sh` first, so its mid-rebase guard turns any
   cron tick during the rewrite into a harmless no-op.
2. Phone: open the app, let it push pending edits. Desktop: `git fetch` and
   confirm they arrived.
3. `git branch backup/pre-backfill-2026-08-04`
4. `git push origin backup/pre-backfill-2026-08-04` — the old 200 commits now
   survive on GitHub no matter what happens next.
5. `git rebase --rebase-merges HEAD~200 --exec 'msg=$(sh ~/.scripts/git-commit-message.sh --commit HEAD) && git commit --amend -q -m "$msg" || true'`
6. `git push --force-with-lease`
7. Phone: delete the vault and re-clone from GitHub (a mobile *merge* instead of
   a reset would duplicate all 200 commits).

11 of those 200 commits span 2+ buckets and cannot be split retroactively, so
they get the combined `<b1>, <b2>: N notes (+X/-Y)` form.

No rewrite beyond 200 — deep history stays searchable by content:
`git log -S "kindle" --oneline`.

## Manual actions for me (not automatable from here)

- healthchecks.io dashboard: set period 10m / **grace 24h** on the notes check,
  otherwise the strict ping alerts every night while the laptop sleeps.
- Phone: re-clone the vault after the backfill force-push.

## Rejected, with reasons

- **LLM-generated messages** (`claude -p`): 144 runs/day, needs network + auth in
  a bare cron env, sends journaling and work notes to an API, and needs the
  extraction fallback anyway.
- **One commit per file:** would shred each to-do completion into a meaningless
  `drop X` + `add X` pair (39 of 101 multi-file commits).
- **`prepare-commit-msg` hook:** `.git/hooks` is untracked and unbacked-up, dies
  on re-clone, and the phone wouldn't run it.
- **Keeping the timestamp:** duplicates committer date and eats the subject.
- **`--stat` in the body:** duplicates `git log --stat`.
- **Full 7 246-commit rewrite:** same force-push cost as 200 for a fraction of
  the benefit, and bakes any heuristic bug into all of history.
