# `.cursorrules` — Laravel / PHP

```text
You are working on a Laravel 10+/11+ project using PHP 8.2+.

LANGUAGE & STYLE:
- Follow PSR-12. Run `pint` before commit.
- Use typed properties and return types on every method.
- Use `readonly` properties for value objects.
- Use enums (PHP 8.1+) for status/type, not string constants.

STRUCTURE:
- Routes thin. Logic in Controllers, Controllers thin — push to Actions / Services.
- Use Form Requests for validation, never `$request->validate()` inline.
- Use Eloquent Resources for API responses, never raw `toArray()`.
- Repositories optional; prefer queryable Eloquent scopes.

DATABASE:
- Every change requires a migration. Never edit existing migrations on shared branches.
- Use seeders + factories for test data.
- Query with eager loading (`with()`) to avoid N+1.

TESTING:
- # TODO: PHPUnit / Pest.
- Use `RefreshDatabase` trait. Don't mock Eloquent — use SQLite/in-memory.
- Every feature endpoint has a feature test.

ERROR HANDLING:
- Custom exceptions extend a base `AppException`.
- Render via `Handler::render()` for API consistency.

QUEUE & JOBS:
- Long tasks → Jobs, never in HTTP request.
- Jobs idempotent. Set `tries`, `backoff`, and `uniqueId` explicitly.

FORBIDDEN:
- `env()` outside `config/`. Use `config('...')`.
- `dd()` / `dump()` in committed code.
- Mass-assignment vulnerabilities — always declare `$fillable` or `$guarded`.
- Raw SQL with concatenation. Always parameterize.
```
