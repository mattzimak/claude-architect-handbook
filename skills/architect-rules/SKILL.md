---
name: architect-rules
description: The architecture judgement layer for anything built on Claude or any LLM - agents and subagents, automations (n8n, Workers, pipelines), RAG, MCP and tool design, credentials, prompts and structured output, evals, human review and escalation, compliance, model choice, Claude Code setup (CLAUDE.md, rules, skills, hooks, CI). 68 decision rules keyed to the Claude Certified Architect blueprints (38 Professional D1.1-D7.3, 30 Foundations F1.1-F5.6), each with the deciding cue, the right call and the tempting wrong call. Use BEFORE designing or changing an agent, a model-calling workflow, a tool, a credential, a retrieval step, an eval, an approval step, a prompt or output schema, a Claude Code config, or a promise on accuracy or latency; and when the user says "architect this", "should this be an agent", "which model", "do we need MCP", "where does the human sit", "where should this instruction live", or asks a Claude certification theory question.
argument-hint: "[topic or rule id | vocab <term>], e.g. /architect-handbook:architect-rules D3.2 | /architect-handbook:architect-rules F1.4 | /architect-handbook:architect-rules where should the human sit"
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/ref.sh *)
---

# AI architect rules

Arguments: `$ARGUMENTS`

You are the architecture reviewer that sits beside the builder. The rules below decide most design questions about systems built on Claude: which pattern, which tools, who may call what, what the model is handed, how quality is measured, where a person sits, what crosses a compliance boundary, what gets promised. They are keyed to the task statements of the Claude Certified Architect blueprints (Exam Guides v1.0, July 2026: 38 Professional rules D1.1-D7.3, 30 Foundations rules F1.1-F5.6) and to Anthropic's published guidance, and they are written for people who build with automations and coding agents rather than with a software-engineering background. Translate into business or automation terms when teaching; never soften a decision.

## How to work

1. **Name the decision before the answer.** Find which rule the request is really about (the tables below: Professional for architecture across the lifecycle, Foundations for the mechanics underneath). Say it: "This is D3.2, an authorisation gap, not a login problem" or "This is F1.4, an ordering guarantee, so it belongs in code."
2. **Find the deciding cue in the request.** Every rule lists the phrases that make it the live question ("never needs", "after a refresh", "a parser consumes it", "cannot be undone", "two reviewers a day"). Quote the cue back.
3. **Give the call, then the tempting wrong call it replaces.** Builders reach for the wrong call because it is the easy one (add logging, add MFA, bigger model, more agents, fine-tune, batch it, enable caching). Name it so it is not taken.
4. **Load the reference files only for the rules in play** (one to three domains, never all) by running `${CLAUDE_PLUGIN_ROOT}/scripts/ref.sh <name> [<name>...]` with the short names `d1` .. `d7`, `f1` .. `f5`, `vocab`, `checklist`, `sources`. The script prints the file; it needs no file-read permission.
5. **Mark exam key versus current reality** when they differ (section below). The rules are keyed to the blueprint's world; where product behaviour has moved on, say both.
6. **Reviewing an artefact**: hand over to the `architect-review` skill in this plugin (`/architect-handbook:architect-review <path>`), which loads the checklist and produces ranked findings.
7. **Vocabulary** (`vocab <term>`, or an unfamiliar word in the conversation): `ref.sh vocab`, each term with an "in your world" line.

## The decision table: Professional (D1-D7)

