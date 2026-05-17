# clawdbot

Automation scripts and bots built on the Claude API.

## Planned

- Slack bot that responds to `@claude` mentions in threads
- PR reviewer bot triggered by GitHub webhooks
- Daily digest agent: summarizes open PRs, failing CI, and stale branches
- Meeting notes agent: transcribes and extracts action items

## Structure (to be filled)

```
clawdbot/
├── slack/          # Slack bot implementation
├── github/         # GitHub webhook handlers
├── digest/         # Scheduled digest scripts
└── shared/         # Shared Claude API client, retry logic, etc.
```

## Stack

- Runtime: Python 3.12+ or Node 20+
- SDK: `anthropic` (Python) or `@anthropic-ai/sdk` (Node)
- Hosting: TBD
