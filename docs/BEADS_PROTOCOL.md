# 🦨 The Beads Protocol: Immutable Task Management

The Wong Way workforce leverages **Beads** (Distributed Graph Issue Tracker) for all task planning and execution auditing. This system replaces messy markdown plans with a dependency-aware graph powered by [Dolt](https://github.com/dolthub/dolt).

---

## 🚀 Basic Workflow

For every new feature or mission, the workforce must:

1.  **Claim** the next available task:
    ```bash
    bd ready
    bd update <ID> --claim
    ```

2.  **Initialize** work in the local refinery.

3.  **Complete** and certify the task:
    ```bash
    bd close <ID> "Mission certified via Witness Audit."
    ```

---

## 🛠️ Global Workforce Commands

| Command | Persona | Purpose |
| :--- | :--- | :--- |
| `bd ready` | Refiner | List all tasks with NO open blockers (Safe to work). |
| `bd create` | Mayor | Originate a new task Bead in the graph. |
| `bd update --claim` | Refiner | Atomically claim a task as 'In Progress'. |
| `bd dep add` | Architect | Link tasks together (blocks, relates_to, parent). |
| `bd show` | Witness | View full immutable audit trail for a task. |

---

## 🏛️ Genesis Setup

When initializing a new factory, the **Assembler** must bootstrap the vault:

1.  **Install**: `make setup` (automatically installs the `bd` CLI).
2.  **Initialize**: `bd init --quiet`.
3.  **Certify**: `make report` should show an empty or clean task registry.

---
*Certified by the Somerville Civic Pulse Workforce. Mission Code: REQ-003-BEADS* 🏮
