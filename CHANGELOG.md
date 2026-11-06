# Changelog

All notable changes to the SuprAnalytics Claude plugin are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] — 2026-11-06

### Added

- **`skills/shared/REPORTING.md`** — shared reporting standards loaded by every skill, covering evidence vs interpretation labelling, units verification, missing vs zero distinction, date and coverage rules, sample-size caveats, and output structure guidance.

### Changed

All five skills now explicitly load `skills/shared/REPORTING.md` and have been updated with targeted interpretation fixes:

- **`traffic-analysis`**: Added rules for localhost/login referrers (not proof of internal traffic), first-traffic-date vs page launch date, exact-count requirement for small AI referral samples, Direct channel definition, source-total deduplication discrepancy handling, duration unit verification, partial-day labelling, and sort/truncation disclosure for tables.
- **`funnel-analysis`**: Added comparison-period attempt via separate prior-period call, `avgTime` unit safety rule, goal-list vs event-list semantics note, event-name precision rules (`sign_in_email_sent` ≠ completed auth; `sign_in_google_clicked` ≠ completed auth), zero-completions labelling rule, near-zero funnel pattern framed as hypothesis only, read-only enforcement note.
- **`revenue-analysis`**: Added recorded-revenue vs actual-revenue distinction, activation-event ≠ purchase rule, absent-attributed-payment cause enumeration, explicit-zero vs unavailable prior-period distinction, template-row-population prohibition, revenue-per-customer valid-denominator guard, source/campaign breakdown omission rule.
- **`performance-review`**: Separated Core Web Vitals (LCP, INP, CLS) from supporting metrics (FCP, TTFB) in both workflow and output tables; added aggregation-type identification requirement; added provisional-rating rule for small samples; clarified LCP ≠ full page load; added separate-breakdown non-intersection rule; added TTFB-as-hypothesis rule; added SuprAnalytics-is-not-CrUX note; added external-threshold citation requirement; added no-future-audit-schedule and no-trigger-scan rules.
- **`weekly-report`**: Added partial-today labelling in period header, zero-baseline no-percentage-change rule, and goal conversion rate unique-converters-vs-occurrences distinction.

### Status

Changes are local. This version has not been submitted to or approved by Anthropic's directory.

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