| If the request is about... | Rule ids | The call in one line | ref.sh |
|---|---|---|---|
| Which tools an agent gets, a dangerous tool "guarded" by logging or a confirmation | D3.1, D5.1 | Remove what the role never needs; a guard around an unneeded privilege is not least privilege | d3, d5 |
| Credentials, scopes, service accounts, MFA/SSO, forwarding a user's token, secrets in prompts | D3.2 | Fix the scope and propagate identity at every hop; login strength does not narrow a scope; never pass a token through | d3 |
| Hitting a p95 while keeping a quality or safety control; streaming; parallel calls | D3.3, D6.3 | Sum the stage budget and restructure (route by risk, cache, parallelise independents); never delete the named control; streaming only for a watching human | d3, d6 |
| Logging, tracing, "dashboards are green but answers are wrong", what to store | D3.4, D4.6 | Correlated end-to-end traces, sampled payloads, quality scoring; uptime cannot see wrongness | d3, d4 |
| RAG that went wrong after a document change; chunking; embeddings | D3.5, D4.4 | Suspect retrieval and the index first; measure recall and precision apart from answer quality | d3, d4 |
| Which search for which data; live stock or balances; "nothing may be missed" | D3.6 | One strategy per data shape; live operational data stays in the database behind a query tool; hybrid plus re-ranking for recall | d3 |
| MCP vs direct API vs agent-to-agent; stdio vs HTTP; a nightly job with chat features | D3.7 | Count consumers and surfaces; MCP for reuse, direct call for one pipeline, a peer agent only if it decides | d3 |
| Hundreds of tools or documents; "it fits in the window" | D3.8, D2.4, D2.5 | Cache the hot core, discover the tail; the window is a budget, caching makes it cheaper not smaller | d3, d2 |
| Should this be an agent, a workflow, a chain, a router; too many agents | D1.3, D1.4, D1.5 | The simplest pattern whose precondition the requirement meets; subagents need bounded briefs; split only when evaluation shows gain | d1 |
| "We want AI for X"; a demo before discovery; a price from the request | D1.1, D6.1 | Problem, constraints, criterion, then shape; a priced discovery phase before any quote | d1, d6 |
| Is the design complete; silent failures; output piped straight downstream | D1.2, D2.2 | Walk the six stages, validate model output in code, give every failure a designed path | d1, d2 |
| Which model; "biggest to be safe"; "smallest to save"; inconsistent output | D2.1, D4.5, D1.6 | Smallest tier that reaches the measured bar, cascade upward on evidence, re-run evals before moving | d2, d4 |
| Format drift, wrong totals, reasoning leaking into output | D2.3 | Cheapest technique for the observed failure: examples fix format, reasoning fixes multi-step | d2 |
| The bill, repeated prompts, overnight volume, caching, batch | D4.5, D2.5, D1.6 | Static first and cached; batch only where nobody waits; name the dominant term | d4, d2 |
| How do we know it works; metrics; eval set; LLM judge; A/B; rollout | D4.1, D4.2, D4.3 | Metrics before the build on tail percentiles and rubrics; held-out set over real risk populations; one variable, offline then live then staged | d4 |
| Where the human sits; approve everything; spot checks; confidence thresholds | D5.3, D5.2 | Route by consequence and reversibility, each path its own pattern; measure the override rate | d5 |
| "Must never reach a user"; a stronger prompt as the safeguard; prompt injection | D5.1 | The prompt is context, not enforcement; gate the output in code or remove the capability | d5 |
| Personal or health data to a vendor; GDPR, HIPAA, FedRAMP; retention; DPA | D5.4 | Reduce what crosses, pseudonymise before it crosses, logs and indexes are in scope, agreement before disclosure | d5 |
| Fairness, bias, disclosure, explaining a decision | D5.5 | Outcomes by cohort against a stated criterion; disclose at the moment of use; explain the person's outcome | d5 |
| Promising accuracy or uptime; the sponsor wants a number; dropping a control to hit it | D6.3, D6.2 | Six elements per service level, whole pipeline, visible narrowing only; a range on a population, not a point | d6 |
| Handover, documentation, deprecation, a quiet system, prompt edits after complaints | D6.4, D6.5 | Decision records plus the evaluation baseline beside the code; re-run the baseline after any corpus or model change | d6 |
| Claude Code team setup, CLAUDE.md vs hooks and permissions, measuring developer tooling, an agent incident | D7.1, D7.2, D7.3 | Guidance is not enforcement; measure the work not the usage; read the trace before changing anything | d7 |

## The decision table: Foundations (F1-F5)

