# zed-extension-shuttle-syntax

Syntax highlighting for [Shuttle Notation](https://github.com/estrandv/tree-sitter-shuttle-notation)
(`.shuttle`) and [JDW Billboarding](https://github.com/estrandv/tree-sitter-jdw-billboarding)
(`.bbd`) in the [Zed editor](https://zed.dev).

## Grammar architecture

Two tree-sitter grammars are layered via language injection:

```
jdw_billboarding (outer/container)       .bbd file
  └─ track lines ──inject──> shuttle      .shuttle content
```

- **`jdw_billboarding`** — parses line structure: synth headers (`@`), effects
  (`€`), commands (`/`), group filters (`>>>`), defaults, comments, and track
  metadata (`<group;args>`). Track note content is captured as an opaque
  `shuttle_content` token.
- **`shuttle`** — injected into `shuttle_content` nodes (via
  `languages/billboard/injections.scm`) to provide recursive highlighting of
  musical sequences.

## Dev vs published extension

When installed as a **dev extension** (`zed: install dev extension`), Zed loads the
`.wasm` file from `grammars/<name>.wasm` directly — you must rebuild it whenever the
grammar changes (see below).

When **published** to the [Zed marketplace](https://zed.dev/extensions) or installed
via a GitHub release, Zed fetches the grammar source from the `repository` URL at the
pinned `rev` and builds the WASM server-side. No local emscripten needed.

> For local development, use a `file://` URL in `extension.toml` and a dev extension.
> Before publishing, switch to the GitHub URL and push the grammar repo first.

## Updating a grammar

When you make changes to `tree-sitter-shuttle-notation` or
`tree-sitter-jdw-billboarding`, the extension must be updated in lockstep:

### 1. Sync the grammar source

The grammar directory must be a **git clone** of the repository (Zed checks
that the remote origin matches `extension.toml` exactly). Always use `git clone`
with the `file://` URL (the same form used in `extension.toml`), then check out
the target rev:

```
rm -rf grammars/shuttle
git clone file:///<abs-path-to-grammar-repo> grammars/shuttle
git -C grammars/shuttle checkout <rev>
```

(same for `jdw_billboarding`)

### 2. Update `extension.toml`

If the grammar repo has new commits, update `rev` to the target commit hash:

```toml
[grammars.shuttle]
repository = "file:///home/estrandv/programming/tree-sitter-shuttle-notation"
rev = "<new-commit-hash>"
```

Before publishing, switch from `file://` to the GitHub URL and push the
grammar repo first so Zed can fetch it.

### 3. Rebuild the `.wasm`

```
tree-sitter build --wasm -o grammars/shuttle.wasm grammars/shuttle
```

Requires [emscripten](https://emscripten.org/) on `PATH`. The wasm file is what
Zed actually loads at runtime — without a rebuild, the old wasm will be used and
highlights will likely break.

### 4. Update highlights

Two highlight locations exist — keep them consistent:

| Location | Purpose |
|---|---|
| `grammars/<name>/queries/highlights.scm` | Used when testing the grammar standalone (`tree-sitter highlight`) |
| `languages/<name>/highlights.scm` | Actually loaded by Zed at runtime |

If a grammar change adds/renames/removes node types, **both** files must be
updated. The `languages/<name>/highlights.scm` is what Zed uses — the
grammar's own `queries/highlights.scm` is only for standalone testing.

### 5. Test

Run `tree-sitter test` in the grammar directory to confirm corpus tests pass.
Then install the extension in Zed via `zed: install dev extension` and open
`example.shuttle` and `example.bbd` to verify live highlighting.

## Common failure modes

- **"Invalid node type X"** — the highlights query references a node type that
  doesn't exist in the loaded wasm. Usually means the wasm is stale (step 3
  forgotten) or `languages/<name>/highlights.scm` wasn't updated after a
  grammar change (step 4).
- **No injection highlighting in `.bbd`** — check
  `languages/billboard/injections.scm`. The `shuttle_content` capture name must
  match the grammar's node name exactly.
- **Extension loads but nothing highlights** — verify `config.toml` has the
  correct `grammar` key matching the `name` field in the grammar's `grammar.js`.

## VSCode → Zed port

This extension was ported from a [VS Code extension](https://github.com/estrandv/jdw-billboarding-vscode).
Key differences:

| Feature | VSCode | Zed |
|---------|--------|-----|
| Syntax highlighting | TextMate grammar (regex) | Tree-sitter queries (AST-aware) |
| Language config | `language-configuration.json` | `config.toml` |
| JDW Commands | Command palette (`extension.js`) | `.zed/tasks.json` (project-level) |

The tree-sitter approach is more precise — highlighting respects the actual syntax
structure rather than regex patterns. The `.zed/tasks.json` provides equivalent
JDW commands (Play, Setup, Stop, NRT) that can be run from Zed's task runner.

## JDW Commands (ported from VSCode)

This extension bundles a `.zed/tasks.json` template with the equivalent of the
VSCode JDW commands:

| Task | VSCode command | Action |
|------|---------------|--------|
| JDW: Play file | `JDW: Play` | Sends queue update via pycompose |
| JDW: Setup file | `JDW: Setup` | Loads synthdefs, samples, config |
| JDW: Stop sequencer | (toolbar) | Stops all sequences |
| JDW: NRT render | (script) | Offline render to WAV |

To use them, copy `.zed/tasks.json` to your project's `.zed/` directory (or
create a symlink). The tasks reference `~/mypython/bin/python` and
`~/programming/jdw-pycompose/run.py` — adjust paths if your layout differs.

## Before publishing

1. Push both grammar repos to GitHub.
2. In `extension.toml`, replace each `file://` repository with the corresponding
   GitHub URL and update `rev` to match the pushed commit.
3. Commit this repo and create a GitHub release / Zed extension submission.
