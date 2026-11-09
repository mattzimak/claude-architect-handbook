# F1 Agentic Architecture and Orchestration (27% of the Architect - Foundations blueprint, 7 decisions)

This domain decides how an agent actually runs: what keeps its loop going, how a coordinator splits and briefs work, which rules live in code instead of the prompt, and how long work carries over between sessions. Builders go wrong in two directions: they trust the prompt with steps that must never be skipped, and they assume subagents and resumed sessions know more than they were given. Rule ids follow the official CCAR-F task statements 1.1 to 1.7.

## F1.1 Agentic loops: let stop_reason drive the loop, never the reply text

**Decide:** what tells your loop code to go round again or to stop.
**Cues:** "it stops halfway on longer tasks", "stop after 10 iterations", "check whether it said it was done".
**The call:** read `stop_reason` on every response. On `tool_use`, run each requested tool, append the results to the history as `tool_result` blocks and call again; on `end_turn`, hand over the answer. A result you do not append never reaches the model. The model picks the next tool; only a step order that must hold goes into code (F1.4).
**Exam key vs now:** Exam: `tool_use` continues, `end_turn` stops. Now: the API returns seven values, adding `max_tokens`, `stop_sequence`, `pause_turn`, `refusal` and `model_context_window_exceeded`; treat anything except `end_turn` as unfinished and route it on purpose.
**Tempting wrong calls:**
- Raise the iteration cap to cure early exits. A cap stops runaways; it cannot revive a loop that quit too soon.
- Stop on "all done" or a leading text block. One reply often holds a sentence and a tool call.
- Drop or summarise tool results between rounds. Shrink the tool's output instead.
**In practice:** a hand-built loop in a Code node or a Worker branches on `stop_reason` and sends every other exit to a retry or a person, never to "resolved".
**Related:** F1.4, F5.3
**Read more:** Handling stop reasons (https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons); study lesson https://claudecertificationguide.com/learn/1-agentic-architecture/1-1-agentic-loops

## F1.2 Multi-agent orchestration: the coordinator owns the split, the routing and the coverage

