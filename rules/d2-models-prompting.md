# D2 Claude Models, Prompting and Context Engineering (13% of the blueprint, 5 decisions)

Model items are diagnosis: the cheapest technique that fixes the observed failure, the smallest model that reaches the measured bar, and static content first so the prefix caches. Model decisions are made by tier (small and fast, balanced, most capable, with extended thinking as a lever), never by prestige. Rule ids follow the official CCAR-P task statements.

## D2.1 Model selection: the smallest model that reaches the measured bar, escalating on evidence

**Decide:** which model tier runs each stage, and when to move.
**Cues:** "use the biggest model to be safe", "switch to the cheapest model to cut the bill", "outputs are inconsistent", "we use the alias", "the model is being retired".
**The call:** select on measured constraints, not prestige. Start balanced, route hard cases up and easy cases down on eval evidence (the escalation cascade), and use extended thinking only where reasoning depth is the bottleneck. Re-run the quality evals before moving in either direction. Pin versions, watch deprecation notices, re-validate before migrating. Inconsistent output is an instruction problem before it is a capability problem.
**Exam key vs now:** Exam: extended thinking is a lever you switch on with a token budget. Now: manual thinking with `budget_tokens` is deprecated and returns a 400 on Claude 4.7 and later models; thinking is adaptive, always on for Fable 5.1 and Opus 5.5, and its depth is set with `output_config.effort` (extended thinking and effort docs, checked 9 Nov 2026).
**Tempting wrong calls:**
- Everything on the biggest model with no measured quality gain.
- The smallest model as a cost fix without re-running evals.
- Production on an alias or a soon-to-retire model.
- Upgrading the tier because outputs are inconsistent: a larger model follows ambiguous instructions at a higher price.
**In practice:** a small, fast model for the 80% of routine tickets and a stronger one only for the cases the first model flags as uncertain.
**Read more:** Anthropic, Choosing a model (https://docs.claude.com/en/docs/about-claude/models/choosing-a-model) and Extended thinking (https://docs.claude.com/en/docs/build-with-claude/extended-thinking); study lesson https://claudecertificationguide.com/ccar-p/learn/2-models-prompting/2-1-model-selection-trade-offs

## D2.2 System prompts, templates and guardrails: a clear contract plus code-level validation

**Decide:** what goes in the system prompt, and what instructions can and cannot guarantee.
**Cues:** "we repeat the policy in every message", "it invented a figure", "we told it never to invent", "all schema fields are required", "the prompt is our only safeguard".
**The call:** standing policy, role and format rules live in the system prompt (stable authority, consistent behaviour, a cacheable prefix); per-request content goes last. Hallucination under a vague contract is a prompt design failure: restrict scope to the provided text and give an explicit way to say the source lacks the information, with optional fields and a null path so the model is never forced to invent to satisfy a schema. Instructions shape behaviour; code-level validation around the model (parsing, schema checks, business rules) enforces it.
**Tempting wrong calls:**
- Restating policy in each user turn: it drifts, loses authority and destroys the cacheable prefix.
- A larger model or lower temperature for an invented-fact incident.
- System prompt instructions as the sole guardrail around a sensitive workflow.
- Every schema field mandatory plus a bold "never invent" rule.
- A guardrail that blocks and goes nowhere. Every refusal or failed check needs a route (a fallback reply, a human queue, a narrower retry), or the safety control turns into an outage for the user.
**In practice:** the agent node's system message holds the rules; the incoming item is the user turn; a Structured Output Parser plus an IF node check the result. A schema-constrained call can still come back off-schema when it stops for a refusal or at `max_tokens`, so the check after the AI node reads `stop_reason` before the parser runs.
**Read more:** Anthropic, System prompts (https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/system-prompts) and Reduce hallucinations (https://docs.claude.com/en/docs/test-and-evaluate/strengthen-guardrails/reduce-hallucinations); study lesson https://claudecertificationguide.com/ccar-p/learn/2-models-prompting/2-2-system-prompts-and-guardrails

## D2.3 Prompting techniques: the cheapest technique that fixes the observed failure

**Decide:** zero-shot, few-shot examples, chain-of-thought, or built-in thinking.
**Cues:** "the format drifts", "it confuses the boundary between sections", "the totals are wrong", "the reasoning leaks into the output".
**The call:** diagnose the failure class, then match the technique. Format and boundary failures: exact-format few-shot examples. Multi-step reasoning failures: reasoning instructions or extended thinking. Inconsistency: clearer instructions. Keep reasoning separate from the payload a parser reads. Splitting into several calls is a Domain 1 architecture decision, not a prompting technique. (Current guidance: on newer models rely on built-in thinking rather than prompted written-out reasoning.)
**Exam key vs now:** Exam: prompted chain-of-thought is the fix for multi-step reasoning failures. Now: on Fable 5.1, Fable 5, Opus 5.5, Opus 5 and Sonnet 5.5 the prompting guide says to rely on built-in thinking, at a lower effort if cost matters, and a prompt that asks the model to write its reasoning out (for example in thinking tags) may be declined (prompting best practices, checked 9 Nov 2026).
**Tempting wrong calls:**
- A larger model for a prompt-shaped failure: the same prompt fails the same way, at a premium.
- Chain-of-thought for a format problem: reasoning does not teach format, examples do.
- Few-shot examples for a reasoning problem: examples show outcomes, not the path.
- Reasoning mixed into the final answer the downstream parser consumes.
- Few-shot examples that all show the clean case. Examples teach exactly the pattern they show; for a boundary that keeps being crossed, include near-miss cases on both sides of the line, three to five varied examples in all.
**In practice:** show the model two finished emails to fix the layout; ask it to work out the total step by step to fix the arithmetic.
**Read more:** Anthropic, Prompt engineering overview (https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/overview); study lesson https://claudecertificationguide.com/ccar-p/learn/2-models-prompting/2-3-prompt-engineering-techniques

## D2.4 Context window optimisation: the window is a budget, not capacity to fill

**Decide:** what the model sees on each request and how long sessions stay healthy.
**Cues:** "move to the bigger window and load more", "enable caching to make room", "cut everything to 4,000 tokens", "the agent carries every old tool result".
**The call:** curate by relevance. Compact long conversations and edit out stale tool results and thinking blocks to reclaim space while keeping working state. Caching changes what tokens cost, not whether they fit or how well the model recalls them. Blind truncation by position is a silent quality loss, which is why it appears as a wrong option in the official guide's own sample.
**Tempting wrong calls:**
- A bigger window and more content as the fix for a cost or quality problem: context rot, cost and latency all grow with load.
- Caching to make room near the window limit.
- Truncating to a fixed token count regardless of what the task needs.
- Letting an agent session carry every stale tool result forever.
**In practice:** archive old items from the run instead of carrying them through every node. For long agent sessions the API now offers two kinds of server-side compaction, both beta: on demand, where your code asks for the summary, and at a token threshold, where the API writes it once input reaches your trigger; Anthropic says to use on-demand wherever it is available, and context editing (also beta) clears old tool results by rule instead of summarising them.
**Read more:** Anthropic, Effective context engineering (https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents); Context editing (https://docs.claude.com/en/docs/build-with-claude/context-editing); study lesson https://claudecertificationguide.com/ccar-p/learn/2-models-prompting/2-4-context-window-optimisation

## D2.5 Prompt reuse: static first and cached, modular prompts, Skills on demand

**Decide:** how repeated content is served cheaply and how expertise is packaged.
**Cues:** "the same 8,000-token policy on every request", "we cache the timestamp too", "put the whole procedure library in the system prompt", "trim the examples to save money".
**The call:** static content first, per-request values last, cache the prefix: cost and time to first token drop together (the official guide's Domain 2 sample). Per-request values marked as cached cost more, not less, because the prefix never matches. Skills load expertise on demand for a small standing metadata cost, so the request pays only for the procedures it uses.
**Tempting wrong calls:**
- Marking content that changes every request as cached.
- "Enable caching" for window overflow or quality problems.
- Trimming examples or downsizing the model to cut spend that the cache would remove for free.
- The whole procedure library in every system prompt.
- Marking a short prompt for caching and assuming it is cached. Below the model's minimum cacheable length (512 tokens on the current Fable, Opus, Sonnet and Haiku models, more on older ones) the request simply runs uncached with no error; read `cache_read_input_tokens` in the usage block to know.
- Pasting the shared policy text by hand into every workflow's prompt. The copies drift apart within weeks; keep one reviewed template with named slots, versioned and evaluated before it ships.
**In practice:** a 20-page policy sent on every call gets cached; the customer's question changes every time, so it goes after; the skill folders on your machine load their body only when the task needs it. Caching pays only when the same prefix comes back inside the cache lifetime: after one read on the 5-minute cache, after two on the 1-hour one. A workflow that fires a few times an hour pays the write premium on every call and reads nothing back.
**Read more:** Anthropic, Prompt caching (https://docs.claude.com/en/docs/build-with-claude/prompt-caching) and Agent Skills (https://www.anthropic.com/news/skills); study lesson https://claudecertificationguide.com/ccar-p/learn/2-models-prompting/2-5-prompt-reuse-strategies
