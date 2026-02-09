---
name: review
description: Review code for simplification and optimization
---

Review the code at the provided path: $ARGUMENTS

Tasks:

- Identify unnecessary complexity and suggest simpler alternatives
- Point out redundant logic, dead code, or over-engineering
- Suggest performance or readability improvements where they actually matter
- Highlight patterns that could be extracted or reused
- Call out any obvious bugs or risky assumptions

Guidelines:

- Do NOT rewrite everything, focus on high-impact changes
- Prefer clarity over cleverness
- Assume modern best practices for the language/framework in use
- If reviewing a folder, consider cross-file improvements and structure
