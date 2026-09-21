Before making changes to this project:

1. Read `ARCHITECTURE.md`.

2. Understand:
   - the project goal
   - the relevant module
   - module boundaries
   - dependency direction
   - existing design decisions

3. Follow the architecture and dependency rules defined in `ARCHITECTURE.md`.

4. Before writing code:
   - inspect the existing implementation
   - identify the root cause
   - create a `plan.md` describing the proposed change

5. Do not modify code until the implementation plan has been reviewed and approved.

6. Do not redesign unrelated parts of the project.

7. If the requested change conflicts with `ARCHITECTURE.md`, explain the conflict before changing the architecture.

8. Prefer the smallest change that solves the problem.

9. Reuse existing modules and functionality before adding new abstractions.

10. If the implementation is intentionally changed in a way that changes the architecture:
    - update `ARCHITECTURE.md` as part of the same task
    - explain what changed and why

11. After implementation:
    - verify the change with tests or runtime checks
    - summarize modified files and behavior changes
