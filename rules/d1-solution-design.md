# D1 Solution Design and Architecture (17% of the blueprint, 6 decisions)

Design items punish over-engineering as hard as under-engineering: climb the pattern ladder only when the requirement forces it, and name the business pillar and its measurement. Rule ids follow the official CCAR-P task statements.

## D1.1 Translate the business problem: problem, constraints, success criterion, then shape

**Decide:** what to build first when someone says "we want AI for X".
**Cues:** "a general assistant for the whole team", "the measured cost driver is...", "let us pick the architecture", "the payout calculation", "fixed-schema validation".
**The call:** start from the problem, capture the constraints (latency, audit, compliance, budget) and a measurable success criterion, and only then choose the shape. A targeted workflow aimed at the named cost driver beats an impressive general assistant that has no baseline and no criterion. A fully rule-specified sub-task is deterministic code, not a model call: cheaper, faster, exactly right. Knowing where not to use a model is worth as much as knowing where to use one.
**Tempting wrong calls:**
- A general-purpose assistant when the brief names one high-volume workflow.
- Choosing the architecture before the constraints are written down.
- Routing a formula or a schema check through a model.
**In practice:** a Code node for VAT, a prompt for the email.
**Read more:** Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/1-solution-design/1-1-translating-business-problems

## D1.2 End-to-end architecture: six stages, find the one that is missing

