## Summary

Bumps `supranalytics` from 1.2.0 to 1.3.0 under rule 4. The diff changes only `sha` and `version`.

- Old pin: `269d1aca92f98d4018beceedccd8543fe1148b24` (1.2.0)
- New pin: `84b5d2298d559b0f36327c5117aea8968b6c7003` (1.3.0, the squash commit on `main`)
- Commit range: https://github.com/aniketmohite/supranalytics-plugin/compare/269d1aca92f98d4018beceedccd8543fe1148b24...84b5d2298d559b0f36327c5117aea8968b6c7003

## Why

The 1.2.0 skills load their reporting standards from `../shared/REPORTING.md`. Hermes's `skill_view` refuses that path with "Path traversal ('..') is not allowed", so under Hermes the skills ran without them. In 1.3.0, each skill bundles its own copy as `references/REPORTING.md`, and Hermes serves that file as a linked file.

## What changed in the range

- **Skills:** each skill adds `references/REPORTING.md` and loads it in place of the shared path. Each skill also stops if it can't read the file, and stops with setup steps if the SuprAnalytics MCP server isn't connected.
- **Manifests:** `plugin.json` changes only its version, and `mcp.json` doesn't change.
- **Repo files outside the runtime:**
  - a CI sync check for the bundled copies
  - `server.json` and `REGISTRY.md` for the Official MCP Registry listing
  - README and changelog updates
- **No code:** the range adds no Python, no binaries and no new network destinations.

## Validation (Hermes v0.23.0, installed with `--ref` at the new SHA)

| Check | Result |
|---|---|
| `hermes plugins install` | Pass: enabled, version 1.3.0 |
| `hermes plugins validate` | Pass: portable manifest, manifest fields, config schema, security scan safe; isolation portable |
| `hermes plugins doctor` | Pass |
| `skill_view` on all five skills | Pass: each lists `references/REPORTING.md` as a linked file and returns it identical to the source |
| `skill_view` with the 1.2.0 path `../shared/REPORTING.md` | Refused, as expected |
| Full Hermes conversation: OAuth sign-in with `hermes mcp login supranalytics`, then `supranalytics:weekly-report` | Pass: the skill reads `references/REPORTING.md` before any data call, and the report completes |

The full conversation used an OpenAI model and the plugin installed at the new SHA.

## Disclosure (rule 13)

Unchanged from the current entry:
- Every tool call goes to `https://supranalytics.app/mcp`.
- All access is read-only, with OAuth tokens stored and managed by Hermes.
- The plugin has no shell commands, background processes or self-updating code.

## Links

- Plugin repo: https://github.com/aniketmohite/supranalytics-plugin
- Release PR: https://github.com/aniketmohite/supranalytics-plugin/pull/1
- Original catalog PR: #150176

🤖 Generated with [Claude Code](https://claude.com/claude-code)
