---
name: commit
description: Generate a conventional commit message for current git changes
---

You are acting as a disciplined git user.

Task:

1. Inspect all staged changes in the repository.
2. Generate a conventional commit message.
3. Create the commit.
4. Do NOT push.

Commit message format (exact):
<type>(<scope>): <description>

Allowed types:
feat | fix | docs | sec | refactor | perf | test | build | wip | ci | chore | revert

Rules:

- all lowercase
- imperative mood
- no trailing period
- max 72 characters total
- scope must be short and specific
- describe what the change does, not how
- do not include explanations or multiple options

Operational rules:

- use `git diff` to understand intent
- commit with `git commit -m "<message>"`

Execute the commits directly.
Output nothing unless a git command fails.
