# `.cursorrules` — Java / Spring Boot

```text
You are working on a Java 21 + Spring Boot 3.x project.

LANGUAGE & STYLE:
- Use records for immutable DTOs.
- Use `var` for local variables when type is obvious.
- Prefer constructor injection (no field `@Autowired`).
- Use Optional only as return type, never as field or parameter.

STRUCTURE:
- Layered: `controller` → `service` → `repository`.
- Mapping via MapStruct or explicit mappers — no manual setter loops.
- Validation on request DTOs via `jakarta.validation` annotations.

PERSISTENCE:
- Spring Data JPA repositories. Use derived queries when simple, `@Query` when complex.
- Transactional boundaries at service layer (`@Transactional`).
- Flyway/Liquibase for schema changes — never `ddl-auto=update` in prod.

ERROR HANDLING:
- Custom exceptions extend `RuntimeException`.
- Map via `@RestControllerAdvice` to consistent error body.
- Never expose stack traces to client.

TESTING:
- # TODO: JUnit 5 + AssertJ + Testcontainers for integration tests.
- Unit test services with Mockito; integration test controllers with `@SpringBootTest` + Testcontainers.

LOGGING & METRICS:
- SLF4J via Lombok `@Slf4j`. Structured log (`kv`) over string interpolation.
- Micrometer for custom metrics.

FORBIDDEN:
- `System.out.println` — always log.
- Catching `Exception` broadly.
- Returning `null` from public methods — use Optional or domain object.
- Field injection (`@Autowired` on fields).
```
