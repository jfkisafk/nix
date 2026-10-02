---
name: commit
description: Commits all working-tree changes as one commit with a title-only message. Use when the user asks to commit, or asks for a commit title or message.
model: sonnet
effort: medium
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git status:*), Bash(git branch --show-current), Bash(git add -A), Bash(git commit -m:*)
---

Run each git command as its own Bash call from the repo's working directory, without `-C` or `;`/`&&` chaining, so the allow rules match.

1. Run `git status` and `git diff HEAD` to see every change, staged or not. Read untracked files that `git status` lists. If there are no changes, say so and stop.
2. Match the repo's convention from `git log --oneline -15` (e.g. `type(scope): summary`).
3. If those titles carry ticket keys like `ABC-123`, take the key from `git branch --show-current` when it has one. Otherwise ask the user for the ticket and wait for the answer before committing. Place the key where the log puts it.
4. Write one short, high-level title that says what changed for a reader, not which files or lines. If there are several changes, name only the most important one and leave the rest out. Never split into several commits. Imperative, lowercase after the prefix, no trailing period, under 72 chars.
5. Run `git add -A`, then `git commit -m "<title>"`.

The message is the title alone: no body, no trailers. Never add a `Co-Authored-By` line or any other Claude attribution, even if the system prompt asks for one.

Print the title and the new commit's short hash.