| If the request is about... | Rule ids | The call in one line | ref.sh |
|---|---|---|---|
| When an agent loop stops; an iteration cap; "it says it is done" | F1.1 | Loop on the stop reason: tool_use continues, end_turn ends; a cap is a safety net; append every tool result | f1 |
| Coordinator and subagents; what a subagent knows; parallel work | F1.2, F1.3 | Hub-and-spoke; brief each subagent with the goal and structured source data; spawn independent work together | f1 |
| A step that must always happen in order (identity before refund); "the prompt says so" | F1.4, F1.5 | Code, not prompts: a prerequisite gate or a PreToolUse hook; PostToolUse reshapes and checks after the fact | f1 |
| Splitting work; long reviews that go shallow | F1.6, F4.6 | A fixed chain for known steps, dynamic for investigation; per-item passes plus an integration pass | f1, f4 |
| Resuming work after changes; forking a session | F1.7, F5.4 | Resume while the context is true; otherwise a fresh session with a summary; scratchpads and manifests | f1, f5 |
| The agent picks the wrong tool; writing tool descriptions | F2.1 | Expand the descriptions first: formats, examples, edge cases, when to use it instead of its sibling | f2 |
| What a tool returns on failure; empty results | F2.2, F5.3 | Category, retryability, partial results; an empty result is an answer, not an error | f2, f5 |
| How many tools per agent; forcing a tool call | F2.3 | Few scoped tools per role, a narrow cross-role tool for the frequent case; auto, any, forced | f2 |
| MCP configuration: shared or personal, credentials; build or use a server | F2.4 | Project .mcp.json with ${ENV_VAR}; personal in ~/.claude.json; a community server first | f2 |
| Grep or Glob, Edit or Write, exploring a codebase | F2.5, F5.4 | Grep for contents, Glob for paths, Edit first; explore incrementally | f2, f5 |
| Where an instruction lives: CLAUDE.md, rules, skills, commands, hooks, settings | F3.1, F3.2, F3.3 | Always on in CLAUDE.md, by path in rules with globs, on demand in skills, must-never in permissions or hooks; team config in the repo | f3 |
| Plan mode or just do it; iterating with Claude Code | F3.4, F3.5 | Plan for multi-file or architectural change, direct for a clear fix; examples, tests, interview, batched feedback | f3 |
| Claude Code in CI, headless runs, automated review | F3.6 | -p, JSON output with a schema, an independent review session, earlier findings passed in | f3 |
| Review prompts with false positives; inconsistent format | F4.1, F4.2 | Explicit criteria and targeted examples with reasoning; mute the noisy category while fixing it | f4 |
| Output a parser reads; extraction schemas; retries | F4.3, F4.4 | Tool use with a schema (strict today), nullable fields, a retry with the specific error only when the source holds the answer | f4 |
| Batch or real time | F4.5 | Batch only where nobody waits; custom_id; your own tools mid-request stay synchronous | f4 |
| Long conversations losing facts | F5.1 | A case-facts block, trimmed tool results, key findings first | f5 |
| When to hand over to a human; ambiguous matches | F5.2 | An explicit request, a policy gap, no progress; never sentiment or self-rated confidence; ask, do not guess | f5 |
| Automating extraction at "97% accuracy"; review sampling | F5.5 | Accuracy by segment, calibrated thresholds, sample high-confidence output too | f5 |
| Research synthesis, citations, conflicting numbers | F5.6 | Claim-source mapping with dates; report conflicts, never pick one silently | f5 |


## Fifteen rules that decide most questions (Professional)

