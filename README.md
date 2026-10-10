# AIDLC Refinement Development

This repository distributes the `backlog-refinement` AIDLC plugin. It takes a
user story, examines the existing implementation, clarifies open questions,
creates a browser-viewable screen prototype for review, and produces an
implementation map in a format suited to the project.

The plugin requires an AIDLC installation in the host repository. Select the
`backlog-refinement-story` scope when starting a refinement workflow.

## Install in Claude Code

```text
/plugin marketplace add hgsg11/plugin-aidlc-ref-dev
/plugin install aidlc-backlog-refinement@aidlc-ref-dev
```

## Install in Codex

```sh
codex plugin marketplace add hgsg11/plugin-aidlc-ref-dev
codex plugin add aidlc-backlog-refinement@aidlc-ref-dev
```

The Codex repository marketplace is in `.agents/plugins/marketplace.json`.
Generated host packages for Codex, GitHub Copilot, Cursor, Kiro CLI, Kiro IDE,
and opencode are kept under `dist/`.

## Use in Kiro

Kiro has no plugin marketplace, so install its generated package into the AIDLC
project and run the composer. Clone this repository, then run from the AIDLC
project directory:

```sh
# Kiro CLI
cp -R /path/to/plugin-aidlc-ref-dev/dist/kiro/. .
AIDLC_PLUGIN_ROOT=/path/to/plugin-aidlc-ref-dev/dist/kiro \
  AIDLC_PROJECT_DIR="$PWD" AIDLC_HARNESS_DIR=.kiro \
  aidlc engine plugin sync
```

For Kiro IDE 1.x or Kiro CLI v3, use `dist/kiro-ide` in both paths instead.
That projection also registers the Kiro SessionStart compose hook. The `kiro`
projection needs the explicit sync command above after copying.

## Contents

- `src/backlog-refinement/` is the authored, harness-neutral plugin source.
- The repository root is the generated Claude Code package and marketplace.
- `dist/<harness>/` contains generated packages for the other harnesses.

When updating the plugin, validate the source with AIDLC's
`aidlc-plugin-validate.ts`, rebuild each supported harness with
`aidlc-plugin-build.ts`, and rerun the composition check against a real AIDLC
installation. Keep generated packages in sync with the source.
