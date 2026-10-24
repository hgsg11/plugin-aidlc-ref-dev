# AIDLC Refinement Development

This repository distributes two AIDLC plugins:

- `backlog-refinement` investigates a user story, clarifies open questions,
  creates a browser-viewable screen prototype for review, and produces an
  implementation map in a format suited to the project.
- `ticket-to-pr` derives requirements from a GitHub issue without a separate
  confirmation step, implements them with tests, passes test, security, coding
  standards, and AI Slop reviews, then creates a pull request.

The plugin requires an AIDLC installation in the host repository. Select the
`backlog-refinement-story` scope when starting a refinement workflow.

## Install in Claude Code

```text
/plugin marketplace add hgsg11/plugin-aidlc-ref-dev
/plugin install aidlc-backlog-refinement@aidlc-ref-dev
/plugin install aidlc-ticket-to-pr@aidlc-ref-dev
```

## Install in Codex

```sh
codex plugin marketplace add hgsg11/plugin-aidlc-ref-dev
codex plugin add aidlc-backlog-refinement@aidlc-ref-dev
codex plugin add aidlc-ticket-to-pr@aidlc-ref-dev
```

The Codex repository marketplace is in `.agents/plugins/marketplace.json`.
Generated host packages for Codex, GitHub Copilot, Cursor, Kiro CLI, Kiro IDE,
and opencode are kept under `dist/`. The same marketplace exposes both
plugins.

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

For the ticket workflow, copy and sync its package instead:

```sh
cp -R /path/to/plugin-aidlc-ref-dev/dist/plugins/ticket-to-pr/kiro/. .
AIDLC_PLUGIN_ROOT=/path/to/plugin-aidlc-ref-dev/dist/plugins/ticket-to-pr/kiro \
  AIDLC_PROJECT_DIR="$PWD" AIDLC_HARNESS_DIR=.kiro \
  aidlc engine plugin sync
```

For Kiro IDE 1.x or Kiro CLI v3, substitute `kiro-ide` for `kiro` in the
paths. That projection also registers the Kiro SessionStart compose hook. The
`kiro` projection needs the explicit sync command above after copying.

## Contents

- `src/backlog-refinement/` is the authored, harness-neutral plugin source.
- `src/ticket-to-pr/` is the authored ticket-to-PR plugin source.
- The repository root is the generated Claude Code package and marketplace.
- `dist/<harness>/` contains the generated backlog-refinement packages;
  `dist/plugins/ticket-to-pr/<harness>/` contains ticket-to-PR packages.

When updating the plugin, validate the source with AIDLC's
`aidlc-plugin-validate.ts`, rebuild each supported harness with
`aidlc-plugin-build.ts`, and rerun the composition check against a real AIDLC
installation. Keep generated packages in sync with the source.
