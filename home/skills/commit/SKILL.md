---
name: commit
description: Commits all working-tree changes as one commit with a title-only message. Use when the user asks to commit, or asks for a commit title or message.
model: sonnet
effort: medium
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git status:*), Bash(git branch --show-current), Bash(git add -A), Bash(git commit -m:*)
---

Run each git command as its own Bash call from the repo's working directory, without `-C` or `;`/`&&` chaining, so the allow rules match.

1. Run `git status` and `git diff HEAD` to see every change, staged or not. Read untracked files that `git status` lists. If there are no changes, say so and stop.
2. If the diff makes the repo's `AGENTS.md`, `CLAUDE.md` or README (any case) wrong or incomplete about something they already cover, update them so they're correct; the commit then includes those edits. Most diffs need no doc change.
3. Match the repo's convention from `git log --oneline -15` (e.g. `type(scope): summary`).
4. If those titles carry ticket keys like `ABC-123`, take the key from `git branch --show-current` when it has one. Otherwise ask the user for the ticket and wait for the answer before committing. Place the key where the log puts it.
5. Write one short, high-level title that says what changed for a reader, not which files or lines. If there are several changes, name only the most important one and leave the rest out. Never split into several commits. Imperative, lowercase after the prefix, no trailing period, under 72 chars.
6. Run `git add -A`, then `git commit -m "<title>"`.

The message is the title alone: no body, no trailers.

Print the title and the new commit's short hash.