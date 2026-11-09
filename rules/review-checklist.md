# Architecture review checklist: 68 checks, one per rule (38 Professional, 30 Foundations)

Use this to review a plan, a design document, an n8n workflow export, an agent or MCP server configuration, a system prompt, or a diff. Answer each check that applies; skip the ones the artefact cannot answer and say so. Severity: **must fix** (the rule's deciding cue is present and the design does the tempting wrong thing), **should fix** (the right call is missing but the harm is bounded), **consider** (a cheaper or safer variant exists). Every finding names the rule id, quotes the evidence from the artefact, and gives the fix in one sentence. Where the fix would be right under a different constraint, say which constraint (the paired flip).

## D1 Solution design
- D1.1 Is the problem, its constraints and a measurable success criterion written down before the shape was chosen? Is any fully rule-specified step running through a model instead of code?
- D1.2 Are all six stages present: input (incl. PII handling), context assembly, processing, output validation with a failure path, delivery, feedback capture? Any silent failure path (empty or default output on error)?
- D1.3 Does the chosen pattern's precondition hold (known steps -> workflow; categories -> routing; dependent stages -> chaining; criteria -> evaluator-optimizer; unknown steps -> agent)? Is an agent used where a workflow would do?
- D1.4 If several agents: does the coordinator brief each with a bounded, non-overlapping remit and a defined output? Is the split justified by separate tools, permissions or concurrency?
- D1.5 If decomposed: structured hand-offs with acceptance gates, an integration pass, and an evaluation that shows the split improves quality?
- D1.6 Which business pillar does it serve, and how is it measured? Do the cost levers respect the stated latency (caching on the request path, batching off it)? Does the stage-time sum fit the p95?

## D2 Models, prompting, context
- D2.1 Is the model tier chosen on measured need, with a cascade for hard cases? Version pinned? Evals re-run before any tier change?
- D2.2 Does standing policy live in the system prompt with per-request content last? Does the contract restrict scope to provided sources and allow "not in the source" and null fields? Is there code-level validation around the model?
- D2.3 Does each prompting technique match a diagnosed failure class (examples for format, reasoning for multi-step)? Is reasoning kept out of the parsed payload?
- D2.4 Is context curated by relevance, with compaction or context editing for long sessions? Any blind truncation? Any "bigger window" fix for a quality problem?
- D2.5 Static content first and cached, per-request values last? Any per-request value inside the cached prefix? Are rarely used procedures loaded on demand (Skills) rather than in every prompt?

## D3 Integration
- D3.1 Does every tool on the agent appear in the role's task list? Any dangerous tool kept behind logging, a confirmation or a prompt instruction instead of being removed?
- D3.2 At every hop: who does the downstream system think is calling, and what can that identity reach? Shared or admin credentials at a tool boundary? Is the user's identity propagated? Any token forwarded downstream? Secrets in prompts or repo? Attribution in the audit trail?
- D3.3 Is the latency budget written as a sum of stages? Does the design keep every named quality or safety control? Streaming only where a person waits? Parallel only where calls are independent?
- D3.4 End-to-end traces with a correlation id, prompt version, retrieved context and tool calls? Sampled payloads rather than full persistence? Quality scoring, not only uptime?
- D3.5 Chunking by structure, consistent embedding model, atomic re-index after refresh? Retrieval recall and precision measured apart from answer quality?
- D3.6 One retrieval strategy per data shape? Live operational data behind a query tool, not embedded? Hybrid plus re-ranking where recall is critical?
- D3.7 Consumers counted before the mechanism was chosen (MCP for reuse, direct call for one pipeline, agent-to-agent only for a deciding peer)? No chat features in unattended jobs?
- D3.8 Hot core loaded and cached, long tail behind discovery? Was "it fits in the window" the reason for loading everything?

## D4 Evaluation
- D4.1 Metrics defined before the build? Latency on tail percentiles naming the felt latency? Safety measured as harm and over-refusal?
- D4.2 Labelled, versioned, held-out set covering edge, adversarial and regression populations? Each metric paired with a grader that can score it, LLM judge calibrated on human labels?
- D4.3 One variable per change? Offline suite, then A/B with success and guard metrics and a pre-decided sample size, then staged rollout? Losing variants minted as regression cases?
- D4.4 Is the failing stage named from evidence (correlation, trace) before any fix? Grounding versus generation distinguished? Model upgrade or temperature used as a first fix?
- D4.5 Does each optimisation target the dominant term (cache the repeated prefix, batch unattended volume, right-size with evals)? Any batch on a waiting user?
- D4.6 Continuous scoring of sampled traffic between releases? Every closed incident adds a regression case?

## D5 Governance
- D5.1 For every "never" requirement: an output gate or removal, not a prompt line or a log? Controls named as preventive, detective or compensating, and matched to the requirement?
- D5.2 Risk register with a control, an owner and a detection signal per irreversible action, ranked by consequence and detectability? Any review gate with no measured override rate?
- D5.3 Human review placed by consequence and reversibility: approve before irreversible external effects, sample the reversible, validated escalation trigger, undo guarantee where it fits? Reviewers given the trace and time? High-risk areas covered (qualified reviewer with authority, disclosure to the person)?
- D5.4 Minimum fields cross the boundary, pseudonymised before they cross, key kept inside? Logs, traces, indexes and eval sets inside the assessment? Processor agreement before the first disclosure? Regulation-specific constraint stated (GDPR, HIPAA, FedRAMP)?
- D5.5 Outcomes measured by cohort against a stated fairness criterion? Disclosure at the moment of use? Explanations about the person's own outcome with a way to contest?

## D6 Stakeholders and lifecycle
- D6.1 Baseline, cost of a wrong answer, data access and lawful basis established before design or price? Success criteria with metric, threshold and population?
- D6.2 Trade-offs presented with measurements and a recommendation, decision left with its owner and recorded with its reopening condition? Accuracy given as a range on a population?
- D6.3 Every service level with its six elements, committed on the whole pipeline including human review, never above the platform's own tier? Any hidden narrowing of the population?
- D6.4 Handover pack answers how to change safely (decision records, evaluation baseline and how to re-run it) and how to detect breakage (runbooks), kept beside the code?
- D6.5 Baseline re-run after corpus or model changes? Deprecation treated as re-validation? Iteration gated by the regression suite? Discovery reopened when production contradicts it?

## D7 Developer productivity
- D7.1 Rules that must hold are enforced (permissions, hooks, policy), not only written in the instruction file? Configuration committed and reviewed, not on a wiki page?
- D7.2 Tooling measured on cycle time, defect escape and review latency against a baseline? Review in a fresh context with a named human on merge? Working procedures packaged as shared skills or commands?
- D7.3 Incident handling reads the trace before editing, contains by blast radius one change at a time, and closes with a fix, a regression case and a runbook update?

## F1 Agentic architecture
- F1.1 Does the loop branch on `stop_reason`, continuing on `tool_use` and stopping on `end_turn`, with every other value routed to a retry or a person? Are tool results appended to the history every round? Is the iteration cap a logged safety net rather than the way the loop normally ends? Does any code decide completion from the reply text?
- F1.2 Does the coordinator's split cover the whole topic with distinct, non-overlapping slices? Does it call only the subagents a query needs, route every result and error through itself, and re-delegate when synthesis shows a gap? Where output misses whole areas, was the decomposition checked before any subagent was changed?
- F1.3 Is the spawning tool (Task, now Agent) on the coordinator's `allowedTools`? Does each AgentDefinition have a description, a prompt and a role-sized `tools` list? Does each brief carry complete prior findings with their source metadata, a goal and a quality bar instead of a step list? Are independent subagents spawned in one response?
- F1.4 Is every step order whose single failure costs money, security or compliance enforced by a code gate rather than a prompt line? Are multi-issue requests split, investigated in parallel and answered once? Does the handoff to a person stand alone: customer id, summary, root cause, exact amount, recommended action, what was already verified or done?
- F1.5 Is policy enforced in PreToolUse, before the side effect, and result clean-up done in PostToolUse? Is any PostToolUse hook expected to prevent an action? Are mixed formats from different tools left for the model to interpret?
- F1.6 Does the decomposition match what is known (a fixed chain for known steps, an adaptive plan for open scope)? When many items share one pass, is there one pass per item plus a separate integration pass?
- F1.7 Is the session choice explicit: resume while the earlier tool results still hold, fork only to compare directions, a new session seeded with a structured summary and a changed-files list once results are stale? Is a fork ever used to continue one line of work or to escape stale context?

## F2 Tool design and MCP
- F2.1 Does every tool description state what the tool does, its input and format, what it returns, its limits and when to use a similar tool instead? Do any two tools have overlapping names or descriptions? Does the system prompt contain a keyword instruction that pulls requests towards one tool? Was a router, classifier or few-shot block added before the descriptions were fixed?
- F2.2 Does every tool failure return `isError: true` with a category, a retryable flag and a next-step description, rather than one generic message? Is a query that matched nothing returned as a success with zero results, distinct from a failure to reach the source? Do subagents retry transient failures locally and pass up the rest with what they tried and partial results? Is any failure reported as an empty success?
- F2.3 Does each agent hold only the tools its role needs, with nothing from another role's specialism? Was the tool count checked before the fix was chosen (descriptions, split by role, or one parameterised tool)? Are generic tools replaced by constrained ones? Does a frequent, simple cross-role need have a narrowly scoped tool, with complex cases still routed through the coordinator? Is `tool_choice` set deliberately (`auto`, `any`, or a forced first step), and does the chosen model accept that setting?
- F2.4 Are team MCP servers in a committed `.mcp.json` and personal or trial ones out of it? Are all credentials `${VAR}` references, with no literal token anywhere in the repo or its history? Was a maintained community or vendor server considered before a custom build? Are MCP tool descriptions rich enough to beat a built-in alternative? Are catalogues (schemas, issue lists, doc trees) exposed as resources instead of discovered by repeated calls? Has `claude mcp list` or `/mcp` confirmed the servers actually connected?
- F2.5 Is content search done with Grep (or `grep`) and path matching with Glob (or `find`), and not the other way round? Does exploration start from an entry point and widen only as evidence justifies, with no read-everything step? Are wrapper and re-exported names searched as well as the original? Is Edit the default change, with a whole-file rewrite only when no unique anchor exists?

## F3 Claude Code configuration
- F3.1 Are team conventions in the repo's `CLAUDE.md` or `.claude/CLAUDE.md`, with nothing a teammate needs living only in a user-level file? Is a large file split with `@path` imports or `.claude/rules/` topics? Do any two CLAUDE.md files contradict each other? Is any rule that must hold on every run (a blocked path, a required formatter, a forbidden command) written only as CLAUDE.md text instead of a permission rule or hook?
- F3.2 Are team commands and skills committed under `.claude/commands/` or `.claude/skills/<name>/SKILL.md`, and personal ones under `~/.claude/` with distinct names? Is every skill a folder with a SKILL.md and a useful `description`? Do verbose or exploratory skills use `context: fork`? Does any skill rely on `allowed-tools` as a restriction (it only pre-approves; use `disallowed-tools` or deny rules)? Is any always-on standard hidden in a skill, or any task procedure sitting in CLAUDE.md?
- F3.3 Are conventions for one file type spread across many folders in a `.claude/rules/` file with a `paths:` glob, rather than copied into per-folder CLAUDE.md files or the root file? Does each rule file that is meant to be conditional actually carry `paths`?
- F3.4 For multi-file, architectural or multi-approach work, was plan mode used before any edit, and was it switched on (Shift+Tab, `--permission-mode plan`, `/plan`) rather than requested in text? Is a well-understood single-location fix done directly? Is verbose discovery delegated to the Explore subagent? Does a hard-to-undo change (schema, public contract) go through an approved plan?
- F3.5 Does the feedback technique match the diagnosis: concrete input/output examples for inconsistent interpretation, tests-first for complex transformations, the interview pattern for unfamiliar domains? Are interacting fixes sent together and independent ones one at a time?
- F3.6 Does every unattended run use `claude -p`? Is machine-consumed output produced with `--output-format json` plus `--json-schema` and read from `structured_output`? Does the run receive project standards through CLAUDE.md (and not lose them to `--bare`)? Are extra rules added with `--append-system-prompt` rather than replacing the default prompt? Is review done by a separate invocation from generation, with previous findings passed in? Are existing tests supplied to test generation? Are tools restricted with `--tools`, `--disallowedTools` or deny rules, and runs capped with `--max-turns` or `--max-budget-usd`? Do blocking checks avoid the Batch API?

## F4 Prompt engineering and structured output
- F4.1 Does the review or classification prompt name the categories to report, the categories to skip and an exact trigger for borderline types? Is every severity level anchored by a concrete example? Is a category with a high false positive rate switched off while it is reworked, instead of "be conservative" or a confidence filter being added?
- F4.2 Where output still varies under clear instructions, are there a few examples aimed at the failing cases, each with a line of reasoning? Do extraction examples include values in running text as well as tables? Is a wrong tool choice fixed in the tool description before examples are added?
- F4.3 Is the output shape enforced by the API (tool schema, `strict: true` or `output_config.format`) rather than requested in the prompt? Does `tool_choice` fit the need (`any` for an unknown document type, a named tool for a mandatory first step, back to `auto` afterwards)? Are fields the source may lack nullable and out of `required`, do enums carry "unclear" and "other" plus detail, and are format rules in the prompt?
- F4.4 Are semantic rules (sums, date order, field placement) checked in code after the schema? Does a retry carry the source, the failed output and the specific error, and only for errors the source can fix? Do absent values become null or go to a person? Are self-check fields and `detected_pattern` present? Is `stop_reason` read before parsing, with split and merge for output that grows with the input?
- F4.5 Is batch used only where nothing waits on the result? Is the submission interval derived from the promised turnaround minus the 24-hour worst case? Are results matched by `custom_id`, with only failed or expired ids resubmitted (changed) after a sample-set prompt pass? Does any batch item need a tool your own code runs in the middle of the request?
- F4.6 Is review done by a separate instance without the generator's context? Are large reviews split into per-unit passes plus a cross-unit integration pass? Is routing on confidence based on thresholds calibrated against a labelled set?

## F5 Context and reliability
- F5.1 Are transactional facts (amounts, dates, ids, statuses) kept in a case-facts block apart from the summarised history, one entry per issue? Are tool results trimmed before they enter the history? Do aggregated inputs lead with key findings under clear headers? Do upstream agents return structured facts with dates and sources instead of their reasoning?
- F5.2 Are the escalation triggers written down (explicit request for a human honoured at once, policy gap, genuine dead end) with few-shot examples of escalate versus resolve? Is any trigger based on sentiment or the model's self-rated confidence? Do multiple matching records lead to a request for another identifier?
- F5.3 Does every failure return its type, what was attempted, partial results and alternatives? Are access failures kept apart from valid empty results? Is any error swallowed as an empty success, or does one failure abort the whole run? Does the final output say which areas are thin and why?
- F5.4 In long explorations: is a scratchpad file kept from the start, verbose searching delegated to subagents, each phase's summary injected into the next, `/compact` used before the window fills, and a state manifest written for crash recovery? Is a bigger window offered as the fix for degradation?
- F5.5 Is accuracy measured per document type and per field before human review is reduced? Are confidence thresholds calibrated on a labelled validation set? Does stratified random sampling cover the automated high-confidence items? Is the review queue ordered by uncertainty rather than arrival?
- F5.6 Does every claim carry its URL, document name, excerpt and date through synthesis? Are conflicting values from credible sources shown side by side with attribution instead of one being picked or averaged? Are established and contested findings kept apart, and is content rendered by type (tables, prose, lists)?

## Output format

```
## Architecture review: <artefact>
Scope: what was reviewed and which checks could not be answered.

### Must fix
- [D3.2] <finding, with the quoted evidence>. Fix: <one sentence>. Would be right if: <the constraint that would make the current design correct>.

### Should fix
- [D4.2] ...

### Consider
- [D2.5] ...

### Holds
One line listing the rule ids the artefact already satisfies, so the reader knows what was checked.
```
