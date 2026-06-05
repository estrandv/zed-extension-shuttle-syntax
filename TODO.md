# TODO — zed-extension-shuttle-syntax

## Status (2026-06-05)

- [x] Both grammars published to PyPI (v0.3.0 shuttle, v0.1.0 billboard)
- [x] CI fixed with `wheel tags` platform retagging
- [x] Docs overhaul across all 15 repos
- [x] Extension.toml switched to GitHub URLs
- [x] VSCode features ported: improved highlights, brackets, .zed/tasks.json
- [x] All code committed and pushed

## Left to do

- [ ] **Verify highlighting live in Zed** (can't be done headless):
      `zed: install dev extension` → pick this folder → open `example.shuttle`
      and `example.bbd`. Confirm note sequences inside billboard track lines get
      shuttle highlighting (injection working).
- [ ] **Publish to Zed marketplace:** create a GitHub release with the extension
      package, then submit to https://zed.dev/extensions
- [ ] **Optional polish:** tune highlight scopes to your Zed theme; the synth-header
      tail / sampler pad config is currently one opaque `additional_config` node
      (`@string`) — could be sub-parsed later if richer coloring is wanted.
