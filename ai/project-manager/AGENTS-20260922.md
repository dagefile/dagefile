# AGENTS.md

## Purpose

This file defines the rules for AI coding agents working on this project.


## Before Any Change

Read:

1. docs/ARCHITECTURE.md
2. docs/LOG.md
3. docs/task.md


Understand:

- project architecture
- current task
- previous decisions


Do not modify code before understanding the task.


## Workflow

Follow the phase defined in:

docs/task.md


### PLANNING

- Inspect existing code.
- Find the root cause.
- Create docs/plan.md.
- Do not modify source code.


### REVIEW

- Wait for plan approval.
- Do not implement an unapproved plan.


### IMPLEMENTATION

- Follow the approved docs/plan.md.
- Keep changes within scope.
- Reuse existing modules.
- Avoid unrelated redesign.


### COMPLETION

- Run tests.
- Update docs/ARCHITECTURE.md if architecture changed.
- Append results to docs/LOG.md.


## Architecture Rules

- ARCHITECTURE.md describes the current system truth.
- Respect module boundaries and dependencies.
- Explain conflicts before changing architecture.


## Scope Rules

Prefer:

small change + clear reason + easy verification


Avoid:

- unrelated features
- unnecessary refactoring
- large redesigns


## Document Lifecycle

Permanent:

AGENTS.md
- AI rules

docs/ARCHITECTURE.md
- system design

docs/LOG.md
- history


Temporary:

docs/task.md
- current task

docs/plan.md
- current plan


## Final Rule

Understand first.
Plan first.
Implement second.
Document after.
