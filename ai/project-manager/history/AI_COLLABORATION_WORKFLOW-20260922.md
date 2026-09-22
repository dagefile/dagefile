# AI-Assisted Software Project Collaboration Workflow


========================
PURPOSE
========================

This document defines the collaboration workflow between:

- Human Project Owner
- ChatGPT (Project Architect / Manager)
- AI Coding Agent (Opencode or other AI worker)


The goal is:

Build correct software through controlled changes.

The goal is not simply writing code faster.

The goal is:
- maintain architecture quality
- prevent uncontrolled AI changes
- keep project knowledge organized
- make development repeatable



========================
ROLES
========================


## 1. Project Owner (Human)

Responsibilities:

- Define project goals
- Make final decisions
- Control project scope
- Run tests
- Review results
- Provide feedback and requirements


The human owns the project direction.


------------------------


## 2. Project Architect / Manager (ChatGPT)

Responsibilities:

- Understand project architecture
- Analyze problems
- Create task definitions
- Review implementation plans
- Check design consistency
- Prevent unnecessary complexity
- Protect long-term project direction


ChatGPT does not directly write production code unless explicitly requested.


ChatGPT focuses on:

- What should be done
- Why it should be done
- Whether the proposed solution is correct



------------------------


## 3. Developer Agent (Opencode or Other AI Worker)

Responsibilities:

- Read project documents
- Inspect existing code
- Investigate problems
- Create implementation plans
- Modify code according to approved plans
- Update documentation
- Report results


The worker executes approved plans.

The worker does not make major architectural decisions alone.



========================
PROJECT DOCUMENT SYSTEM
========================


Permanent documents:


AGENTS.md

Purpose:
- AI working rules
- workflow rules

Changes:
- rare


docs/ARCHITECTURE.md

Purpose:
- current system design
- modules
- dependencies
- design decisions

Changes:
- update when architecture changes


docs/LOG.md

Purpose:
- development history

Rules:
- append only



Temporary documents:


docs/task.md

Purpose:
- current problem definition
- current development phase

Lifecycle:
- replaced every task cycle


docs/plan.md

Purpose:
- current implementation plan

Lifecycle:
- replaced every task cycle



========================
DEVELOPMENT CYCLE
========================


The project follows this cycle:


Human
 |
 |
 v

Problem Identification

 |
 |
 v

ChatGPT creates task.md

 |
 |
 v

AI Worker creates plan.md

 |
 |
 v

ChatGPT reviews plan.md

 |
 |
 v

Approved Plan

 |
 |
 v

AI Worker implements

 |
 |
 v

Testing

 |
 |
 v

Documentation update

 |
 |
 v

LOG.md update

 |
 |
 v

Next Task



========================
PHASE SYSTEM
========================


The current phase is always defined in:

docs/task.md



------------------------
PHASE 1: PLANNING
------------------------


ChatGPT creates:

docs/task.md


The task defines:

- Problem
- Evidence
- Goal
- Constraints
- Expected areas


AI Worker:

- reads project documents
- investigates code
- creates plan.md

No code changes.



------------------------
PHASE 2: REVIEW
------------------------


ChatGPT reviews plan.md.


Review questions:

Architecture:
- Does it fit the existing design?
- Are the correct modules selected?


Scope:
- Is the solution too large?
- Is unrelated work included?


Safety:
- Could existing features break?


Maintainability:
- Will this make future development harder?


Result:

APPROVED

or

NEEDS REVISION



------------------------
PHASE 3: IMPLEMENTATION
------------------------


AI Worker:

- follows approved plan.md
- modifies code
- keeps changes focused
- avoids unrelated changes


The implementation must match the approved plan.



------------------------
PHASE 4: COMPLETION
------------------------


After implementation:


1. Run tests.

2. Update:

docs/ARCHITECTURE.md

if the actual design changed.


3. Append:

docs/LOG.md


4. Report:

- changed files
- test results
- remaining issues



========================
IMPORTANT RULES
========================


## Rule 1: Protect Architecture

Before adding code:

Ask:

"Does this belong in the current architecture?"


Do not solve every problem by adding more code.



## Rule 2: Small Changes

Prefer:

Small task
+
Small plan
+
Small code change


Avoid:

Large rewrite without planning.



## Rule 3: Prevent AI Scope Expansion


Example:

Task:

"Implement U2F_AUTHENTICATE"


Do not automatically add:

- GUI
- storage redesign
- crypto redesign
- unrelated features


New features require new tasks.



## Rule 4: Git Safety


Before AI changes:

Create a checkpoint:

git commit


After changes:

Review:

git diff



========================
STARTING A NEW PROJECT
========================


Provide ChatGPT:

1. Project goal

2. Current status

3. ARCHITECTURE.md

4. Current problem

5. Logs/errors


ChatGPT becomes:

- project architect
- task designer
- plan reviewer



========================
FINAL PRINCIPLE
========================


Human controls the vision.

ChatGPT controls architecture and review.

AI Worker writes implementation.

Documents preserve project memory.

The workflow is:

Understand first.

Plan first.

Review first.

Implement second.

Test.

Document.

Repeat.
