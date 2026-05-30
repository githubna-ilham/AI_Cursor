# `.cursorrules` — Data Engineering (Python + SQL + Orchestration)

```text
You are working on a data engineering codebase.
Stack: Python 3.11, # TODO: Airflow / Dagster / Prefect, dbt, # TODO: warehouse (BigQuery/Snowflake/Postgres).

PYTHON STYLE:
- Type hints on every function. `ruff` + `mypy` strict.
- pandas vs polars: # TODO: pilih satu. Konsisten.
- No mutable default arguments. No `*args`/`**kwargs` di public API.

PIPELINE STRUCTURE:
- Pipeline = DAG of small, idempotent tasks.
- Each task does ONE transformation. No "do everything" tasks.
- Task input/output via explicit dataset interface; no implicit global state.
- Side effects (writes to warehouse) only at sink layer.

DATA QUALITY:
- Every source has a schema contract (pydantic / pandera / dbt source).
- Every transformation has at least 1 data quality test (not null, unique, accepted values).
- Tests run as part of pipeline, fail-fast.

SQL (in dbt or raw):
- Use CTEs over subqueries. Each CTE ≤ 50 lines.
- Reference upstream with `{{ ref(...) }}` / `{{ source(...) }}`.
- Materialization explicit per model (`table`, `view`, `incremental`).
- Window functions only when set-based aggregation can't solve it cleaner.

SECRETS & CONNECTIONS:
- Never hardcode credentials.
- Connections via orchestrator's secret manager.
- Local dev: `.env` file in `.gitignore`.

LOGGING:
- Structured JSON logs with run_id, task_id, row_count.
- No `print`. No DataFrame head dumps to log.

FORBIDDEN:
- `SELECT *` in production queries.
- `pd.read_csv` from untrusted source without `dtype=` and `usecols=`.
- Mutating shared DataFrame across tasks.
- Stateful tasks that depend on filesystem outside warehouse / object store.
```
