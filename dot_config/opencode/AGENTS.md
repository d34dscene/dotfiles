## Core Principles

- Prefer simple, explicit solutions over clever or abstract ones.
- Minimize dependencies. Do not introduce new dependencies unless there is a clear, concrete benefit.
- Optimize for readability and long-term maintainability over short-term speed.

## Code Style and Design

- Avoid unnecessary abstractions, frameworks, and indirection.
- Keep functions small, focused, and easy to reason about.
- Favor plain language constructs over meta-programming or magic behavior.

## Language-Specific Expectations

### Go

- Follow standard Go conventions and idioms.
- Prefer the standard library over third-party packages.
- Avoid over-engineering with interfaces unless they provide real value.
- Keep error handling explicit and readable.

### TypeScript / JavaScript

- Prefer simple, well-typed code over complex type gymnastics.
- Avoid heavy frameworks or runtime magic unless the project already depends on them.
- Keep types understandable to a human reading the code for the first time.
- Do not introduce build-time or runtime dependencies casually.

## Research and Discovery

- When external documentation is needed, use `context7`.
- When searching for examples, use `gh_grep` to find real-world usage.