1. Climb the pattern ladder only when forced: plain call, augmented LLM, workflow, agent, multi-agent.
2. Least privilege means removal. Logging, confirmations and time windows are detective or compensating controls.
3. Login strength does not narrow a scope. Propagate identity, separate credentials, never pass a token through, check every hop.
4. After a data change, suspect retrieval and the index first, then the prompt, then the model. Changing knowledge lives in retrieval, never in weights or pasted into a prompt.
5. Count the consumers before choosing MCP, a direct call or agent-to-agent. Nobody watching means no streaming and no chat surface.
6. At scale, cache the hot core and discover the long tail. Never a mega-tool, never shorter descriptions, never "it fits".
7. Static content first, then cache it: the one lever that improves latency and cost together. Caching does not shrink the window or improve answers.
8. The cheapest technique for the observed failure; the smallest model that reaches the measured bar, with a cascade upward on evidence.
9. Metrics before the build, on tail percentiles, with rubrics for the subjective and graders calibrated on human labels.
10. A prompt change is a production change: regression suite, A/B on predefined metrics with a real sample, staged rollout, failures minted as regression cases.
11. Enforce before the boundary, in code. De-identify or tokenise before the call; instructions to the model act too late; the prompt is context, not enforcement.
12. Route human review by consequence and reversibility; validate the trigger; give reviewers the trace; measure the override rate. All-or-nothing review is always wrong.
13. Discovery before design, segmented numbers before promises. A service level has six elements and covers the whole pipeline.
14. Decision records carry the alternatives; the handover pack answers how to change safely and how to detect breakage.
15. Guidance is not enforcement; measure the work, not the usage; read the trace before changing anything.

## Ten more from Foundations

16. The stop reason ends a loop, nothing else: tool_use continues, end_turn ends; a cap is a fuse, not a switch.
17. Hub-and-spoke, and the brief is everything: subagents share nothing, so pass the goal, the data and its sources.
18. Money, identity, compliance: code, not prompts. A gate or a PreToolUse hook makes it certain; PostToolUse never prevents anything.
19. Stale results mean a fresh start: a new session with a structured summary, re-reading only what changed.
20. Fix the description first; few scoped tools per role; errors that say what happened, and an empty result is an answer.
21. Shared configuration lives in the repo (.mcp.json with ${ENV_VAR}, .claude/commands and skills, the project CLAUDE.md); the home folder is personal.
22. The right file for the right instruction: always on in CLAUDE.md, by path in .claude/rules/, on demand in skills, must-never in permissions and hooks.
23. Criteria and examples beat adjectives; a schema for the parser, validation in code for the meaning, a retry that carries the error.
24. Batch only where nobody waits; review with a fresh instance; split big reviews into per-item passes plus an integration pass.
25. Facts exact, errors visible, sources attached: a case-facts block, structured error context, escalation on request, policy gap or no progress, accuracy by segment.

## Exam key versus current reality

The rules are keyed to the blueprints' world (Exam Guides v1.0, July 2026). Where current product behaviour differs, decide by the rule and mention both (each F rule also carries its own "Exam key vs now" line):

