# SuprAnalytics — Hermes Catalog Submission

> **Status:** Ready. SHA pinned, validation passed, live MCP test passed.

---

## What SuprAnalytics does

SuprAnalytics is a web analytics platform. This plugin packages five analytics
workflow skills that guide the agent through structured reporting tasks on top
of the SuprAnalytics MCP server:

- **weekly-report** — 7-day performance snapshot vs. prior 7 days (traffic,
  sources, pages, goals, revenue)
- **traffic-analysis** — traffic source, channel, page, and referrer breakdown
  over 30 days
- **funnel-analysis** — step-by-step conversion drop-off analysis for saved
  SuprAnalytics funnels
- **revenue-analysis** — revenue totals, source attribution, customer counts,
  and prior-period comparison
- **performance-review** — Core Web Vitals (LCP, INP, CLS), supporting metrics
  (FCP, TTFB), audit findings, and uptime incidents

Skills include tested safeguards against common interpretation errors
(unsupported causal claims, unknown duration units, missing-vs-zero
conflation, localhost-referrer inference, coverage inference from creation
dates).

## Format and Hermes surfaces

- **Package format:** Agent Plugins v1.0.0 portable package (`plugin.json` +
  `mcp.json` + `skills/`)
- **Hermes surfaces used:** Skills (five SKILL.md files) and remote MCP server
  via Streamable HTTP transport
- **Shared skills reference file:** `skills/shared/REPORTING.md` (loaded by
  all five skills; not registered as a skill itself)
- No Python code, no native binaries, no background processes, no bundled
  executables

## Network and data access

- **Network destination:** `https://supranalytics.app/mcp` only (Streamable
  HTTP MCP endpoint)
- **Access type:** Read-only analytics data for the authenticated user's
  websites
- **Data scope:** Website traffic, sources, funnels, revenue goals, Core Web
  Vitals, audit findings, uptime
- **No telemetry** in the plugin itself; SuprAnalytics may collect usage data
  per its privacy policy: https://supranalytics.app/privacy
- **Terms of service:** https://supranalytics.app/terms

## Authentication

OAuth is managed entirely by Hermes's native remote MCP client via standard
MCP OAuth discovery. The plugin stores no credentials. Users authorize on
first use via a browser OAuth flow; Hermes stores and refreshes the token.
Unattended runs (cron, gateway) fail cleanly if no valid token exists rather
than hanging.

## Validation results

| Check | Result |
|-------|--------|
| `plugin.json` schema (Agent Plugins v1.0.0) | Pass — validated against published schema |
| `mcp.json` schema (Agent Plugins v1.0.0) | Pass — validated against published schema |
| Claude strict validation (`claude plugin validate --strict`) | Pass — exit 0, `✔ Validation passed` |
| `hermes plugins validate` (v0.23.0) | Pass — `portable manifest`, `manifest fields`, `config schema`, `security scan` all pass; isolation verdict `portable`, `host_ready: true`; exit 0 |
| `hermes plugins validate --install-deps` | **Not run** — `--install-deps` triggers `pm.sync_venv`; irrelevant for a pure remote MCP plugin (no Python deps to install) |
| Hermes loader live test (v0.23.0) | Pass — `hermes plugins install aniketmohite/supranalytics-plugin` → installed, enabled, `portable=True`, all 5 skills discovered as `supranalytics:<skill>`, MCP server `supranalytics` registered |
| Hermes MCP live test (v0.23.0) | Pass — `list_websites` returned 2 websites; `get_overview`, `get_breakdown`, `get_pages` returned live analytics data; full weekly report generated end-to-end |
| Skill static review | Pass — all five skills reviewed for client-specific syntax; invocation lines and auth messages made client-agnostic |

## Known limitations

- `requires_hermes: ">=0.23.0"` — the tested supported version. The PyPI
  package does not include the portable loader; users must install via the
  official installer at https://hermes-agent.nousresearch.com/install.sh.
- OAuth browser flow was not tested (live test used Bearer token auth).
  The `streamable-http` transport supports Hermes's standard MCP OAuth
  discovery; users without an API key will authenticate via the browser flow.

## Tested version and commit

- **Version:** 1.2.0
- **Hermes validation:** `hermes plugins validate` v0.23.0 CLI — Pass
- **Hermes live test:** install, enable, skill discovery, MCP connection, analytics data — all Pass
- **Commit SHA:** `269d1aca92f98d4018beceedccd8543fe1148b24`

## Disclosure (rule 13)

- Makes HTTPS requests to `https://supranalytics.app/mcp` on every tool call
- Reads website analytics data for accounts the authenticated user can access
- No shell commands, no background processes, no self-updating code
- No data forwarded to third-party services
- Authentication token stored and managed by Hermes (not by the plugin)
- SuprAnalytics collects usage analytics per its own privacy policy
  (https://supranalytics.app/privacy); the plugin itself collects nothing
