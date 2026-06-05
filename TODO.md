# TODO — zed-extension-shuttle-syntax

## Status (2026-06-03)

Both grammars rewritten/created and wired into this extension. Everything
parses and passes tests; the only unverified step is live highlighting in Zed.

- [x] **Shuttle grammar** rewritten (`../tree-sitter-shuttle-notation`, committed
      `28d8df3`) — repetition `*N`, arg operators/refs, section args/suffixes,
      bare-prefix notes all work. 22/22 corpus tests pass.
- [x] **Billboard grammar** created (`../tree-sitter-jdw-billboarding`, committed
      `4384778`) — line-based, delegates track content to shuttle via injection.
      14/14 corpus tests pass; all 17 real `.bbd` songs parse clean.
- [x] Extension wired: `extension.toml` points at both grammars, `languages/shuttle/`
      highlights refreshed to new node names, new `languages/billboard/`
      (config + highlights + injections), `example.bbd` added.

## Left to do

- [ ] **Verify highlighting live in Zed** (can't be done headless):
      `zed: install dev extension` → pick this folder → open `example.shuttle`
      and `example.bbd`. Confirm note sequences inside billboard track lines get
      shuttle highlighting (injection working).
- [ ] **Before publishing:** push both grammar repos to GitHub, then in
      `extension.toml` switch each `repository` from the local `file://` path back
      to its GitHub URL (kept in the comment above each entry) and bump the rev.
- [ ] Decide whether to commit this extension repo (currently uncommitted).
- [ ] Optional polish: tune highlight scopes to your Zed theme; the synth-header
      tail / sampler pad config is currently one opaque `additional_config` node
      (`@string`) — could be sub-parsed later if richer coloring is wanted.
