---
name: autocommit
description: Automatically group unstaged files into logical commits and commit them
---

You are acting as a disciplined git user.

Task:

1. Inspect all unstaged changes in the repository.
2. Group files into logical, minimal commits based on purpose and scope.
3. For each group:
   - Stage only the files in that group.
   - Generate a conventional commit message.
   - Create the commit.
4. Do NOT push.
5. Do NOT amend existing commits.
6. Leave already-staged files untouched.

Commit message format (exact):
<type>(<scope>): <description>

Allowed types:
feat | fix | docs | sec | refactor | perf | test | build | wip | ci | chore | revert

Rules:

- lowercase only
- imperative mood
- no trailing period
- max 72 characters total
- scope must be short and concrete
- describe what the change does, not how
- one message per commit
- no explanations, summaries, or alternatives

Operational rules:

- use `git status --porcelain` to detect unstaged files
- use `git diff` to understand intent
- stage files with `git add <files>`
- commit with `git commit -m "<message>"`
- if a file does not clearly belong to any group, commit it last as `chore(misc): ...`

Execute the commits directly.
Output nothing unless a git command fails.
