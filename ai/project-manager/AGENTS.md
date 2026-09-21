# AGENTS.md

## Purpose

This file defines the working rules for AI coding agents in this project.

The agent must follow these rules before inspecting, planning, modifying, or documenting the project.


========================
PROJECT DOCUMENTS
========================

Before making any changes, read:

1. ARCHITECTURE.md

Location:

docs/ARCHITECTURE.md

Purpose:

Understand:
- project goals
- system boundaries
- module responsibilities
- dependency rules
- design decisions
- current implementation status


2. LOG.md

Location:

docs/LOG.md

Purpose:

Understand:
- previous completed tasks
- important decisions
- historical changes


3. task.md

Location:

docs/task.md

Purpose:

Understand:
- current task
- current phase
- current instructions


========================
CURRENT PHASE SYSTEM
========================

The current development phase is always defined in:

docs/task.md


The agent must follow the current phase only.


Available phases:


------------------------
PHASE 1: PLANNING
------------------------

Goal:

Understand the problem and create a solution plan.


Actions:

1. Read:
   - AGENTS.md
   - docs/ARCHITECTURE.md
   - docs/LOG.md
   - docs/task.md

2. Inspect the existing implementation.

3. Identify:
   - current behavior
   - expected behavior
   - root cause
   - affected modules
   - possible risks

4. Create:

docs/plan.md


Do not modify source code during this phase.


------------------------
PHASE 2: REVIEW
------------------------

Goal:

Validate the proposed solution before implementation.


Actions:

1. Wait for plan.md review.

2. If the plan is rejected:
   - revise plan.md
   - update task.md if the task definition is incorrect

3. Do not implement an unapproved plan.


------------------------
PHASE 3: IMPLEMENTATION
------------------------

Goal:

Implement the approved solution.


Actions:

1. Read the approved docs/plan.md.

2. Modify code according to the plan.

3. Keep changes within the approved scope.

4. Reuse existing modules whenever possible.

5. Do not redesign unrelated parts of the project.


------------------------
PHASE 4: COMPLETION
------------------------

Goal:

Finish the task and record the result.


Actions:

1. Run tests or verification steps.

2. Update:

docs/ARCHITECTURE.md

only if the actual design changed.


3. Append an entry to:

docs/LOG.md


Include:
- date
- task summary
- files changed
- important decisions
- test results
- architecture changes


4. Report:
- completed changes
- modified files
- test results
- remaining issues



========================
ARCHITECTURE RULES
========================

The architecture document represents the current truth of the project.


Rules:

1. Follow the design defined in ARCHITECTURE.md.

2. Respect module boundaries and dependency direction.

3. Do not introduce unnecessary architectural changes.

4. If a requested change conflicts with ARCHITECTURE.md:
   - explain the conflict first
   - do not silently redesign the system


5. If the implementation intentionally changes the architecture:
   - update ARCHITECTURE.md
   - explain why the change was necessary



========================
SCOPE CONTROL
========================

Solve the requested problem only.


Do not add:

- unrelated features
- unnecessary refactoring
- large redesigns
- new abstractions without a clear reason


Prefer:

small change
+
clear reason
+
easy verification



========================
CODE CHANGE RULES
========================

Before modifying code:

1. Understand the existing implementation.

2. Identify the correct module.

3. Confirm the change belongs there.


During implementation:

- keep changes focused
- preserve existing behavior
- avoid breaking unrelated features
- follow existing coding style



========================
DOCUMENT LIFECYCLE
========================


Permanent documents:

AGENTS.md

- AI working rules
- rarely changed


docs/ARCHITECTURE.md

- project design
- updated when architecture changes


docs/LOG.md

- project history
- append only


Temporary documents:

docs/task.md

- current task
- replaced every development cycle


docs/plan.md

- current solution plan
- replaced every development cycle



========================
FINAL PRINCIPLE
========================

The human controls the project direction.

The AI agent follows the defined workflow.

The architecture document protects system design.

The plan document controls implementation.

The log document preserves project memory.

Do not code first.
Understand first.
Plan first.
Then implement.