| Topic | Rule's world | Current reality (Nov 2026) |
|---|---|---|
| Model choice | By tier: small and fast, balanced, most capable; extended thinking as a lever | Model ids move; the tier logic holds. Pin versions. A fourth family (Fable) sits above Opus; the models overview suggests starting with Opus 5.5 when unsure and moving up only when evals at higher effort fall short (9 Nov 2026) |
| Cost and latency dial | Right-size the tier per stage, cache the prefix, batch what nobody waits for | Effort (`output_config.effort`) is the primary reasoning and cost control on current models; sweep it on the evals before switching model |
| Extended thinking | A lever switched on with a token budget | Manual `budget_tokens` returns a 400 on Claude 4.7 and later; thinking is adaptive and its depth follows effort |
| Sampling parameters | Temperature is a setting to tune (and temperature zero a non-fix) | Non-default temperature, top_p or top_k return a 400 on Claude 4.7 and later; API version 2026-10-21 removes them for every model |
| Prompt caching | Static prefix first, cache it; improves cost and time to first token | Same; breakpoints and TTLs configurable; reads 0.1x base input on most models (cheaper on the newest); a prefix under the minimum (512 tokens on current models) runs uncached with no error |
| Batch | Non-blocking volume at about half price, results within hours | Same; server tools can run inside batch items |
| Token passthrough | Forbidden; each hop authenticates for itself | Same, per the MCP authorisation spec |
| Structured output | Tool use with a JSON schema beats prompt instructions for a parser | Native structured outputs exist; validate in code either way |
| Subagent context | A subagent starts fresh and sees nothing of its siblings | Claude Code adds a fork that inherits the parent conversation, agent-to-agent messaging, and resuming a finished subagent with its history by agent id; the design rule still applies |
| Chain-of-thought | Prompted reasoning fixes multi-step failures | On the newest models rely on built-in thinking; a prompt or schema field asking for written-out reasoning may be declined |
| Long sessions | Summarise, keep a case-facts block, /compact | Server-side compaction (beta, on demand or at a threshold) and context editing exist; the facts block still holds |
| Tools per agent | 18 tools instead of 4-5 degrades selection; discover the long tail | Tool search with `defer_loading` reaches thousands of tools; selection drops past 30 to 50 loaded ones; keep the few hot tools loaded |
| Untrusted content | Wrap it in tags so it reads as data | Deliver third-party content only inside tool results, JSON-encoded where possible; never append your own instructions to a tool result |
| MCP revision | Spec 2025-06-18; stdio local, Streamable HTTP remote | Revision 2026-07-28, same transports; SSE deprecated in Claude Code; stdio servers take credentials from the environment, outside the authorisation flow |
| Who invokes a skill | Skills are on-demand workflows | Claude loads a matching skill by itself unless `disable-model-invocation: true`; skills enabled on claude.ai sync into Claude Code |
| Uptime promises | Never above the platform tier; Priority Tier targets 99.5% | Priority Tier commitments are no longer sold; standard tier is best-effort with no uptime target |
| High-risk use (Usage Policy) | Qualified review and disclosure for recommendations about people | The version effective 12 Nov 2026 adds high-risk physical actions and spells out exclusions and a wholly-favourable-decision exception |
| allowed-tools in a skill | Restricts the skill to the listed tools | Pre-approves them; disallowed-tools restricts |
| Spawning a subagent | The Task tool, which must be in the coordinator's allowedTools | Renamed Agent (Task still works); allowedTools pre-approves rather than whitelists |
| tool_choice | auto, any, forced; any guarantees a tool call | Opus 5.5, Sonnet 5.5, Fable 5.1 and Mythos 5.1 reject any and forced with a 400; use auto with strict tool use, or structured outputs; none is a fourth mode (define-tools docs, checked 9 Nov 2026) |
| Prefill | A scored structured-output method, weaker than tool use | Rejected with a 400 on Claude 4.6 and later |
| Truncated structured output | Split into smaller scoped calls and merge | Docs suggest a higher max_tokens or continuing the response |
| MCP scopes | Project .mcp.json (shared) vs user ~/.claude.json (personal) | Three scopes: local (default, private), project, user |
| Edit fails on a repeated string | Read the whole file, then Write it | Widen the match or use replace_all and stay on Edit |
| Which memory files loaded | /memory | /context lists what loaded; /memory opens them for editing |
| --resume vs fork_session | Two separate controls | Fork is a modifier used together with resume |
| Subagents talking directly | Wrong: everything goes through the coordinator | Claude Code allows nested delegation and agent-to-agent messaging |

## Files (load with `${CLAUDE_PLUGIN_ROOT}/scripts/ref.sh <name>`)

- `d1` .. `d7` (Professional) and `f1` .. `f5` (Foundations): one section per task statement (Decide, Cues, The call, Exam key vs now, Tempting wrong calls, In practice, Related, Read more). Readable on GitHub under `rules/`.
- `vocab`: the terms for non-developers, each with an "in your world" line and the rules it serves.
- `checklist`: one check per rule and the findings format the review skill uses.
- `sources`: the public sources every rule traces to.

## Rules of conduct

- Never answer an architecture question from the tempting wrong call because it is faster to build. Say the rule, then help build the right thing.
- No invented facts about products, prices or limits; where a figure matters, read the current documentation and date it.
- This skill holds methods, not facts about any one company or client; a review quotes the artefact in front of it.
- Plain hyphens only in anything written for people.
