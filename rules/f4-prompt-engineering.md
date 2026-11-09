# F4 Prompt Engineering and Structured Output (20% of the Architect - Foundations blueprint, 6 decisions)

This domain decides how model output becomes something code and people can rely on: what the prompt counts as a finding, how examples pin down format and judgement, how the shape of a reply is enforced, what happens when the content is wrong, which work can wait for half-price processing, and who checks the result. Builders lose here by writing adjectives where they needed criteria, by trusting a schema to catch wrong values, and by letting the session that did the work also mark it. Rule ids follow the official CCAR-F task statements.

## F4.1 Review criteria: list what to report and what to ignore, never "be conservative"

**Decide:** how a review prompt defines a valid finding, and what to do when one category floods readers with wrong flags.
**Cues:** "be conservative", "only report high-confidence findings", "the team ignores the bot", "critical in one file, minor in the next".
**The call:** write criteria as categories: what to report (bugs, security holes), what to skip (style taste, local conventions), and the exact trigger for borderline types (flag a comment only when it claims behaviour the code lacks). Anchor each severity level with a real code pattern, not an adjective. If one category produces most of the wrong flags, switch it off while you rework it: its false alarms teach readers to discount every category. Confidence can route findings later; it never replaces criteria.
**Tempting wrong calls:**
- "Only report findings you are sure of". Self-rated certainty is poorly calibrated, so precision barely moves.
- Keeping every category live while fixing the noisy one. Readers already skim the whole report.
- Severity described in prose. The model still has to interpret it; a code sample removes the guess.
- Lowering the temperature. Sampling is not the cause; an undefined target is.
**In practice:** a Claude Code reviewer prompt ending "report correctness gaps, skip style"; in n8n, a category field on each finding so an IF node can mute the noisy one.
**Related:** D2.2, D2.3, F4.2, F4.6
**Read more:** Anthropic, Prompting best practices (https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices); Claude Code best practices, review against your spec (https://code.claude.com/docs/en/best-practices); study lesson https://claudecertificationguide.com/learn/4-prompt-engineering/4-1-system-prompts

## F4.2 Few-shot examples: when instructions stop working, show the failing case with its reasoning

**Decide:** when to add worked examples to a prompt, how many, and which cases they cover.
**Cues:** "we described the format and it still changes", "the same pattern rated differently", "the field is empty but the figure is in the text".
**The call:** once a clear instruction has failed to steady the output, stop adding prose and show the target. Aim a few examples at the cases that actually fail, and give each a line of reasoning saying why this answer beat the plausible alternative; the reasoning is what carries the judgement to inputs you never showed. For extraction, include a value buried in running text, not only one in a table: empty fields and invented values both drop.
**Exam key vs now:** Exam: 2 to 4 targeted examples. Now (platform docs, checked 2026-11-09): 3 to 5, each in `<example>` tags.
**Tempting wrong calls:**
- More detailed format instructions. Describing the format again rarely stops drift; a finished example does.
- An example for every variant. Tokens climb and the model learns the list, not the rule.
- Pairs with no reasoning. The model copies surface features and misses the next new case.
- Examples as the first fix for a wrong tool choice. Descriptions come first, as the guide's published tool-selection sample keys.
**In practice:** two finished replies in the AI Agent node's system message; for invoices, one tabular example and one where quantity and price sit in a sentence.
**Related:** D2.3, F4.1, F4.3, F2.1
**Read more:** Anthropic, Prompting best practices, use examples effectively (https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices); study lesson https://claudecertificationguide.com/learn/4-prompt-engineering/4-2-few-shot-prompting

## F4.3 Structured output: let the API enforce the shape, and let the schema admit absence

**Decide:** how a reply becomes machine-readable data, how the tool call is made to happen, and which fields may stay empty.
**Cues:** "the parser crashes on a chatty reply", "the document type is unknown", "this extraction must run first", "it made up a purchase order number".
**The call:** let the API enforce the shape: an extraction tool whose input schema is the record beats a prefilled opening, which beats asking for JSON. `auto` may reply in prose, `any` forces some tool (unknown document type), a named tool forces that one (a mandatory first step, then back to `auto`). Fields the source may lack are nullable and outside `required`; enums get "unclear" and "other" plus a detail string; format rules go in the prompt. Shape, never correctness.
**Exam key vs now:** Exam: tool use with a schema, three `tool_choice` modes. Now (platform docs, checked 2026-11-09): only `strict: true` or `output_config.format` guarantees the schema; Opus 5.5, Sonnet 5.5, Fable 5.1 and Mythos 5.1 reject `any` and a named tool with a 400 (use `auto` plus `strict: true`); a last-turn prefill is a 400 from Claude 4.6 on; `none` is a fourth mode.
**Tempting wrong calls:**
- Prompt-only JSON in an unattended pipeline. It breaks now and then.
- Every field required. Missing values get invented.
- A named tool for an unknown document type. Everything lands in one schema.
- A forced tool left on for every turn. The loop never ends.
**In practice:** the n8n Structured Output Parser with optional fields; in a Worker, `output_config.format` plus a `stop_reason` check before parsing.
**Related:** D2.2, D1.2, F2.3, F3.6, F4.4
**Read more:** Anthropic, Structured outputs (https://platform.claude.com/docs/en/build-with-claude/structured-outputs); Define tools, forcing tool use (https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools); study lesson https://claudecertificationguide.com/learn/4-prompt-engineering/4-3-structured-output

## F4.4 Validation and retry: send the specific error back, and only for errors the document can fix

**Decide:** which checks run after extraction, what a retry carries, and when to hand over instead.
**Cues:** "the line items don't add up", "just call it again", "the reference isn't on the document", "the JSON stops halfway".
**The call:** check meaning in code after the schema: sums, date order, values in the right fields. A retry carries the source, the failed extraction and the exact rule broken. Retry only what the source can fix (format, a misplaced value, a missed line); an absent value becomes null or goes to a person. Build self-checks into the schema (`calculated_total` beside `stated_total`, `conflict_detected`) and tag findings with `detected_pattern` so dismissals can be counted. Output that grows with the input and stops at `max_tokens` is split into smaller calls and merged.
**Exam key vs now:** Exam: split and merge, not a higher `max_tokens` (a scored objective; guide v1.0 is silent on it). Now (platform docs, checked 2026-11-09): raise `max_tokens` or continue the response, which suits a fixed-size reply that ran slightly over.
**Tempting wrong calls:**
- A bare "try again". Without the named error, the same mistake comes back.
- Retrying until a missing field fills. The loop invents a value or burns calls.
- Picking one of two conflicting source values. Extract both, flag, route.
- No code checks because the schema is enforced. A schema cannot make two numbers agree.
**In practice:** an n8n Code node recomputes the total and an IF node loops back once with the error text, then to a review queue.
**Related:** D1.2, D2.2, D5.3, F4.3, F5.5
**Read more:** Anthropic, Structured outputs, invalid outputs (https://platform.claude.com/docs/en/build-with-claude/structured-outputs); Handling stop reasons (https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons); study lesson https://claudecertificationguide.com/learn/4-prompt-engineering/4-4-validation-retry-loops

## F4.5 Batch processing: half price only where nothing is waiting

**Decide:** which workloads go to the Message Batches API, and how to schedule, match and recover them.
**Cues:** "halve the API bill", "move everything to batch", "results due within 30 hours", "look up a record halfway through".
**The call:** batch the work whose results are used later (nightly reports, weekly audits, bulk extraction); keep anything a person or a merge waits on synchronous. Batches cost 50% less but take up to 24 hours with no latency promise, so schedule for the worst case: a 30-hour promise means submitting at least every 4 hours. Match results by a unique `custom_id`. Resubmit only the failed or expired ids, changed (chunk an oversized document), after tuning the prompt on a small sample.
**Exam key vs now:** Exam: one batch request cannot call your tool and carry on from the result. Now (platform docs, checked 2026-11-09): server tools (web search, code execution, MCP connectors) loop inside a batch item and may return `pause_turn`; a tool your own code runs still ends the item at `tool_use`.
**Tempting wrong calls:**
- Batch for a blocking check, with a fallback timer. It still waits on a service that promises no time.
- Resubmitting the whole batch. You pay again for what succeeded.
- Matching results by position. Order is not kept.
- A higher `max_tokens` for a document that overflowed the context. That caps output; chunk the input.
**In practice:** an n8n schedule gathers the day's records and submits one batch at night; the webhook a client waits on stays on a normal call.
**Related:** D1.6, D4.5, F4.4
**Read more:** Anthropic, Message Batches (https://platform.claude.com/docs/en/build-with-claude/batch-processing); study lesson https://claudecertificationguide.com/learn/4-prompt-engineering/4-5-batch-processing

## F4.6 Review architecture: a fresh instance checks the work, one pass per unit, then one across units

**Decide:** who reviews model output, how a large review is split, and how uncertain findings reach a person.
**Cues:** "now review your code" in the same chat, "thorough on the first files, thin on the rest", "flags a pattern here and approves it there", "use the bigger context window".
**The call:** review in a separate invocation that sees the output, not the reasoning behind it; the generating session defends its own choices, however long it thinks. Split a large review into one focused pass per file or document, then a separate pass over the collected findings for cross-unit problems and contradictions. Ask for confidence per finding, but route on it only after calibrating thresholds on a labelled set; low confidence goes to a person. Spend this where a missed issue costs money or trust.
**Tempting wrong calls:**
- "Review this carefully" in the same conversation. The reasoning behind the mistake is still in context.
- Extended thinking in the generating session. Same context, same blind spot.
- A bigger window or higher tier for a many-file review. More room does not spread attention evenly.
- Routing on raw confidence. Uncalibrated scores are not probabilities.
**In practice:** Claude Code's `/code-review`, or a read-only reviewer subagent in `.claude/agents/`; in n8n, a separate AI node per document with no shared memory, then one node that compares the results.
**Related:** D7.2, D5.3, D4.2, F1.6, F3.6, F5.5
**Read more:** Claude Code best practices (https://code.claude.com/docs/en/best-practices); Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/learn/4-prompt-engineering/4-6-multi-pass-review
