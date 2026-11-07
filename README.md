# SuprAnalytics Plugin

A portable analytics plugin that packages five workflow skills on top of the
SuprAnalytics remote MCP server. Supported clients:

- **Claude Code** — load with `--plugin-dir` or install via the marketplace.
- **Hermes Agent** — install with `hermes plugins install`.

After connecting your SuprAnalytics account through OAuth, ask the agent to run
weekly reports, analyse traffic, inspect funnels, review revenue, and audit
performance — all from a conversation.

> **Status:** v1.2.0. Claude plugin submitted to review; Hermes catalog
> submission pending. Both formats are fully functional for local use.

---

## Supported clients

| Client | Portable format | Minimum version | Install method |
|--------|----------------|-----------------|----------------|
| Claude Code | `.claude-plugin/` manifest | v2.1.281 | `--plugin-dir` or marketplace |
| Hermes Agent | `plugin.json` (Agent Plugins v1.0.0) | v0.23.0 | `hermes plugins install` |

## How this plugin differs from the standalone connector

| | Standalone connector | This plugin |
|---|---|---|
| What it is | An MCP connector listing in Anthropic's directory | A portable plugin bundle |
| What it adds | Direct access to SuprAnalytics tools | Five pre-built skills that guide the agent through analytics workflows |
| Installation | Add from [claude.ai/directory](https://claude.ai/directory/connectors/supranalytics) | Install from this repository or agent directory (pending review) |
| Use case | Power users calling tools directly | Anyone who wants structured, opinionated analytics reports |

Both use the same `https://supranalytics.app/mcp` endpoint and the same OAuth
flow. Installing this plugin does not remove or replace the existing connector.

---

## Prerequisites

**All clients:**
- A SuprAnalytics account with at least one website configured.
  Sign up at [supranalytics.app](https://supranalytics.app).
- Website data must already be tracked — the plugin reads existing analytics
  and cannot create or populate data.
- For funnel analysis: at least one saved funnel must exist in your
  SuprAnalytics dashboard. The skill cannot create funnels.
- For revenue analysis: revenue tracking must be configured (e-commerce events
  or revenue goals). The skill cannot access payment data that has not been
  sent to SuprAnalytics.
- For performance review: audit data must have been collected by SuprAnalytics
  for your website.

**Claude Code:**
- Claude Code v2.1.281 or later.
  Update: `npm install -g @anthropic-ai/claude-code@latest`
- A Claude account (Pro, Max, Team, or Enterprise) with Claude Code or
  claude.ai with Cowork.

**Hermes Agent:**
- Hermes Agent v0.23.0 or later.
  Install via the official installer (not PyPI — PyPI carries an older build that does
  not include the portable plugin loader):
  `curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash`
  (see [hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com) for the full guide)
- A configured model provider (see `hermes setup` or Hermes documentation).
- Node.js is not required for this plugin.

---

## Installation

---

### Claude Code

**Load for one session** (clone or download this repository first):

```bash
claude --plugin-dir ./supranalytics-plugin
```

Replace `./supranalytics-plugin` with the actual path to this folder.

**Install permanently** (adds to your personal skills directory):

```bash
claude plugin init supranalytics --from ./supranalytics-plugin
```

**Validate before loading:**

```bash
claude plugin validate ./supranalytics-plugin --strict
```

Expected output: `✔ Validation passed` with no errors or warnings.

**From this repository's self-hosted marketplace:**

```bash
claude plugin marketplace add aniketmohite/supranalytics-plugin
claude plugin install supranalytics@supranalytics-marketplace
```

**From Anthropic's directory (pending review):** Once approved, installable from
[claude.ai/directory](https://claude.ai/directory) or via `/plugin` in Claude Code.

---

### Standalone skills

To install the skills without the plugin, use the
[skills CLI](https://github.com/vercel-labs/skills):

```bash
npx skills add aniketmohite/supranalytics-plugin --skill '*' --agent claude-code
```

A standalone install includes the skills and their reporting standards, but not
the MCP server. To add the server in Claude Code:

```bash
claude mcp add --transport http --scope user supranalytics https://supranalytics.app/mcp
```

Then start a new session, run `/mcp`, select the SuprAnalytics server, and sign in
through your browser. If the server is not connected, the skills stop and show
these steps.

---

### Hermes Agent

**Install from GitHub (development or pre-catalog):**

```bash
hermes plugins install aniketmohite/supranalytics-plugin --no-enable
hermes plugins enable supranalytics
```

The plugin is disabled after installation until you explicitly enable it.

**Verify it loaded:**

```bash
hermes plugins list
# supranalytics should appear as "enabled"
```

**Validate locally:**

```bash
hermes plugins validate /path/to/supranalytics-plugin --install-deps
```

Expected: no failures. Warnings about portable packages are informational.

**From the Hermes catalog (pending submission):** Once listed, installable by name:

```bash
hermes plugins install supranalytics
```

> The catalog entry has not been submitted yet. Use the GitHub install command above.

---

---

## Authentication

This plugin uses OAuth managed entirely by the agent client. No credentials are
stored in this plugin or repository. All requests go to `https://supranalytics.app/mcp`.

---

### Claude Code

**First-time connection:**

1. Load the plugin: `claude --plugin-dir ./supranalytics-plugin`
2. Run any skill command, for example: `/supranalytics:weekly-report`
3. Claude will pause: *"SuprAnalytics requires authorisation."*
4. A browser window opens. Log in to SuprAnalytics and approve access.
5. Claude reconnects automatically and runs the skill.

**Subsequent sessions:** Tokens are managed by Claude Code and persist between
sessions. You will not be prompted again unless the token expires or you revoke
access.

**To disconnect:** Claude Code settings → Connections → SuprAnalytics → Revoke.

---

### Hermes Agent

Authorization is handled by Hermes's native remote MCP client via standard
OAuth discovery. No credentials are embedded in the plugin.

**First-time connection:**

1. Enable the plugin: `hermes plugins enable supranalytics`
2. Start a session: `hermes`
3. When you first trigger a tool or skill, Hermes detects that authorization is
   needed and opens your browser for the SuprAnalytics OAuth flow.
4. After approving access, Hermes stores the token and continues.

**Subsequent sessions:** Hermes stores and refreshes tokens automatically.

**Unattended runs (cron, gateway):** An active token must already exist. A run
without a valid token fails cleanly rather than hanging — it does not open a
browser or block indefinitely.

**To disconnect:** Remove the stored token through `hermes auth remove supranalytics`
(exact command may vary by Hermes version; see `hermes auth --help`).

---

---

## Skills

All five skills are loaded automatically by both clients. They activate when
you describe what you want, or you can invoke them by name.

| Skill | Claude Code command | Hermes / natural trigger |
|-------|--------------------|-----------------------------|
| Weekly report | `/supranalytics:weekly-report` | `supranalytics:weekly-report` |
| Traffic analysis | `/supranalytics:traffic-analysis` | `supranalytics:traffic-analysis` |
| Funnel analysis | `/supranalytics:funnel-analysis` | `supranalytics:funnel-analysis` |
| Revenue analysis | `/supranalytics:revenue-analysis` | `supranalytics:revenue-analysis` |
| Performance review | `/supranalytics:performance-review` | `supranalytics:performance-review` |

In Claude Code, prefix with `/`. In Hermes, use the bare `plugin:skill` form or
just describe what you want naturally. A standalone Claude Code install has no
plugin prefix, so the command is just the skill name, for example `/weekly-report`.

### Weekly report

Produces a weekly website performance report.
Default period: last 7 days vs. the preceding 7 days.

Example prompts: "Give me a weekly report", "How did my site do last week?"

### Traffic analysis

Explains where visitors come from and which sources and pages matter.
Default period: last 30 days.

Example prompts: "Where does my traffic come from?", "Show me my top sources"

### Funnel analysis

Identifies conversion drop-offs in a saved SuprAnalytics funnel.
Default period: last 30 days.

Example prompts: "Show me my checkout funnel", "Where do people drop off?"

### Revenue analysis

Reports revenue totals, sources, and conversion trends.
Default period: last 30 days vs. the preceding 30 days.

Example prompts: "How much revenue this month?", "Which channels drive revenue?"

### Performance review

Reviews Core Web Vitals, audit findings, and uptime.
Default: latest available audit + last 30 days of field data.

Example prompts: "How fast is my site?", "Show Core Web Vitals and audit findings"

---

## Supported surfaces

### Claude Code

| Surface | Skills | MCP tools |
|---------|--------|-----------|
| Claude Code (terminal) | Yes | Yes |
| Claude Code (VS Code extension) | Yes | Yes |
| claude.ai Cowork | Yes (via account sync) | Yes |
| claude.ai chat | Skills only (no Claude Code CLI) | Depends on connector |

See the [component support table](https://claude.com/docs/plugins/platform-support#compare-component-support-by-app)
for details on which components load on each surface.

### Hermes Agent

| Surface | Skills | MCP tools |
|---------|--------|-----------|
| Hermes terminal | Yes | Yes |
| Hermes Desktop | Yes | Yes |
| Hermes messaging gateway (cron/unattended) | Yes | Yes (requires pre-authorized token) |

---

## Available data and limitations

The plugin reads from the SuprAnalytics MCP server, which provides access to
the 26 tools in the analytics scope:

`list_websites`, `get_websites_summary`, `get_overview`, `get_timeseries`,
`get_breakdown`, `get_breakdown_compared`, `get_pages`, `list_goals`,
`get_goal_details`, `list_funnels`, `get_funnel`, `get_journeys`, `get_live`,
`list_segments`, `get_notes`, `get_insights`, `get_retention`, `get_heatmap`,
`get_recordings_summary`, `get_crawlers`, `get_search_console`,
`get_peak_hours`, `get_performance`, `get_audit_findings`, `get_uptime`,
`get_uptime_incidents`

**Limitations:**
- Access is read-only. No settings can be changed from Claude.
- The plugin can only report on data already tracked in SuprAnalytics. It
  cannot populate, retroactively collect, or invent data.
- Funnel analysis requires saved funnels in your SuprAnalytics dashboard.
- Revenue analysis requires revenue tracking to be configured.
- Performance data requires audit collection by SuprAnalytics.
- The plugin does not access payment processors, CRMs, or external databases.

---

## Read-only access and privacy

This plugin is entirely read-only. It cannot modify your SuprAnalytics account,
create or delete websites, change settings, or trigger new data collection.

All data returned by the MCP server is used only within your Claude session.
Data is not forwarded to third-party services by this plugin.

See the full privacy policy: [supranalytics.app/privacy](https://supranalytics.app/privacy)

---

## Troubleshooting

### Authentication required / no data appears

**Claude Code:** When Claude prompts for authorisation, follow the OAuth flow
in your browser. If the prompt does not appear, type `/supranalytics:weekly-report`
to trigger it manually.

**Hermes:** When you first use a tool or skill, Hermes opens your browser for
the OAuth flow automatically. If this does not happen, check `hermes plugins list`
to confirm the plugin is enabled, then run a skill to trigger the auth flow.

### "No websites found" or empty website list

Your SuprAnalytics account has no accessible websites. Log in to
[supranalytics.app](https://supranalytics.app) to verify your websites and
permissions.

### "No funnels configured"

Funnel analysis requires at least one saved funnel. Create one in your
SuprAnalytics dashboard under Funnels, then re-run the skill.

### "No revenue data available"

Revenue tracking must be configured in SuprAnalytics (e-commerce events or
revenue goals). The plugin cannot access payment data not already sent to
SuprAnalytics.

### Empty reports or all-zero metrics

Possible causes: the selected period predates your tracking start date; the
website was recently added; the MCP server returned empty data for the requested
dimension. The plugin reports what the API returned, including zeros and empty
lists.

### Plugin not loading or missing skills

**Claude Code:** Run `claude plugin validate ./supranalytics-plugin --strict`.
Inside a session, run `/plugin` → **Errors** tab.

**Hermes:** Run `hermes plugins validate /path/to/supranalytics-plugin --install-deps`.
Check `hermes plugins list` to confirm the plugin is enabled, not just installed.

---

## Directory and catalog submission

**Official MCP Registry (hosted server):** The remote endpoint
`https://supranalytics.app/mcp` is listed separately from this plugin as
`io.github.aniketmohite/supranalytics`, described by the root-level `server.json`.
That listing is remote-server discovery metadata only — not the backend source,
not an npm package, not a security endorsement. See [REGISTRY.md](./REGISTRY.md).

**Glama (connector directory):** Glama imported the registry entry automatically
as <https://glama.ai/mcp/connectors/io.github.aniketmohite/supranalytics>.
Ownership claim and authenticated health checks are documented in
[GLAMA.md](./GLAMA.md). No separate submission and no GitHub-source listing of
this plugin repository are needed.

**Anthropic's directory (Claude):** Submission has not been initiated. Run
`claude plugin validate . --strict` and follow the steps at
[Submit a plugin](https://claude.com/docs/plugins/submit). The repository is
already public.

**Hermes catalog:** A draft catalog entry is staged at
`catalog-staging/supranalytics.yaml` in this repository. Before submitting,
the entry must be pinned to the final release commit SHA. Open a PR adding
`plugin-catalog/supranalytics.yaml` to `NousResearch/hermes-agent` with
the final SHA. See [catalog submission guide](https://hermes-agent.nousresearch.com/docs/developer-guide/plugins/catalog-submission).

---

## Known limitations

- **Hermes minimum version: v0.23.0.** The Agent Plugins v1.0.0 `plugin.json`
  portable format and `hermes plugins validate` command are present in v0.23.0
  (verified: validation passes, isolation verdict `portable`, all checks pass).
  The PyPI package (`pip install hermes-agent`) carries an older build that does
  not include the portable loader. Use the official installer from
  [hermes-agent.nousresearch.com](https://hermes-agent.nousresearch.com) to get
  v0.23.0 or later.
- **Hermes OAuth live test:** The OAuth flow through Hermes's native remote MCP
  client was not tested end-to-end against the live `supranalytics.app`
  endpoint in this implementation pass. The portable `streamable-http` transport
  relies on Hermes's standard MCP OAuth discovery. Report issues at
  [support@supranalytics.app](mailto:support@supranalytics.app).
- **Hermes catalog listing:** Not yet submitted. Install via the GitHub URL
  (`hermes plugins install aniketmohite/supranalytics-plugin`) until the
  catalog entry is accepted. Note: `--no-enable` omitted above because earlier
  builds (before v0.23.0) produced a "not a valid Hermes plugin" warning for
  portable packages; this is resolved in v0.23.0.
- **Skill naming in Hermes:** Skills are namespaced as `supranalytics:<skill>`.
  If another installed plugin registers the same qualified name, the later-loaded
  one is skipped with a warning.
- **Read-only access:** All skills are read-only. No data can be changed, deleted,
  or created through this plugin.

---

## Releasing updates

1. Make changes to any file in this repository. If you edit
   `skills/shared/REPORTING.md`, copy it to each skill's `references/` folder and
   run `sh tests/check-reporting-sync.sh`.
2. Increment `"version"` in both `.claude-plugin/plugin.json` and `plugin.json`.
3. Add a changelog entry in `CHANGELOG.md`.
4. Commit and push to the repository.
5. **Claude Code:** Users with the marketplace added run
   `claude plugin update supranalytics@supranalytics-marketplace`.
   For the directory listing, open `claude.ai/directory/manage` and push for review.
6. **Hermes:** Open a SHA-bump PR in `NousResearch/hermes-agent` updating the
   `sha` field in `plugin-catalog/supranalytics.yaml` to the new commit.
   Users then run `hermes plugins update supranalytics`.

---

## Links

- **Documentation:** [supranalytics.app/docs/mcp](https://supranalytics.app/docs/mcp)
- **Support:** [support@supranalytics.app](mailto:support@supranalytics.app)
- **Privacy policy:** [supranalytics.app/privacy](https://supranalytics.app/privacy)
- **Terms of service:** [supranalytics.app/terms](https://supranalytics.app/terms)
- **Publisher:** [suprapps.dev](https://suprapps.dev)
- **MCP Registry publishing guide:** [REGISTRY.md](./REGISTRY.md)
- **Glama listing guide:** [GLAMA.md](./GLAMA.md)
- **Existing connector listing:** [claude.ai/directory/connectors/supranalytics](https://claude.ai/directory/connectors/supranalytics)

---

## License

MIT — see [LICENSE](./LICENSE).
