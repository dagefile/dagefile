# AI-Assisted Software Project Collaboration Workflow

## PURPOSE

Define a controlled, zero-cost collaboration workflow between:

* **Human Project Owner** (Vision & final decisions)
* **ChatGPT** (Architect, task designer, and reviewer)
* **AI Coding Agent / Opencode** (Implementation worker)

**Goal:** Build correct software cleanly, protect system architecture, prevent AI scope creep, and keep project memory organized.

---

## ROLES

### 1. Project Owner (Human)

* Defines project goals and scope.
* Runs tests and reviews final results.
* Owns the project direction.

### 2. Project Architect / Manager (ChatGPT/Gemini/Grok/...)

* Understands system architecture.
* Creates tasks and reviews implementation plans.
* Prevents unnecessary complexity and scope expansion.

### 3. Developer Agent (Opencode / AI Worker)

* Reads project documents and inspects code.
* Creates and updates implementation plans (`plan.md`).
* Executes approved plans without making major architecture choices alone.

---

## PROJECT DOCUMENTS

* **`AGENTS.md`**: AI working rules (Rare changes).
* **`docs/ARCHITECTURE.md`**: Current system design and dependencies (Update when architecture changes).
* **`docs/LOG.md`**: Append-only development history.
* **`docs/task.md`**: Immutable problem definition for the current task (Locked once written).
* **`docs/plan.md`**: The single, living implementation plan (Overwritten every round).
* **`docs/fix.md`**: The latest feedback/correction note from review (Created starting Round 2; overwritten every round if a plan fails).

---

## DEVELOPMENT CYCLE & THE REVISION LOOP

The workflow moves through strict phases:

### Phase 1: Planning (Round 1)

1. **ChatGPT** creates **`docs/task.md`** (Defines problem, goal, constraints, and target files). *This file is now locked and immutable.*
2. **AI Worker** reads `task.md`, investigates the code, and creates **`docs/plan.md`**. No code changes yet.

### Phase 2: Review & Revision Loop

**ChatGPT** reviews **`docs/plan.md`** against **`docs/task.md`**.

* **If APPROVED:** Move to Phase 3 (Implementation).
* **If NOT GOOD (Revision Loop):**
* **Round 2+:** ChatGPT writes a new **`docs/fix.md`** explaining what failed in the current plan. (`task.md` remains untouched).
* The AI Worker reads **`task.md`** + the latest **`docs/fix.md`**, then overwrites **`docs/plan.md`** with a corrected plan.
* Send the new `plan.md` back to ChatGPT for review.
* **The 3-Strikes Reset Rule:** If a task reaches Round 4 or Round 5 and still fails, the task itself is likely too ambiguous. Stop, rewrite `task.md`, and start over.



### Phase 3: Implementation

* AI Worker follows the approved **`docs/plan.md`** to modify code.
* Keeps changes strictly focused on the task.

### Phase 4: Completion

1. Human runs tests.
2. Update **`docs/ARCHITECTURE.md`** if the design changed.
3. Append a summary to **`docs/LOG.md`**.
4. Clear temporary files (`task.md`, `plan.md`, `fix.md`) for the next task.

---

## IMPORTANT RULES

* **Rule 1: Protect Architecture:** Ask *"Does this belong?"* before adding code or complexity.
* **Rule 2: Small Changes:** Small task + small plan + small code change beats large rewrites.
* **Rule 3: Prevent AI Scope Expansion:** Tasks are strictly bounded. Unrelated features require new tasks.
* **Rule 4: Git Safety:** Always create a `git commit` checkpoint before AI changes. If tests fail, use `git reset --hard HEAD` to revert instantly.
* **Rule 5: Context Hygiene:** Keep files concise to prevent free-tier AI token pollution and hallucinations.
