# Architecture review checklist: 38 checks, one per rule

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
