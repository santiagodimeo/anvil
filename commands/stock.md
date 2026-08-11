# Stock — what am I working with
# Usage: /stock [optional: a subdirectory or package to scope to]
# Read-only. Writes nothing, caches nothing. `/map` is the deep, cached one.

You have just landed in a repository and don't know what it is yet. Answer
that, in one screen, in under a minute — the shape of the material before
anyone decides to heat it.

Read-only throughout: Read, Glob, Grep, LS, LSP, and Bash for git and
read-only inspection. This command never writes a file, not even in `.map/`.

<!-- @include references/altitude.md -->

---

## What this is not

`/map` reads the same repo and answers *how does it work* — topology, request
flow, design decisions, data model — and pays for that with a `.map/` cache and
a staleness contract. This answers *what is it*, costs nothing, and leaves
nothing behind.

Run this first. Run `/map` if the answer makes the repo worth it.

---

## Step 1 — Look

Work outward from what the repo declares about itself. Bounded — you are
identifying material, not tracing it:

1. **Manifests** — `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`,
   `pom.xml`, `Gemfile`, whatever is there. Languages, frameworks, and runtime
   come from here, not from guessing at file extensions.
2. **README** and the top-level directories. What the project says it is, and
   whether the layout agrees.
3. **How it runs** — CI workflows, `Dockerfile`, `docker-compose`, `Makefile`,
   package scripts, deploy config. This is what tells you it's a service versus
   a library versus a static site.
4. **Entry points** — the `main`, the server bootstrap, the CLI root, the app
   root. Find them; don't trace them. Tracing is `/map`.

An argument scopes all of this to that subdirectory or package. In a monorepo,
scope to the package and say which one you scoped to.

Don't ask permission to start, and don't narrate progress through these steps.

---

## Step 2 — The report

This is the whole output. Same five sections, every repo, every time.

```
What this is
[One or two sentences. The kind of system, and what it's for. "A React SPA on
Cloudflare Workers serving a personal site and blog from one bundle." If the
README and the code disagree, the code wins — say so.]

Stack
[Languages, frameworks, runtime, and the notable dependencies. Name what pins
each claim — a version from a manifest, not an impression.]

Layout
[The directories that matter, one line each on what lives there and why. Six or
eight, not the whole tree.]

Config
[The files that decide how this builds, runs, and deploys. One line each on
what it controls.]

Shape
[How the thing is organized, and the one convention a newcomer would trip on —
the registry that has to be edited by hand, the generated directory, the
hostname branch, the module boundary that isn't enforced.]
```

Close with one line pointing forward: `/map` when the repo needs understanding,
`/spec` or `/blueprint` when the work is already known.

### Report rules

- **One screen.** If it doesn't fit, you're inventorying instead of orienting.
- **Every entry earns its line with a purpose.** `src/posts.ts — the blog
  registry; new posts are added here by hand` is orientation. `src/posts.ts` on
  its own is a bare tree, and a bare tree is the thing this command exists to
  avoid printing.
- **Layout and Config are sentences, not columns.** Padding names into an
  aligned two-column list turns the section back into the tree it's supposed to
  replace — the alignment starts carrying the meaning instead of the words.
  `path — what it's for.` One per line, and stop.
- **No line numbers.** Directory and file names are the answer here because
  they were asked for. Line-level detail was not, and belongs in `.map/`.
- **Say what you couldn't determine.** "No CI config — nothing here says how
  this deploys" is a real finding. Inventing a plausible answer is not.
- A section with nothing behind it gets one line and stops.
- Plain American English prose and short lines. Not tables of paths.

### When the repo doesn't cooperate

An empty repo, a directory that isn't a repo, or a pile of unrelated scripts
gets two honest lines saying so rather than five sections stretched over
nothing.
