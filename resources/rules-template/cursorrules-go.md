# `.cursorrules` — Go

```text
You are working on a Go 1.22+ codebase.

LANGUAGE & STYLE:
- Run `gofmt`, `goimports`, `staticcheck`, `golangci-lint` — all must pass.
- Idiomatic Go: short variable names in tight scopes; meaningful names at package level.
- Accept interfaces, return concrete types.
- Wrap errors with `fmt.Errorf("...: %w", err)`. Sentinel errors via `errors.Is/As`.

PROJECT STRUCTURE:
- Standard layout: `cmd/<bin>/main.go`, `internal/<domain>/`, `pkg/<shared>/` only if truly shared.
- One package per directory. Package name = directory name.
- No god packages (`utils`, `common`, `helpers`).

CONCURRENCY:
- Goroutines own their lifecycle (`context.Context` always).
- Channels: sender closes, receiver ranges.
- Use `sync.WaitGroup` or `errgroup` — never sleep-based sync.
- Race detector must pass in CI.

HTTP:
- Use `net/http` stdlib + chi/echo as needed. # TODO: pick router.
- Middlewares stateless; pass deps via constructor.

TESTING:
- Table-driven tests with `t.Run(name, ...)`.
- Avoid mocking — use real implementations or `httptest`/`testcontainers`.
- Coverage target: # TODO: 70%+

DEPENDENCIES:
- Pin versions in `go.mod`. Run `go mod tidy` before commit.
- Prefer stdlib over third-party for crypto, http, json.

FORBIDDEN:
- `panic` in library code — return error.
- `init()` with side effects (DB, HTTP).
- Goroutines without context cancellation.
- `interface{}` / `any` when a concrete type works.
```
