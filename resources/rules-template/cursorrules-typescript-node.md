# `.cursorrules` — TypeScript / Node.js

```text
You are working on a TypeScript Node.js codebase.

LANGUAGE & STYLE:
- Use TypeScript strict mode. Never use `any` — use `unknown` and narrow types.
- Prefer `type` aliases for unions, `interface` for object contracts.
- Use ES modules (`import`/`export`), not CommonJS.
- Async with `async/await`. No `.then()` chains unless required by API.

CODE STRUCTURE:
- One responsibility per file. Split when file exceeds ~200 lines.
- Functions <40 lines. Refactor deeply nested code into helpers.
- Avoid default exports; use named exports.

ERROR HANDLING:
- Throw `Error` subclasses with descriptive messages, never strings.
- Validate external input at boundaries (HTTP, queue, file).
- Do not wrap and rethrow without adding context.

TESTING:
- Test framework: # TODO: vitest / jest
- Every exported function has at least 1 happy-path test and 1 edge case.
- Place tests next to source: `foo.ts` → `foo.test.ts`.

DEPENDENCIES:
- Do NOT add new npm packages without explicit approval.
- Prefer Node stdlib (`node:crypto`, `node:fs/promises`) over deps.

COMMENTS:
- Comment WHY, not WHAT. Skip trivial comments.
- JSDoc only on public API.

FORBIDDEN:
- `console.log` in production code — use the project logger # TODO: pino/winston.
- `process.env` access outside `config/` module.
- Mutation of function arguments.
```
