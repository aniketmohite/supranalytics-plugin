# Shared Reporting Standards

All SuprAnalytics skills load and apply these standards before composing any output.

---

## 1. Separate evidence from interpretation

Label each statement clearly:

- **Observation** — a value directly returned by a tool. Cite the field name when useful.
- **Calculation** — a value derived from returned data. State the formula.
- **Hypothesis** — a possible explanation that has not been verified by the data.
- **Recommendation** — an action or investigation suggested by the evidence.

Do not turn a hypothesis into a factual headline. A disclaimer later in the report does not repair an unsupported opener.
Do not claim a root cause from aggregate analytics alone — correlation in aggregated breakdowns is not causation.

---

## 2. Units

- Verify units from the API documentation, schema, or source definitions before converting or comparing any value.
- Do not guess seconds versus milliseconds (or any other unit) from the magnitude of the value alone.
- If units are undocumented or unknown:
  - Omit the metric from interpreted comparisons, OR
  - Report the raw value and label it "(unit unknown)".
- Do not supply speculative conversions such as "assuming milliseconds, that is X seconds."
- Flag invalid values (e.g. negative durations, negative counts) rather than interpreting them normally.

---

## 3. Missing data versus zero

- An explicit numeric zero in the response is a **recorded zero** for that metric.
- A missing field, null value, error response, or unavailable integration is **not zero** — report it as unavailable or not returned.
- An item absent from a list is not automatically a zero-count item. Lists may be filtered, paginated, or limited to configured or active items only. Check list semantics before treating absence as zero.
- Do not silently populate table cells with zeros for fields the API did not return.
- An API returning zero revenue does not confirm that the business made no sales; state only what the API returned.
- When a prior period returns all zeros across visitors, sessions, pageviews, and revenue, historical coverage is uncertain. Explicit zeros are recorded zeros; whether they reflect zero tracked traffic, a period before tracking was installed, or a period before data collection began cannot be determined from the API response alone unless the platform documents it. Do not infer coverage boundaries from the website creation date alone.

---

## 4. Dates and coverage

- State exact start and end dates plus the website's configured timezone (or UTC if unavailable).
- When the period includes today (a partial day), label it explicitly: e.g. "partial — data through [time] [timezone]".
- Do not compare a full prior period against a partial current period and report growth.
- Prefer complete equivalent periods for comparisons when the API supports them.
- Do not silently change an explicitly requested period.
- State the requested window and observed data coverage separately when they differ.
- A website creation date or first observed event does not establish the tracking installation date.
- Do not claim full coverage for all dates between the first and last observed event.
- Do not use a `created_at`, `added_at`, or similar API field to bound or infer data coverage. The website registration date is not a tracking-start date. Never write "tracking probably didn't cover that window" or equivalent based on that field alone.

---

## 5. Sample sizes and aggregation

- State exact sample sizes alongside any claim about quality, engagement, conversion, or performance. There is no universal threshold below which a sample is automatically unreliable — the required size depends on the claim being made.
- Avoid superlatives — "highly engaged," "best converting," "fastest" — when the sample is small relative to the claim. Report the measured result and explain what the sample size means for reliability.
- Marginal breakdowns by page, country, day, or device are separate aggregations. Do not infer that records in one breakdown intersect with records in another unless a joint query or joint filter verifies the relationship.
- Do not explain overlapping visitor counts (e.g. source totals > site uniques) as "visitors using multiple sources" unless the tool's documented counting semantics explicitly support that explanation. If the reason is unknown, report the discrepancy as unresolved.
- Do not sum or average percentiles to derive aggregate percentiles.
- Do not average rates (e.g. bounce rate, conversion rate) across segments without appropriate weighting.

---

## 6. Referrer and traffic source interpretation

- **"Direct" traffic** means no referrer was detected. This may include direct navigation, bookmarks, dark social, or any referrer stripped before reaching the server. Do not assert the specific mechanism.
- **Localhost / private-IP referrers**: The presence of a `localhost` or private-IP referrer in traffic data does not establish that internal or employee traffic was counted. If potentially relevant, recommend investigating internal-traffic exclusion filter settings as a next step — do not claim filters are absent, disabled, or ineffective.
- **Path-based referrers** (e.g. `/login`, `/dashboard`): These do not establish employee or owner activity.
- **First traffic to a page**: The first date a page appears in traffic data does not establish when the page went live.
- **AI referral visits vs crawler requests**: Keep AI referral visits (e.g. from chatgpt.com, perplexity.ai) entirely separate from crawler request counts. Report exact visitor counts; do not draw engagement conclusions from small AI-referral samples.

---

## 7. Tool efficiency and continuity

- Reuse a confirmed website selection within the same workflow when appropriate. Do not re-ask for a website merely because a new skill is invoked if the selection is unambiguous from prior context.
- Reuse retrieved data when the website, period, filters, and freshness all match.
- Fetch fresh data only when those conditions differ or the user requests a refresh.
- Do not make tool calls solely to fill a report template when no useful data is expected.

---

## 8. Output structure guidance

Report in this order per section:
1. **Result** — the observed metric or finding, with its source field.
2. **Evidence and calculations** — formula, sample size, and any caveats.
3. **Recommendations** — grounded in the evidence.
4. **Limitations** — brief and specific.

Lead with results, not disclaimers. Add limitations only where they materially affect the interpretation. Do not pad sections with unsupported interpretations to meet a template length.
