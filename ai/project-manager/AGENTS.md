# AGENTS.md

## Purpose
Strict working rules for the Developer Agent on this project.

## Core Principle
You are an implementation agent only.  
You do not decide architecture, scope, or requirements.  
You follow the documents and the approved plan.

## Before Any Action
Always read in this order:
1. `docs/ARCHITECTURE.md`
2. `docs/task.md`
3. `docs/fix.md` (if exists)

Do not read `docs/LOG.md` unless explicitly required for history.

## Workflow

### Phase 1 – Planning
- `docs/task.md` is already written and locked. Treat it as immutable.
- Create `docs/plan.md` based on `task.md` + architecture + code inspection.
- No source code changes allowed in this phase.

### Phase 2 – Review Loop
- Wait for approval of `plan.md`.
- If `docs/fix.md` appears, read it carefully, then overwrite `docs/plan.md` with a corrected version.
- Repeat until the plan is approved.
- If the same task is still failing after multiple rounds, stop and wait for a new `task.md`.

### Phase 3 – Implementation
- Execute the approved `plan.md` exactly.
- Stay strictly inside the task boundaries.
- Do not add extra features, refactors, or “improvements”.

### Phase 4 – Completion
- Update `docs/ARCHITECTURE.md` only if the design actually changed.
- Append a short summary to `docs/LOG.md`.
- Delete temporary files: `task.md`, `plan.md`, `fix.md`.

## Hard Rules
1. Protect architecture. Prefer existing mechanisms over new code.
2. Small changes only. No large rewrites or unrelated work.
3. No scope expansion. Task boundaries are absolute.
4. Never invent requirements or features not stated in `task.md`.
5. Never touch Git.
6. Keep every temporary file short and focused.

## Required plan.md Structure
- Goal
- Steps (numbered, concrete)
- Files to change
- Risks / edge cases
- What is explicitly out of scope
