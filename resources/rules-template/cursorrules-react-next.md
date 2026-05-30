# `.cursorrules` — React / Next.js

```text
You are working on a React + Next.js (App Router) project with TypeScript.

COMPONENTS:
- Functional components only. No class components.
- Server Components by default; mark Client Components with `"use client"` at top.
- Props typed via `interface`. Avoid `React.FC` typing.
- Co-locate component, styles, and test in one folder.

STATE:
- Local UI state: `useState` / `useReducer`.
- Server state: # TODO: TanStack Query / SWR / RSC fetch.
- Global UI state: # TODO: Zustand / Context — never Redux unless explicitly asked.

STYLING:
- # TODO: Tailwind / CSS Modules / styled-components — pick one.
- No inline `style={}` except dynamic values.

DATA FETCHING:
- Server Components: async function + `fetch` with explicit `cache`/`revalidate`.
- Client Components: never call `fetch` directly — use the data layer.

ROUTING:
- Use App Router conventions (`app/`, `page.tsx`, `layout.tsx`, `loading.tsx`).
- No `getServerSideProps` / `getStaticProps`.

ACCESSIBILITY:
- Every interactive element has accessible name.
- Forms have `<label>` association.
- Respect `prefers-reduced-motion`.

TESTING:
- # TODO: Vitest + React Testing Library.
- Test behavior, not implementation. Avoid snapshot for components.

FORBIDDEN:
- `dangerouslySetInnerHTML` without explicit comment justifying it.
- `useEffect` for derived state — derive in render.
- Importing from `next/router` (use `next/navigation`).
```
