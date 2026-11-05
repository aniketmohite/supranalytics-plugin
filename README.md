# SuprAnalytics Claude Plugin

A Claude plugin that packages five analytics workflow skills on top of the
SuprAnalytics remote MCP server. After connecting your SuprAnalytics account
through OAuth, you can ask Claude to run weekly reports, analyse traffic,
inspect funnels, review revenue, and audit performance — all from a Claude
conversation.

> **Status:** Initial release. Not yet submitted to or approved by Anthropic's
> directory. The plugin is fully functional for local use.

---

## How this plugin differs from the standalone connector

| | Standalone connector | This plugin |
|---|---|---|
| What it is | An MCP connector listing in Anthropic's directory | A Claude plugin bundle |
| What it adds | Direct access to SuprAnalytics tools | Five pre-built skills that guide Claude through analytics workflows |
| Installation | Add from [claude.ai/directory](https://claude.ai/directory/connectors/supranalytics) | Install from this repository or Anthropic's directory (pending review) |
| Use case | Power users calling tools directly | Anyone who wants structured, opinionated analytics reports |

Both use the same `https://supranalytics.app/mcp` endpoint and the same OAuth
flow. Installing this plugin does not remove or replace the existing connector.

---

## Prerequisites

- A Claude account (Pro, Max, Team, or Enterprise) with Claude Code or
  claude.ai with Cowork.
- Claude Code v2.1.281 or later (for `--strict` validation support and
  directory listing field recognition).
  Update: `npm install -g @anthropic-ai/claude-code@latest`
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

---

## Installation

### From this repository (local development)

Clone or download this repository, then load the plugin for one session:

```bash
claude --plugin-dir ./supranalytics-plugin
```

Replace `./supranalytics-plugin` with the actual path to this folder.

To install it for every session (adds to your personal skills directory):

```bash
claude plugin init supranalytics --from ./supranalytics-plugin
```

### Validate before loading

```bash
claude plugin validate ./supranalytics-plugin --strict
```

Expected output: `✔ Validation passed` with no errors or warnings.

### From this repository's self-hosted marketplace

Add the marketplace and install by name:

```bash
claude plugin marketplace add aniketmohite/supranalytics-plugin
claude plugin install supranalytics@supranalytics-marketplace
```

> **Note:** The repository is currently private. Users must have GitHub access
> to clone it. Make the repository public before publishing to Anthropic's
> directory.

### From Anthropic's directory (pending review)

Once approved, the plugin will be installable from
[claude.ai/directory](https://claude.ai/directory) or directly in Claude Code
via `/plugin`.

---

## OAuth connection

The plugin uses standard OAuth managed by Claude. No credentials are stored
in this plugin or repository.

**To connect for the first time:**

1. Load the plugin: `claude --plugin-dir ./supranalytics-plugin`
2. Run any skill command, for example: `/supranalytics:weekly-report`
3. Claude will pause and display: *"SuprAnalytics requires authorisation."*
4. A browser window opens. Log in to SuprAnalytics and approve access.
5. Claude reconnects automatically and runs the skill.

**Subsequent sessions:** OAuth tokens are managed by Claude Code. You will
not be prompted again unless the token expires or you revoke access.

**To disconnect:** Claude Code settings → Connections → SuprAnalytics →
Revoke.

---

## Skills and commands

All five skills are available as slash commands once the plugin is loaded. They
are also automatically offered by Claude when your request matches their
purpose.

### `/supranalytics:weekly-report`

Produces a weekly website performance report.

Default period: last 7 days vs. the preceding 7 days.

Example prompts:
- "Give me a weekly report for my site"
- "How did supranalytics.app perform last week?"
- `/supranalytics:weekly-report`

### `/supranalytics:traffic-analysis`

Explains where visitors come from and which sources and pages matter.

Default period: last 30 days.

Example prompts:
- "Where does my traffic come from?"
- "Show me my top sources and pages this month"
- "Analyse my organic vs direct traffic"
- `/supranalytics:traffic-analysis`

### `/supranalytics:funnel-analysis`

Identifies conversion drop-offs in a saved funnel.

Default period: last 30 days.

Example prompts:
- "Show me my checkout funnel"
- "Where do people drop off in my sign-up flow?"
- "Analyse funnel conversion rates"
- `/supranalytics:funnel-analysis`

### `/supranalytics:revenue-analysis`

Reports revenue totals, sources, and conversion trends.

Default period: last 30 days vs. the preceding 30 days.

Example prompts:
- "How much revenue did my site generate this month?"
- "Which channels drive the most revenue?"
- "Show me revenue by source"
- `/supranalytics:revenue-analysis`

### `/supranalytics:performance-review`

Reviews Core Web Vitals, audit findings, and uptime.

Default: latest available audit + last 30 days of field data.

Example prompts:
- "How fast is my website?"
- "Show me Core Web Vitals and audit findings"
- "Review my site performance"
- `/supranalytics:performance-review`

---

## Supported Claude surfaces

| Surface | Skills | MCP tools |
|---------|--------|-----------|
| Claude Code (terminal) | Yes | Yes |
| Claude Code (VS Code extension) | Yes | Yes |
| claude.ai Cowork | Yes (via account sync) | Yes |
| claude.ai chat | Skills only (no Claude Code CLI) | Depends on connector |

See the [component support table](https://claude.com/docs/plugins/platform-support#compare-component-support-by-app)
for details on which components load on each surface.

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

### "Authentication required" or no data appears

You are not yet connected. When Claude prompts for authorisation, follow the
OAuth flow in your browser. If the prompt does not appear, type
`/supranalytics:weekly-report` to trigger it manually.

### "No websites found" or empty website list

Your SuprAnalytics account has no accessible websites. Either no websites have
been added, or the connected account does not have permission to view them.
Log in to [supranalytics.app](https://supranalytics.app) to verify your
websites and permissions.

### "No funnels configured"

Funnel analysis requires at least one saved funnel. Create one in your
SuprAnalytics dashboard under Funnels, then re-run the skill.

### "No revenue data available"

Revenue tracking must be configured in SuprAnalytics. This requires e-commerce
events or revenue goals to be set up and receiving data. The plugin cannot
access payment data that has not been sent to SuprAnalytics.

### Empty reports or all-zero metrics

Possible causes: the selected period predates your tracking start date; the
website was recently added and has no data yet; the MCP server returned an
empty result for the requested dimension. The plugin reports what the API
returned, including zeros and empty lists.

### Plugin not loading or missing skills

Run `claude plugin validate ./supranalytics-plugin --strict` to check for
manifest errors. Run `/plugin` inside a session to see the **Errors** tab.

---

## Directory submission

**Submission has not been initiated.** Before submitting to Anthropic's
directory at [claude.ai/directory/manage](https://claude.ai/directory/manage):

1. Create a GitHub repository for this plugin folder.
2. Add the repository URL to `"repository"` in `.claude-plugin/plugin.json`.
3. Run `claude plugin validate . --strict` once more from the repo root.
4. Follow the submission steps in [Submit a plugin](https://claude.com/docs/plugins/submit).

**Private repository and review:** Anthropic's portal can review a plugin
from a private repository if you grant GitHub access during submission.
However, **publication requires a public repository** — the plugin cannot be
listed publicly in the directory while the source repository remains private.

---

## Releasing updates

1. Make changes to any file in this repository.
2. Increment `"version"` in `.claude-plugin/plugin.json`.
3. Add a changelog entry in `CHANGELOG.md`.
4. Commit and push to the repository.
5. Users with the marketplace added run:
   `claude plugin update supranalytics@supranalytics-marketplace`
6. For the directory listing, open `claude.ai/directory/manage` and push the
   new version for review.

---

## Links

- **Documentation:** [supranalytics.app/docs/mcp](https://supranalytics.app/docs/mcp)
- **Support:** [support@supranalytics.app](mailto:support@supranalytics.app)
- **Privacy policy:** [supranalytics.app/privacy](https://supranalytics.app/privacy)
- **Terms of service:** [supranalytics.app/terms](https://supranalytics.app/terms)
- **Publisher:** [suprapps.dev](https://suprapps.dev)
- **Existing connector listing:** [claude.ai/directory/connectors/supranalytics](https://claude.ai/directory/connectors/supranalytics)

---

## License

MIT — see [LICENSE](./LICENSE).
