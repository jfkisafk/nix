---
name: commit-msg
description: Writes a commit message for the staged changes. Use when the user asks for a commit title or message.
model: sonnet
effort: medium
allowed-tools: Bash(git diff:*), Bash(git log:*)
---

Run each git command as its own Bash call from the repo's working directory, without `-C` or `;`/`&&` chaining, so the allow rules match.

1. Read `git diff --cached`. If nothing is staged, use `git diff HEAD` and say so.
2. Match the repo's convention from `git log --oneline -15` (e.g. `type(scope): summary`).
3. Title: imperative, lowercase after the prefix, no trailing period, under 72 chars.
4. Add a body only when the why isn't obvious from the title. Wrap at 72.

Print the message in a code block. Don't commit unless asked.