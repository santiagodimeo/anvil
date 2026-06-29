# ERD — entity-relationship diagram from a live database → .excalidraw
# Usage: /erd [optional: connection string, table filter, or output path]
# Introspects a running database via its existing CLI client and emits a
# hand-drawn ERD as a .excalidraw file. Reads no credentials it isn't given;
# never prints or commits them.

You are reverse-engineering a live database into an ERD: $ARGUMENTS

Use TodoWrite now to create a checklist of the phases below so progress is visible.

## Hard rules
- **No shipped driver.** Introspect only through a client the project already
  has on PATH (`psql`, `mysql`/`mariadb`, `sqlite3`). If none is present, stop
  and say so — do not install anything.
- **Credentials are radioactive.** Read the connection string from the
  environment or a config file the project already uses. Never echo it, never
  write it into the output, never commit it. If you must show a command, mask
  the password.
- **Deterministic render.** The `.excalidraw` output follows the element spec in
  Phase 4 exactly. Do not improvise the JSON shape — wrong fields make the file
  fail to open.
- **Decisions, not dumps.** When a choice comes up (which schema, how to handle
  a view), pick one, name the alternative, move on.

---

## Phase 1 — Locate the database

1. If `$ARGUMENTS` contains a connection string, use it. Otherwise detect, in order:
   - `$DATABASE_URL` / `$PG*` / `$MYSQL_*` env vars
   - `.env`, `.env.local` (grep for `DATABASE_URL=`, `DB_*`)
   - framework config: `config/database.yml`, `prisma/schema.prisma` datasource,
     `alembic.ini`, `ormconfig.*`, `docker-compose.yml` db service
   - a `*.sqlite`/`*.db` file in the repo
2. Identify the engine (postgres / mysql / sqlite) and confirm the matching
   client is on PATH (`command -v psql` etc.).
3. State what you found — engine, host (masked), database name — and confirm
   with AskUserQuestion before connecting. If detection fails, ask for the
   connection string.

---

## Phase 2 — Introspect into a model

Run read-only catalog queries. Pull, per table:
- columns: name, type, nullable, default
- primary key columns
- foreign keys: column → referenced table.column
- unique constraints/indexes (needed for cardinality)

Engine catalogs:
- **postgres**: `information_schema.columns`, `table_constraints` +
  `key_column_usage` + `constraint_column_usage` for PK/FK, `pg_indexes` /
  `information_schema.table_constraints` for unique. Scope to the target schema
  (default `public`); skip `pg_catalog`/`information_schema`.
- **mysql**: `information_schema.COLUMNS`, `KEY_COLUMN_USAGE`,
  `TABLE_CONSTRAINTS`, `STATISTICS` (for unique). Scope to the target database.
- **sqlite**: `PRAGMA table_info(t)`, `PRAGMA foreign_key_list(t)`,
  `PRAGMA index_list(t)` per table from `sqlite_master WHERE type='table'`.

Build an internal model: `tables[] { name, columns[] {name,type,nullable,pk,fk?,unique}, fks[] {from,toTable,toColumn} }`.

Derive cardinality per FK:
- FK column is unique/PK → **1:1**, else **1:N** (child→parent).
- A table whose columns are entirely FKs forming its PK → junction; render the
  two sides as **M:N** and keep the junction table visible.

Print a one-screen summary: N tables, M relationships. If **N > 30**, warn that
the diagram will be dense and proceed (a filter arg can scope it next run).

---

## Phase 3 — Layout (deterministic)

Compute coordinates before emitting any JSON. A prompt has no layout engine, so
follow this exactly:

1. **Card size.** Width `W = 260`. Height `H = 30 (header) + 22 * rowCount + 16`.
2. **Order.** Sort tables by FK-degree (in+out) descending — hubs first.
3. **Grid.** `cols = ceil(sqrt(N))`. Cell = `300 wide × (maxH + 80) tall`.
   Place tables in sorted order, filling row by row, **but** when the next table
   has an FK to an already-placed table, prefer the nearest free cell in that
   neighbour's row/column. Greedy adjacency — good enough, keeps related tables
   close and most arrows short.
4. Record each table's `(x, y)` and final `W×H`.

---

## Phase 4 — Emit the .excalidraw file

Output a single JSON file. Top-level shape:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "anvil/erd",
  "elements": [ /* see below */ ],
  "appState": { "gridSize": null, "viewBackgroundColor": "#ffffff" },
  "files": {}
}
```

Every element needs these common fields: `angle:0`, `strokeColor:"#1e1e1e"`,
`fillStyle:"solid"`, `strokeWidth:1`, `strokeStyle:"solid"`, `roughness:1`,
`opacity:100`, `groupIds:[]`, `frameId:null`, `seed` (any int, vary per element),
`version:1`, `versionNonce:1`, `isDeleted:false`, `updated:1`, `link:null`,
`locked:false`. IDs must be unique, stable strings (e.g. `tbl-users`,
`txt-users`, `fk-orders-users`).

**Per table — two elements (text NOT bound, placed over the rectangle so it
stays left-aligned):**

```json
{ "id":"tbl-users","type":"rectangle","x":X,"y":Y,"width":W,"height":H,
  "backgroundColor":"#ffffff","roundness":{"type":3},
  "boundElements":[{"id":"fk-orders-users","type":"arrow"}] }
```
```json
{ "id":"txt-users","type":"text","x":X+12,"y":Y+10,"width":W-24,"height":H-20,
  "backgroundColor":"transparent","roundness":null,"boundElements":null,
  "fontSize":16,"fontFamily":3,"textAlign":"left","verticalAlign":"top",
  "containerId":null,"lineHeight":1.25,
  "text":"users\n🔑 id: uuid\n🔗 org_id: uuid → orgs\nemail: text\ncreated_at: timestamptz °",
  "originalText":"…same as text…" }
```
Row markers in `text`: `🔑` PK, `🔗` FK (append ` → parentTable`), `U` unique,
trailing `°` nullable. First line is the table name.

**Per FK — an arrow plus a cardinality label.** Arrow goes child → parent.
Compute `points` from the two card edges (start at child card border, end at
parent card border); set `x,y` to the start point and `points:[[0,0],[dx,dy]]`.

```json
{ "id":"fk-orders-users","type":"arrow","x":sx,"y":sy,
  "width":dx,"height":dy,"points":[[0,0],[dx,dy]],
  "startBinding":{"elementId":"tbl-orders","focus":0,"gap":4},
  "endBinding":{"elementId":"tbl-users","focus":0,"gap":4},
  "startArrowhead":null,"endArrowhead":"arrow",
  "roundness":{"type":2},"boundElements":null }
```
Add a free `text` element (not bound) at the arrow midpoint with `text:"1"` /
`"N"` / `"M:N"` per derived cardinality.

**Binding invariant:** every arrow listed in its `startBinding`/`endBinding`
targets must also appear in that rectangle's `boundElements` array. Keep them
consistent or arrows detach on open.

**Legend.** One rectangle + text element in a free corner:
`🔑 PK   🔗 FK   U unique   ° nullable   |   1 · N · M:N cardinality`.

---

## Phase 5 — Write & verify

1. Write to the output path (arg, else `./erd.excalidraw`).
2. Validate it parses: `jq empty erd.excalidraw` (or `python -m json.tool`).
   If it fails, fix and rewrite — never hand back invalid JSON.
3. Report inline:
   - file path, table count, relationship count
   - any tables skipped (views, no PK) and why
   - "Open at excalidraw.com or the Excalidraw VS Code extension. Re-run /erd to
     regenerate after a schema change."
