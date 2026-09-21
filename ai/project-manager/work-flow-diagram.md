Human + ChatGPT (planning)
        |
        |
        v
task.md
        |
        |
        v
Opencode reads task.md
        |
        |
        v
plan.md
        |
        |
        v
ChatGPT reviews plan.md
        |
        |
        +---- incorrect
        |          |
        |          v
        |     modify task.md
        |          |
        |          v
        |     Opencode creates new plan.md
        |
        |
        v
APPROVED
        |
        |
        v
Opencode writes code
        |
        |
        v
Update ARCHITECTURE.md if needed
        |
        |
        v
Human tests
        |
        |
        v
Send results to ChatGPT
        |
        |
        v
New task.md
        |
        |
        v
Repeat
