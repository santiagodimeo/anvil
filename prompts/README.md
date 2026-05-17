# prompts

Reusable system prompts and prompt engineering templates.

## Categories (planned)

| Folder | Contents |
|--------|---------|
| `system/` | System prompts for long-running AI assistants or bots |
| `code-review/` | Prompts for automated code review with specific lenses |
| `debugging/` | Structured prompts for root cause analysis |
| `writing/` | Tech writing templates: RFCs, postmortems, ADRs |
| `interviewing/` | Technical interview question generation and evaluation |

## Prompt engineering principles used here

- **Protocol over instruction** — prompts define a sequence of steps, not just a goal
- **Injection guards** — every prompt that reads external content has explicit prompt injection detection
- **Confirmation gates** — destructive or irreversible actions require explicit user confirmation
- **Output contracts** — output format is specified precisely so downstream tools can parse it
