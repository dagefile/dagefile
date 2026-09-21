AI-Assisted Software Project Collaboration Workflow


========================
ROLES
========================

1. Project Owner (Human)

Responsibilities:
- Define project goals
- Make final decisions
- Run tests
- Review results
- Control project scope


2. Project Architect / Manager (ChatGPT)

Responsibilities:
- Understand project architecture
- Analyze problems
- Create task definitions
- Review implementation plans
- Check design consistency
- Prevent unnecessary complexity
- Protect long-term project direction

ChatGPT does not directly write production code unless explicitly requested.


3. Developer Agent (Opencode)

Responsibilities:
- Read project documents
- Inspect existing code
- Investigate problems
- Write implementation plans
- Modify code according to approved plans
- Update documentation

Opencode should not make major design decisions without approval.



========================
MAIN DEVELOPMENT CYCLE
========================


STEP 1: Report Problem

Project Owner provides:

- Project description
- architecture.md
- Current status
- Error logs
- Expected behavior
- Current behavior



STEP 2: Create task.md

ChatGPT creates task.md.

Purpose:

Define WHAT problem needs solving and WHY.


task.md format:

------------------------

# Task

## Problem

Describe the issue.


## Evidence

Include:
- logs
- errors
- screenshots
- test results


## Goal

What should become true after this change?


## Constraints

What must NOT change?

Examples:
- Do not redesign architecture
- Do not change unrelated modules
- Keep compatibility
- Keep existing storage format


## Expected Areas

Possible modules involved.

------------------------



STEP 3: Opencode Investigation

Give Opencode:

"do task.md"


Opencode rules:

1. Read architecture.md first
2. Understand current implementation
3. Inspect related code
4. Do not modify code yet
5. Create plan.md



STEP 4: Create plan.md

Opencode writes:

plan.md


plan.md format:

------------------------

# Implementation Plan


## Goal

What will be changed?


## Current Behavior

How does the system work now?


## Root Cause

Why does the problem happen?


## Files To Modify

List files.


## Design Changes

Explain the planned changes.


## Testing Plan

Explain how to verify.


## Architecture Impact

Explain if architecture.md needs updates.

------------------------



STEP 5: Plan Review

Project Owner sends plan.md to ChatGPT.


ChatGPT reviews:

Architecture:
- Does this fit the current design?
- Are the correct modules selected?


Scope:
- Is the solution too large?
- Are unnecessary features added?


Safety:
- Could it break existing features?
- Are there security concerns?


Maintainability:
- Will future development become harder?


Result:

APPROVED

or

NEEDS REVISION



STEP 6: Implementation

After approval:


Tell Opencode:

"implement the approved plan.md"


Opencode:

- modifies code
- follows plan.md
- keeps changes focused
- avoids unrelated changes



STEP 7: Update Documentation

After code changes:

Update:

architecture.md


Important:

The order must be:

Code
  |
  v
Test
  |
  v
Update architecture.md


Never update architecture.md before the code works.



STEP 8: Testing

Project Owner:

- builds project
- runs project
- tests functionality


Send back:

- logs
- errors
- unexpected behavior


Then start a new cycle.



========================
IMPORTANT RULES
========================


Rule 1: Protect Architecture

Before adding code:

Ask:

"Does this belong in the current architecture?"


Avoid solving every problem by adding more code.



Rule 2: Small Changes

Prefer:

Small task
Small plan
Small code change


Avoid:

Large rewrite without planning.



Rule 3: Prevent AI Scope Expansion

Example:

Task:

"Implement U2F_AUTHENTICATE"


Do NOT automatically add:

- new GUI
- storage rewrite
- crypto rewrite
- unrelated features


New features require new tasks.



Rule 4: Use Git Before AI Changes

Before changes:

git add .
git commit -m "before AI change"


After changes:

git diff


Review all modifications.



========================
PROJECT COMMUNICATION FORMAT
========================


When starting a new project, provide:

1. architecture.md

2. Project goal

3. Current status

4. Current problem

5. Logs/errors


Then ChatGPT acts as:

- project manager
- architecture reviewer
- design reviewer



========================
WORKFLOW SUMMARY
========================


Human
(Project Owner)

        |
        |
        v

Problem / Goal

        |
        v

ChatGPT
(Project Architect)

        |
        |
        v

task.md

        |
        v

Opencode
(Developer)

        |
        |
        v

plan.md

        |
        v

ChatGPT Review

        |
        |
        v

Approved Plan

        |
        v

Opencode

        |
        |
        v

Code Changes

        |
        v

Testing

        |
        v

Update architecture.md

        |
        v

Next Task


========================
FINAL PRINCIPLE
========================

Human controls the vision.

ChatGPT controls architecture and review.

Opencode writes the implementation.

The goal is not to write code faster.

The goal is to build the correct system with controlled changes.