**Decide:** whether a design is complete and where a quality problem actually lives.
**Cues:** "quality is inconsistent and nobody can say why", "we pipe the answer straight into the CRM", "on error we return an empty result", "a bigger model would fix it".
**The call:** every production system has six stages: input (ingest, validate, settle PII handling here), context assembly (retrieval, memory, prompt construction), processing (the model call or calls), output (parse, schema check, guardrail, a designed failure path), delivery (sync reply, async job, event, or draft for human review), feedback (capture corrections and graded samples and route them into the next change). Walk the stages and name the missing one. Model output is untrusted until validated, and a schema-valid answer can still break a business rule. Unmeasurable quality means a missing feedback loop, not a weak model.
**Tempting wrong calls:**
- Piping model output into downstream systems without schema and business-rule checks.
- Shipping with no way to capture quality signals.
- Catching errors and returning empty or default output with no signal (silent failure).
- Upgrading the model to fix a quality problem nobody can measure.
- Switching on automatic retries for a step that changes something outside the workflow. A retry runs the side effect again: a second charge, a second email, a duplicate record. Retry only calls that are safe to repeat, or pass an idempotency key the receiving system honours.
**In practice:** trigger, lookups, the AI node, validation, the send node, and the error or review workflow; a node that errors and continues with an empty item sends the customer a blank email.
**Read more:** Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); Structured outputs (https://docs.claude.com/en/docs/build-with-claude/structured-outputs); study lesson https://claudecertificationguide.com/ccar-p/learn/1-solution-design/1-2-end-to-end-architectures

## D1.3 Architectural pattern: the simplest pattern whose precondition the requirement meets

**Decide:** plain call, augmented call, workflow (chaining, routing, parallelisation, orchestrator-workers, evaluator-optimizer) or agent.
**Cues:** "the steps are known", "distinct kinds of input", "each step depends on the last", "no clear criteria for good", "open-ended research".
**The call:** treat each pattern's precondition as a requirement. Known steps with a need for consistency, latency or auditability: a workflow. Distinct input categories: routing (classify, then dispatch to specialised handlers). Dependent stages: chaining with programmatic gates between steps. Explicit quality criteria plus measurable gain from iteration: evaluator-optimizer. Steps that cannot be known in advance: an agent. Climb the ladder (plain call, augmented LLM, workflow, agent, multi-agent) only when the requirement forces it.
**Tempting wrong calls:**
- An autonomous agent for a fixed, well-specified pipeline.
- Chaining when the input has categories (that is routing) or routing when the stages are sequential (that is chaining).
- Evaluator-optimizer with no criteria to evaluate against.
- One monolithic prompt for a task that needs staged quality gates.
- Jumping to a free-running agent when the subtasks are only known once the input is read but a fixed coordinator can still split and merge them. That is orchestrator-workers: the coordinator plans, workers do bounded pieces, and every run stays inspectable.
**In practice:** a Switch node is routing, a chain of nodes with IF checks is chaining, two merged branches are parallelisation; an AI Agent node left to plan its own tool calls is the agent.
**Read more:** Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/1-solution-design/1-3-architectural-patterns

## D1.4 Multi-agent systems: subagents see nothing of each other, so the coordinator briefs them

**Decide:** whether to split into several agents, and how to diagnose a broken split.
**Cues:** "the report has duplicated sections and gaps", "add more subagents", "the subagent should see the conversation", "it fits in one context".
**The call:** a subagent starts with a fresh context window and sees neither the coordinator's conversation nor the other subagents' findings, so the coordinator gives each one a bounded, non-overlapping brief with a defined output. Duplication plus gaps is the signature of unpartitioned briefs, and a stronger model given the same briefs produces the same overlap. A split costs roughly an order of magnitude more tokens plus latency and orchestration; it is justified by separate tools and permissions or real concurrency, not by "more is better". (Current Claude Code adds exceptions: a fork inherits the parent conversation, and agents with messaging can talk; the design rule still holds.)
**Tempting wrong calls:**
- Diagnosing overlap and gaps as a subagent capability problem.
- Assuming subagents share the coordinator's context.
- Multi-agent for a task that fits comfortably in one context window.
- Fixing coverage gaps by adding more subagents with the same briefs.
**In practice:** three workers each given a clear slice of the report, versus three told "research the company" who all write the same section.
**Read more:** Anthropic, How we built our multi-agent research system (https://www.anthropic.com/engineering/multi-agent-research-system); study lesson https://claudecertificationguide.com/ccar-p/learn/1-solution-design/1-4-multi-agent-systems

## D1.5 Decomposition: split when quality measurably improves, pass structure between stages

**Decide:** whether and how to break a long multi-part task into stages.
**Cues:** "forty contracts in one call", "inconsistent depth across sections", "a bigger context window", "the stages hand each other summaries", "cross-file issues".
**The call:** decompose into bounded sub-tasks with structured hand-offs (typed intermediate outputs with acceptance gates, not free-text summaries) when an evaluation shows quality improves, and add an integration pass for issues that cross units. Attention dilution is structural: a model asked to hold everything treats each part shallowly, and a bigger window does not cure it. Every split adds latency, cost and an interface, so a pipeline that nobody measured is over-engineering too.
**Tempting wrong calls:**
- Splitting a task that already works in one call because staging looks rigorous.
- A larger model or window for inconsistent-depth symptoms.
- Local passes only, with no integration pass.
- Free-text summaries between stages: downstream re-interprets prose and stages cannot be tested alone.
**In practice:** review forty contracts one at a time against a checklist, then one pass across all of them for conflicts.
**Read more:** Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/1-solution-design/1-5-decomposition-techniques

## D1.6 Business value pillars: name the pillar and its measurement, respect the stated constraint

**Decide:** which kind of return a design serves, and which cost lever respects the stated SLA.
**Cues:** "is this efficiency or transformation", "batch it to save money" on a chat flow, "a 3-second p95 with two large calls", "99.9% availability".
**The call:** five pillars. Efficiency: the same outcome with less input (automating what already exists). Transformation: a capability that was not possible before. Productivity: people deliver more with assistance. Cost: unit economics per task versus the baseline, controlled by right-sizing, caching and batching. Performance SLAs: contractual latency, availability and quality targets. One question separates the first two: did the capability already exist? Caching serves cost and latency together on the request path; batching serves cost off the request path and cannot sit on it. Stage times add up: sum the budget against the p95 and move model calls off the path when they do not fit; design queuing or human fallback for availability.
**Tempting wrong calls:**
- The most capable model for every task "to be safe".
- Calling the automation of an existing process transformation.
- Batch for an interactive use case, or caching for one-off asynchronous volume.
- Accepting sequential large-model calls against a tight p95, or an availability target with no fallback.
**In practice:** automating the invoice chase is efficiency; a round-the-clock advisor the business never had is transformation.
**Read more:** Anthropic, Prompt caching (https://docs.claude.com/en/docs/build-with-claude/prompt-caching) and Message Batches (https://docs.claude.com/en/docs/build-with-claude/batch-processing); study lesson https://claudecertificationguide.com/ccar-p/learn/1-solution-design/1-6-business-value-pillars
