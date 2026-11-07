# SuprAnalytics on Glama

Glama (<https://glama.ai>) re-publishes every entry of the Official MCP Registry
as a **connector** (a remote MCP endpoint). Our registry entry
`io.github.aniketmohite/supranalytics` was imported automatically; nothing was
submitted to Glama and nothing needs to be. This file records the listing, how
it is maintained, and what is still pending. Facts below were checked on
2026-11-07 against Glama's FAQ (<https://glama.ai/mcp/faq>), its methodology page
(<https://glama.ai/mcp/methodology>) and the listing itself.

## The listing

| Field | Value |
|---|---|
| Listing URL | <https://glama.ai/mcp/connectors/io.github.aniketmohite/supranalytics> |
| Kind | Connector (remote endpoint), imported from the Official MCP Registry |
| Namespace / slug | `io.github.aniketmohite` / `supranalytics` |
| Endpoint shown | `https://supranalytics.app/mcp`, Streamable HTTP |
| Auth shown | OAuth ("Works in Glama"), detected from the server's 401 + OAuth metadata |
| Ownership | **Not claimed** (as of 2026-11-07) |
| Health | **Unhealthy**: "the last two health checks failed"; last tested 2026-11-06 21:11 |
| Tools shown | None (tool discovery needs an authenticated test profile) |
| Quality findings | None yet (scoring runs only after tools are discovered) |

Glama has **no** GitHub-source "server" listing for `aniketmohite/supranalytics-plugin`,
and none should be created: this repository is the Claude/Hermes plugin, not the
server's source. Do not add a second connector either.

Why it is unhealthy: Glama's health check initialises an MCP session and calls
`tools/list`. Our endpoint answers `401` with a `WWW-Authenticate` challenge to
unauthenticated requests, by design. That 401 is correct behaviour, not an
outage. The listing becomes healthy once a test profile lets Glama authenticate.

## How the listing is fed

- **Name, description and URL** come from the registry entry
  (`server.json` → `mcp-publisher publish`, see [REGISTRY.md](./REGISTRY.md)).
  By default registry updates keep overwriting them on Glama. After claiming,
  "Manage connector → Use Glama listing details as the source of truth" can
  switch that off; leave it off unless the Glama copy must differ.
- **Categories and thumbnail** are managed only on Glama, after claiming.
- **Auth badge** follows the test profile's declared method; until one exists,
  Glama shows what it detected (OAuth 2.0).

## Ownership verification (pending, needs the maintainer's Glama sign-in)

Glama offers three proofs. Domain and GitHub proofs cover every connector under
that subject; an endpoint proof covers one URL.

1. **GitHub identity (recommended for us, no deployment).** The namespace is
   `io.github.aniketmohite`, so linking the GitHub user `aniketmohite` to the
   Glama account and choosing **Claim with GitHub** proves ownership. Glama
   treats the registry publisher as the strongest proof.
2. **Domain, HTTPS file.** Publish the JSON Glama shows at
   `https://supranalytics.app/.well-known/glama.json` (public, HTTPS, no
   redirect to another domain), then **Check**. Structure:

   ```json
   {
     "$schema": "https://glama.ai/mcp/schemas/connector.json",
     "claim": "glama_claim_<32 characters shown by Glama>"
   }
   ```

   The `claim` token is opaque, account-bound and only displayed in the claim
   panel after signing in. It is public data (not a credential), re-checked
   daily; if it disappears a seven-day grace period starts.
3. **Domain, DNS.** A TXT record at `_glama-claim.supranalytics.app` with the
   value Glama shows, then **Check**.

If option 2 is ever chosen, the SuprAnalytics application (Next.js) serves
static files from `public/`, and its request proxy and header rules already
exclude `/.well-known/`. The whole change is one new file:

```
public/.well-known/glama.json      # exactly the JSON above, with the real token
```

No route handler is needed (a `route.js` would also have to be registered in
`test/hono-removal.test.js`). Verify after deploy with
`curl -i https://supranalytics.app/.well-known/glama.json` (expect 200,
`application/json`, no redirect). Existing OAuth discovery routes under
`src/app/.well-known/` are untouched.

## Health checks and the test profile

- Health checks: `initialize` + `tools/list` (+ prompts/resources), never
  `tools/call`. Only healthy connectors are indexed for search.
- Credentials go in **Admin → Test Profile** on the listing, after claiming.
  Glama states it stores OAuth tokens and API keys encrypted (AES-256-GCM),
  decrypts them only to call the upstream, and refreshes OAuth tokens itself.
- Our method: **OAuth 2.0**. "OAuth dynamic client registration creates a
  client but does not authorize a user", so the test profile must be
  authorised interactively, signed in as the test account.

Test account rules (ours and Glama's):

- A **dedicated** SuprAnalytics account used only for this. Not the operator's
  main account; never a customer's.
- Invited as **Viewer** (Settings → Team) to **one** test website with real
  looking data (for example a website populated by `scripts/simulate.js`).
  Viewer = every report, read-only, no Inbox. It must not be invited to
  production customer websites.
- On the consent screen, leave **"Also share visitors' personal data"**
  unticked, so only `analytics:read` is granted and the 12 `people:read` tools
  are not listed.
- Expected after a successful check: 26 tools (the `analytics:read` set listed
  in [README.md](./README.md#available-data-and-limitations)).
- Alternative if OAuth authorisation in the profile fails: an account API key
  (`pa_…`) created in that same test account **without** "Include visitors'
  personal data", entered as **API Key** / `Authorization: Bearer pa_…`. This
  changes the auth badge to API Key, so prefer OAuth.
- Never paste the token or key anywhere else: not in this repo, the listing
  description, screenshots, support chat or `server.json`.

## Listing content to use after claiming

Short description (already synced from the registry, 85 characters):

> Read-only website traffic, conversions, revenue, funnels and performance analytics.

Longer description (if Glama's editor is used):

> SuprAnalytics is a web analytics platform with revenue attribution. This
> connector gives an assistant read-only access to the websites your account
> can open: traffic and sources (channels, referrers, campaigns, pages,
> countries, devices), goals, saved funnels and visitor journeys, revenue and
> customers where a payment provider is connected, real-user Core Web Vitals,
> site-audit findings and uptime. You need a SuprAnalytics account with at
> least one tracked website; the assistant signs you in through OAuth and sees
> only what you can see, with your role. Tools that return visitors' personal
> data appear only when you allow that during sign-in. Results depend on the
> data your website has sent and on your permissions. Nothing can be changed
> through this connector.

- Categories: Monitoring, Marketing (what comparable analytics connectors use).
- Thumbnail: <https://supranalytics.app/supranalytics-icon.png> (1024×1024 PNG,
  checked 200) or <https://supranalytics.app/supranalytics-icon.svg>.
- Links: website <https://supranalytics.app>, docs
  <https://supranalytics.app/docs/mcp>, tool reference
  <https://supranalytics.app/docs/mcp-tools>, privacy
  <https://supranalytics.app/privacy>, terms <https://supranalytics.app/terms>,
  support <support@supranalytics.app>.
- Do not state a tool count in the description (it is scope-dependent) and do
  not claim "verified", "healthy" or a grade until the listing shows it.

## Testing

Public checks that need no account (re-run any time):

```bash
# Expect 401 + WWW-Authenticate pointing at the resource metadata
curl -i -X POST https://supranalytics.app/mcp -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"probe","version":"0"}}}'
curl -s https://supranalytics.app/.well-known/oauth-protected-resource/mcp
curl -s https://supranalytics.app/.well-known/oauth-authorization-server
```

Through Glama (needs sign-in): the listing's **Try in Browser** opens
<https://glama.ai/mcp/inspector> with the connector preloaded; complete OAuth
there, then run `list_websites` and `get_overview` for a website it returned.
That proves Glama's gateway path; a direct curl with a token proves only the
backend.

## Maintenance

- Change the public name/description: edit `server.json`, bump its version,
  publish to the registry; Glama follows within its sync cycle.
- Rotate the test account's access: Settings → Team on the test website, and
  re-authorise in Admin → Test Profile.
- If ownership was proven by file or DNS, keep the token in place (daily
  re-check, 7-day grace).
- Tool-quality (TDQS) findings appear under Admin → TDQS after discovery; fix
  wording in the application's tool definitions only where a finding is
  specific, keeping names and schemas.

## Outstanding

- Ownership claim: not done (needs Glama sign-in).
- Test profile: not configured (needs the dedicated viewer account).
- Health: unhealthy until the profile exists; no tools or scores shown yet.
- Glama gateway test: not run.
