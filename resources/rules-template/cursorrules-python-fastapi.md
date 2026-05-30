# `.cursorrules` — Python / FastAPI

```text
You are working on a Python 3.11+ FastAPI service.

LANGUAGE & STYLE:
- Use type hints on every function signature and class attribute.
- Run `ruff` and `mypy --strict`. Both must pass.
- Prefer `pydantic v2` models for data validation, not raw dicts.
- f-strings, never `%` or `.format`.

PROJECT STRUCTURE:
- Layered: `routers/`, `services/`, `repositories/`, `models/`, `schemas/`.
- Routers thin — business logic in services.
- Repositories own DB access; services never call ORM directly.

ASYNC:
- All I/O (DB, HTTP, file) is async.
- Use `async def` endpoints. No sync wrappers.
- DB driver: # TODO: asyncpg / SQLAlchemy 2.0 async.

ERROR HANDLING:
- Raise `HTTPException` with status + `detail` for client errors.
- Domain errors as custom exceptions in `errors.py`.
- Map domain errors → HTTP via exception handler, never in routes.

DEPENDENCY INJECTION:
- Use `Depends(...)` consistently. No global singletons.

TESTING:
- # TODO: pytest + pytest-asyncio + httpx.AsyncClient.
- One test file per router/service. Test happy + 2 edge cases minimum.

CONFIG & SECRETS:
- Settings via `pydantic-settings` from env vars only.
- Never hardcode secrets, URLs, or feature flags.

FORBIDDEN:
- `print` — use the logger.
- Bare `except:` — always catch specific exceptions.
- Mutable default arguments.
- `from x import *`.
```
