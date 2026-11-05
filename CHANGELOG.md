# Changelog

All notable changes to the SuprAnalytics Claude plugin are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-11-06

### Added

- **Plugin manifest** (`.claude-plugin/plugin.json`) with full metadata for
  Anthropic's directory listing, including documentation, support, privacy, and
  terms URLs.
- **MCP server configuration** (`.mcp.json`) connecting to the SuprAnalytics
  remote HTTP MCP endpoint at `https://supranalytics.app/mcp` using
  client-managed OAuth.
- **Marketplace file** (`.claude-plugin/marketplace.json`) for self-hosted
  distribution from this repository.
- **`weekly-report` skill** — produces a 7-day website performance report with
  key metrics, top sources, top pages, goal conversions, and revenue trends.
- **`traffic-analysis` skill** — explains traffic sources, channels, campaigns,
  landing pages, and optional device or geographic breakdowns over 30 days.
- **`funnel-analysis` skill** — identifies conversion drop-offs across saved
  SuprAnalytics funnels with step-by-step rates and prioritised hypotheses.
- **`revenue-analysis` skill** — reports revenue totals, source attribution,
  customer counts, and time trends over 30 days with prior-period comparison.
- **`performance-review` skill** — reviews Core Web Vitals (field data), audit
  findings, and uptime incidents with a prioritised developer action list.
- `README.md` with installation, usage, and troubleshooting documentation.
- `LICENSE` (MIT, Aniket Mohite).
- `CHANGELOG.md` (this file).
- `.gitignore` for macOS system files, editor artefacts, and MCP bundle cache.

### Status

This is an initial release. The plugin has not yet been submitted to or
approved by Anthropic's directory. Runtime testing against a live authenticated
SuprAnalytics account is pending.
