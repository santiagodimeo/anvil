# mcp

MCP (Model Context Protocol) server configs and custom server implementations.

## What goes here

- **Configs**: JSON config snippets for third-party MCP servers (Slack, GitHub, Supabase, etc.)
- **Custom servers**: MCP servers built for specific workflows or internal tools

## Installed MCP servers (config)

| Server | Purpose |
|--------|---------|
| `slack` | Read channel history, list channels |
| `supabase` | Database introspection and query execution |
| `vercel` | Deployment status and logs |
| `playwright` | Browser automation for UI testing |

## Custom servers (planned)

- `notion-project-context` — injects current sprint context into Claude sessions
- `pr-diff-server` — surfaces relevant PR history for a file being edited
- `runbook-server` — exposes internal runbooks as MCP resources

## Resources

- MCP spec: https://modelcontextprotocol.io
- Claude Code MCP setup: https://docs.anthropic.com/claude-code
