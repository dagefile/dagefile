Here is the complete, integrated plain-text layout for your project manifest. I have cleaned up the separators, integrated the new `.agents/task.md` file requirements explicitly into the rules for both **EditorA** and **TestB**, and fixed the path names so they are completely uniform across the entire document.

# ================================================================================
LOCAL PROJECT MANIFEST: STATE-MACHINE PROTOCOL

This project operates under a strict, isolated multi-agent architecture. Every AI interacting with this workspace must pass the global identity check, assume its assigned codename, and rigorously respect the filesystem-driven state machine detailed below.

---

1. FILE OWNERSHIP, PERMISSIONS & FORMATS

---

[ File Owner ] Human Architect
[ Permissions ]: Human: WRITE-ONLY | Agents: READ-Write
[ Operational Rule ]: The human inserts new feature requests or modifications at the VERY TOP of this file, directly under the control header.
[ Agent Rule ]: EditorA must always read the first task it encounters below the header. If that task is marked [STATUS: PENDING], EditorA drops all other work and targets it.

[ Example Structure for .agents/task.md ]:

# Human Instruction Queue

# Always insert new tasks directly below this line!

## [TASK-002] - Implement I2C Multiplexer scan timing

* Timestamp: 2026-07-06 12:30
* Status: PENDING
* Requirements: Optimize the ESP32 pin switching delays down to 5 microseconds.

## [TASK-001] - Add sensor calibration routine

* Timestamp: 2026-07-06 11:15
* Status: RESOLVED (See .agents/change.md #004)
* Requirements: Store the average ambient capacitance per pad in an array at boot.

[ Permissions ]: EditorA: APPEND-ONLY | TestB: READ-ONLY
[ Operational Rule ]: EditorA must never delete, modify, or rewrite past rows. It only appends new rows to the bottom of the log.
[ Format Layout ]: [CHANGE_ID] | [TIMESTAMP] | [DESCRIPTION] | [TARGET_ID (Ref: BUG-XXXX or TASK-XXXX)]

[ Example Structure for .agents/change.md ]:

# System Change Log

#001 | 2026-07-06 11:40 | Initialized main loop wrapper.
#002 | 2026-07-06 11:45 | Added error boundaries to parser. | Ref: BUG-a9d2

[ Permissions ]: TestB: READ/WRITE | EditorA: READ-ONLY
[ Operational Rule ]: TestB maintains its testing checkpoint tracker at the very top of this file. It appends active bugs below. When an open bug passes verification, TestB completely deletes that bug's entry from the active list.

[ Example Structure for .agents/test.md ]:

# TestB Control Center

LAST_TESTED_CHANGE_ID: #002

## Active Bug Manifest

[BUG-a9d2] - Array overflow during packet processing

* Module/File: src/network/parser.c
* Timestamp: 2026-07-06 11:30
* Description: Boundary check missing on the payload length allocation.
* Status: PENDING_FIX

---

2. AUTHORIZED IDENTITIES & JOB ASSIGNMENTS

---

🤖 CODENAME: EditorA (The Builder)

* Primary Objective: Feature implementation, optimization, and local unit testing loops.
* Assigned Jobs:
1. Check the very top task in `.agents/task.md`. If it is marked `PENDING`, target this feature request first.
2. Scan `.agents/test.md` for any open `[BUG-XXXX]` definitions to address broken regressions.
3. Modify production source files inside `src/` to implement features or fix active bugs.
4. Run local unit tests (e.g., `npm test`, `cargo test`) until they return a clean exit code.
5. Log the Action: Look at the last number in `.agents/change.md`, increment it by 1, and append a new line documenting the change, explicitly referencing the target `BUG-ID` or `TASK-ID` handled.


* Strict Boundaries: Forbidden from modifying `.agents/test.md` or `.agents/task.md`. Forbidden from changing system integration tests.

🔬 CODENAME: TestB (The Auditor)

* Primary Objective: Independent system verification, regression checking, and tracking compliance.
* Assigned Jobs:
1. Read the `LAST_TESTED_CHANGE_ID` from the top header of `.agents/test.md`.
2. Scan `.agents/change.md` for any rows greater than that checkpoint.
3. Execute the full system integration test suite for those new changes.
4. If a test passes: If the change resolved an active bug, completely delete that specific `[BUG-XXXX]` entry from `.agents/test.md`. If the change completed a `PENDING` requirement from `.agents/task.md`, rewrite its status line in that file to `RESOLVED`.
5. If a test fails: Generate a random 6-character alphanumeric ID, append a new `[BUG-XXXX]` entry into `.agents/test.md`, link it to the failing Change ID, and flag the human architect.
6. Advance the Pointer: Update the `LAST_TESTED_CHANGE_ID` header at the top of `.agents/test.md` to match the highest `.agents/change.md` ID evaluated.


* Strict Boundaries: READ-ONLY for all project production source code. Strictly forbidden from rewriting or editing production code lines under any circumstance.

---

3. THE EXECUTION LOOP & SYSTEM STABILITY

---

The workflow functions as a decentralized state machine driven by filesystem changes:

[ Human Phase ]       -> Inserts new PENDING task at the top of .agents/task.md
|
v
[ EditorA Phase ]     -> Reads task/bugs -> Modifies code -> Appends to .agents/change.md
|
v
[ TestB Phase ]       -> Reads pointer -> Scans changes -> Runs integration tests
|
+---> [ IF TEST PASSES ] --> Flips task to RESOLVED / Clears bug & Updates pointer
+---> [ IF TEST FAILS ]  --> Appends new BUG-ID to .agents/test.md & Updates pointer

System Stability Rules:

1. The Checkpoint: TestB will never re-verify an ID lower than or equal to LAST_TESTED_CHANGE_ID.
2. The Goal State: When .agents/test.md contains zero active bugs beneath its control header and the topmost task in .agents/task.md is RESOLVED, the system is 100% compliant and stable.
3. The Audit Trail: .agents/change.md is an unalterable history ledger, providing an absolute chronological record of how the project evolved.
================================================================================