**Decide:** how a coordinator divides a job, which subagents it calls, and where a coverage gap comes from.
**Cues:** "the report covers only part of the topic", "every subagent did its job", "let them talk directly".
**The call:** hub-and-spoke. The coordinator splits the request into parts that span the whole topic, gives each subagent a distinct slice (a subtopic or a source type), calls only the subagents the query needs, and routes every result and error through itself, so logging, error handling and context stay in one place. After synthesis it checks for gaps and sends targeted follow-ups. An area missing while every subagent stayed on brief means the split was too narrow, as the guide's published sample on a one-sided research report keys.
**Exam key vs now:** Exam: subagents never talk to each other. Now: Claude Code subagents can spawn their own and message named agents with `SendMessage`. Keep the hub for whatever you must observe.
**Tempting wrong calls:**
- Better searches or a stronger synthesis agent for a missing category. A subagent covers only its assignment.
- Direct agent-to-agent messages "for speed". They bypass the hub's log and error handling.
- The full pipeline for every query. A simple lookup needs one subagent.
**In practice:** a report from an orchestrator workflow misses a product line: read its split before editing any worker prompt.
**Related:** D1.4, D7.3, F1.3
**Read more:** Anthropic, How we built our multi-agent research system (https://www.anthropic.com/engineering/multi-agent-research-system); study lesson https://claudecertificationguide.com/learn/1-agentic-architecture/1-2-orchestration-patterns

## F1.3 Subagent invocation: a subagent knows only what its prompt carries

**Decide:** how a coordinator is wired to spawn subagents, and what it hands each one.
**Cues:** "the coordinator never delegates", "the synthesis lost its citations", "spawn them one after another".
**The call:** check the wiring first: the spawning tool is on the coordinator's `allowedTools`, and each AgentDefinition has a `description` (when to use it), a `prompt` (its role) and a short `tools` list. Then brief: a normal subagent starts with no conversation, so pass complete earlier findings as structured records that keep each claim apart from its URL, document and page. State the goal and quality bar, not a procedure. Spawn independent subagents as several calls in one response.
**Exam key vs now:** Exam: the tool is Task, and without "Task" in `allowedTools` nothing spawns. Now: it is Agent since Claude Code v2.1.63 (Task still works); `allowedTools` only auto-approves, so an omission sends spawns to a permission check that unattended runs refuse. A fork copies the parent conversation.
**Tempting wrong calls:**
- Rewrite the synthesis prompt when citations vanish. It cannot cite sources the coordinator stripped.
- Assume a subagent sees the coordinator's history or a sibling's output.
- A rigid step list. It breaks at the first unforeseen input.
**In practice:** a custom agent in `.claude/agents/` with a sharp description and three tools, briefed with files, goal and return format.
**Related:** D1.4, F1.2, F5.6
**Read more:** Subagents in the SDK (https://code.claude.com/docs/en/agent-sdk/subagents); study lesson https://claudecertificationguide.com/learn/1-agentic-architecture/1-3-subagent-invocation-context

## F1.4 Workflow enforcement and handoff: when one miss costs money, gate the order in code

**Decide:** whether a required step order lives in the prompt or in code, and what a person receives at handover.
**Cues:** "the prompt already says verify first", "it skips the check now and then", "staff ask the customer everything again".
**The call:** ask what one failure costs. If a single miss means lost money, a security breach or a compliance breach, add a prerequisite gate: the downstream tool refuses to run until the earlier step returned what it needs (a verified customer id, a passed check), and its error names the missing step. The guide's published sample on skipped identity checks keys this gate. Tone and layout stay in the prompt. Split a multi-issue message into items, investigate them in parallel on shared account context, answer once. Staff taking over have no transcript, so the handoff stands alone.
**Tempting wrong calls:**
- Firmer wording or few-shot examples. Better odds, still not zero misses.
- A routing classifier. It picks the agent; the skip happens inside it.
- Handing staff the chat log, or a summary without amount or next step.
**In practice:** an IF node before the refund node checks a verified flag set by the lookup; the escalation carries customer id, summary, root cause, exact amount, recommended action and what was already verified or done.
**Related:** D5.1, F1.5, F5.2
**Read more:** Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/learn/1-agentic-architecture/1-4-workflow-enforcement-handoff

## F1.5 Agent SDK hooks: block before the tool runs, normalise after it returns

**Decide:** which hook point enforces a rule or cleans data between the model and its tools.
**Cues:** "refunds over a limit go to a person", "must never", "dates arrive in three formats", "flag the transfer afterwards".
**The call:** a hook is code, so it applies the rule every time. PreToolUse is for policy: it sees the call before it runs, returns a `permissionDecision` (`allow`, `deny`, `ask`, `defer`), can rewrite the arguments with `updatedInput`, and can send the case to a person instead. PostToolUse is for results: after the tool, before the model reads the output, it converts timestamps, decodes status codes and drops unused fields, replacing what the model sees with `updatedToolOutput`. PostToolUse cannot stop an action: it fires after the side effect. Preferences such as formatting can stay in the prompt.
**Tempting wrong calls:**
- PostToolUse to block a policy breach. The side effect already happened.
- PreToolUse to tidy a tool's output. There is no output yet.
- Leaving the model to reconcile mixed formats. It reads them differently each turn.
- A stronger prompt for a rule that must hold every time.
**In practice:** this workspace's PreToolUse guards deny risky writes and deploys; a PostToolUse hook on `Edit|Write` can run the formatter after every edit, and exit code 2 shows the failure to Claude.
**Related:** D5.1, D7.1, F1.4
**Read more:** Agent SDK hooks (https://code.claude.com/docs/en/agent-sdk/hooks); study lesson https://claudecertificationguide.com/learn/1-agentic-architecture/1-5-agent-sdk-hooks

## F1.6 Task decomposition: a fixed chain for known steps, an adaptive plan for open scope

**Decide:** whether work runs as a predetermined sequence or a plan that rewrites itself, and how many items one pass may hold.
**Cues:** "review this 30-file change", "early files get detail, later ones a line", "add tests to the legacy code".
**The call:** match the pattern to what is known. Known steps and structured input (reviews, extraction, compliance checks): prompt chaining, consistent and easy to debug step by step. Unknown scope (legacy code, debugging, open research): map the structure, rank high-impact areas, plan, re-plan as dependencies surface. Packing many items into one pass spreads attention unevenly, so give each item its own pass plus a separate integration pass for what crosses items (data flow, inconsistent judgements). The guide's published sample on a many-file pull request keys that split.
**Tempting wrong calls:**
- A bigger model, window or prompt. Every item still competes in one pass.
- Batches with no integration pass. Cross-batch issues stay invisible.
- Several full passes, keeping only issues most agree on. Real bugs caught once get voted out.
- An adaptive agent for a structured job, or a fixed chain for an open one.
**In practice:** a Loop Over Items node reviews each document alone, then one AI call compares the per-item results.
**Related:** D1.3, D1.5, F1.2
**Read more:** Prompting best practices, chain complex prompts (https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices#chain-complex-prompts); study lesson https://claudecertificationguide.com/learn/1-agentic-architecture/1-6-task-decomposition

## F1.7 Session state: resume while the history holds, start fresh once it has gone stale

**Decide:** whether to continue a prior session, branch it, or start a new one seeded with a summary.
**Cues:** "pick up yesterday's analysis", "I changed those files overnight", "compare two approaches".
**The call:** three tools, three jobs. Resume (`--resume <name>`) when the earlier tool results still describe reality; if a few files changed, name them for a re-read. Fork for two directions from one shared analysis, each blind to the other. Start fresh with an injected, structured summary when much of the history describes files or dependencies that have since changed: stale results left in context keep pulling the model back even after a re-read. List the changed files so only they are re-read.
**Exam key vs now:** Exam: `--resume` and `fork_session` are separate controls. Now: fork modifies a resume (SDK `resume` plus `fork_session=True`; CLI `--fork-session` only with `--resume` or `--continue`), names come from `--name` or `/rename`, and a fork branches the conversation, not the files on disk.
**Tempting wrong calls:**
- Resume and ask for a re-read after large changes. The stale results stay.
- Fork to escape stale context. The branch copies it.
- Fork to continue one line of work. The job splits across sessions.
**In practice:** after hand-editing a workflow export, start a new Claude Code session with a findings summary and the changed files.
**Related:** D2.4, F5.4
**Read more:** Work with sessions (https://code.claude.com/docs/en/agent-sdk/sessions); study lesson https://claudecertificationguide.com/learn/1-agentic-architecture/1-7-session-state-resumption
