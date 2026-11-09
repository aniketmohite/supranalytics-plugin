# Publishing SuprAnalytics to the Official MCP Registry

This document covers the listing of the **hosted SuprAnalytics MCP server** in
the [Official MCP Registry](https://registry.modelcontextprotocol.io) using the
root-level [`server.json`](./server.json).

## What the listing is (and is not)

- It publishes **discovery metadata** for the remote endpoint
  `https://supranalytics.app/mcp`: name, title, description, version, website,
  icons and transport. Nothing else is uploaded.
- It does **not** publish the backend application source, which is private.
- It does **not** require publishing an npm package. The entry uses `remotes`
  only; there is no `packages` array and no local executable.
- It is independent of the Claude / Hermes **plugin** in this repository.
  `plugin.json`, `.claude-plugin/plugin.json`, `mcp.json` and `.mcp.json` are
  untouched by registry publishing, and the registry version is **not** tied to
  the plugin version.
- Registration is **not** a security certification or endorsement by the MCP
  project, and it does **not** guarantee inclusion in downstream directories
  (for example client marketplaces or connector catalogs), which apply their own
  review.

## Identity

| Field | Value |
|---|---|
| Registry name | `io.github.aniketmohite/supranalytics` |
| Namespace authentication | GitHub (`io.github.aniketmohite/*`) |
| Remote endpoint | `https://supranalytics.app/mcp` |
| Transport | `streamable-http` |
| End-user authentication | OAuth 2.1 (discovered from the endpoint; nothing stored in `server.json`) |
| Registry version | see `"version"` in `server.json` (starts at `1.0.0`) |

The registry verifies control of the GitHub namespace, not of the remote URL.
A DNS-based namespace (`app.supranalytics/...`) is intentionally **not** used.

`server.json` carries no `repository` field: this repository holds the plugin,
not the source of the remote server, and the field would be misleading.

## Two different logins

| Flow | Who | Command / mechanism | Purpose |
|---|---|---|---|
| Registry publisher login | Maintainer | `mcp-publisher login github` | Proves ownership of `io.github.aniketmohite/*` to the registry |
| SuprAnalytics customer OAuth | End user | Handled by the MCP client (Claude, Hermes, …) | Grants read-only access to the user's own analytics |

Neither token ever belongs in this repository.

## Install the publisher

```bash
brew install mcp-publisher       # macOS (Homebrew)
mcp-publisher --help
```

Other platforms: pre-built binaries at
<https://github.com/modelcontextprotocol/registry/releases>.

## Log in (GitHub device flow)

```bash
mcp-publisher login github
```

Follow the printed `https://github.com/login/device` link and enter the code.
The token is written to `~/.config/mcp-publisher/token.json` (outside the
repository). Use `mcp-publisher logout` to remove it.

## Validate

```bash
mcp-publisher validate server.json
```

This runs JSON, schema and registry semantic validation (via the registry's
validation endpoint). The `description` must be at most 100 characters.
JSON well-formedness alone is not registry validation.

## Publish

```bash
mcp-publisher publish server.json
```

Each `name` + `version` pair can be published only once. Do not run this until
validation passes and the login succeeded.

## Verify the published entry

```bash
curl "https://registry.modelcontextprotocol.io/v0.1/servers?search=io.github.aniketmohite/supranalytics"
curl "https://registry.modelcontextprotocol.io/v0.1/servers/io.github.aniketmohite%2Fsupranalytics/versions"
```

The entry exists only when the registry returns it in these responses.

## Update the listing

1. Edit `server.json`.
2. Increment `"version"` (semver; an already-published version is rejected).
3. `mcp-publisher validate server.json`
4. `mcp-publisher publish server.json`
5. Re-run the verification `curl` above.

To deprecate or retire a version:
`mcp-publisher status io.github.aniketmohite/supranalytics <version> --status deprecated --message "..."`.

## Keep credentials out of git

- The publisher token lives in `~/.config/mcp-publisher/`, not in the repo.
  `.gitignore` also ignores the legacy `.mcp_publisher_token` file name.
- `server.json` must never contain `Authorization` headers, API keys, access
  tokens or reviewer credentials. End-user auth is OAuth discovered at runtime.
- Before committing, review `git diff` for anything credential-like.
