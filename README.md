# Claude Architect Handbook

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) ![Plugin 0.2.0](https://img.shields.io/badge/plugin-0.2.0-black) ![68 rules](https://img.shields.io/badge/rules-68-2ea043) ![Unofficial](https://img.shields.io/badge/unofficial-not%20affiliated%20with%20Anthropic-lightgrey)

The judgement an architect applies when building with Claude, as a Claude Code plugin that fires while you build. 68 decisions keyed to the public Claude Certified Architect blueprints: 38 at Professional level (agents, tools, credentials, MCP, retrieval, evals, human review, guardrails, compliance data, model tiers, caching, SLAs, team setup) and 30 at Foundations level (agent loops, subagent briefs, enforcement in hooks, tool descriptions and errors, MCP and Claude Code configuration, structured output, batch, escalation, provenance). Each rule names the cue in a request that makes it the live question, the right call, and the tempting wrong call most builders reach for first.

It is written for people who build with automations (n8n, Workers, pipelines) and coding agents, with or without an engineering background. The 216-term vocabulary translates every engineering word into the thing it corresponds to in automation or client work.

## What it does

- **Answers design questions by rule.** Ask "should this be an agent", "which model", "do we need MCP", "where does the human sit", "how do we measure it". Ask "where should this instruction live", "why does my agent stop halfway", "how do I force structured output". Claude names the rule (for example D3.2 or F1.4), quotes the cue from your request, gives the call, and names the shortcut it replaces (add logging, add MFA, bigger model, more agents, fine-tune, batch it, enable caching, strengthen the prompt).
- **Gates plans and workflows.** `/architect-handbook:architect-review <path>` reads a plan, an n8n export, an agent or MCP config, a system prompt or a diff and returns ranked findings (must fix, should fix, consider), each with the rule id, the evidence quoted from the artefact, the fix, and the constraint under which your current design would have been right.
- **Fires while you build.** A prompt hook recognises architecture decisions in what you type and reminds Claude to apply the rules, once in full per session and then in one line. A rule template does the same when Claude touches an agent, MCP, prompt, workflow or eval file.
- **Explains the words.** `vocab p95`, `vocab confused deputy`, `vocab token passthrough`: plain meaning, the "in your world" line, and the rules it serves.

## Install

**Claude Code in a terminal:**

```
/plugin marketplace add mattzimak/claude-architect-handbook
/plugin install architect-handbook@mattzimak-architect
```

**VS Code extension:** type `/plugins` on its own to open **Manage plugins**. On the **Marketplaces** tab, add `mattzimak/claude-architect-handbook`. On the **Plugins** tab, find `architect-handbook`, click **Install** and pick a scope. The two `/plugin` lines above do not work in the VS Code panel: typed with arguments there, they get the reply "/plugin isn't available in this environment".

**From a shell**, without starting a session:

```
claude plugin marketplace add mattzimak/claude-architect-handbook
claude plugin install architect-handbook@mattzimak-architect
```

If the short form fails, add the marketplace by its URL: `https://github.com/mattzimak/claude-architect-handbook.git`.

Then:

```
/architect-handbook:architect-rules should my refund flow be an agent or a workflow?
/architect-handbook:architect-review workflows/lead-router.json
```

Optional, for the file trigger: copy [templates/agent-architecture.md](templates/agent-architecture.md) to `.claude/rules/agent-architecture.md` in your project (or `~/.claude/rules/` for every project). Plugins cannot install rules, so this one step is yours.

You can also just talk. "Is this design right", "review the architecture", "which search for stock levels" load the right skill.

## The rules

One file per domain under [rules/](rules/), one section per decision. Weights are the blueprints'.

### Professional (D1-D7, 38 decisions)

| Domain | Weight | Decisions |
|---|---|---|
| [D3 Integration](rules/d3-integration.md) | 19% | capability bloat, authentication and authorisation gaps, accuracy versus latency, observability, RAG pipeline design, retrieval strategy, integration mechanism (MCP, API, agent-to-agent), progressive discovery |
| [D1 Solution Design](rules/d1-solution-design.md) | 17% | translating the business problem, the six stages of an end-to-end architecture, pattern selection, multi-agent systems, decomposition, business value pillars |
| [D4 Evaluation](rules/d4-evaluation.md) | 16% | metrics, eval sets and graders, A/B and rollout, diagnosing failures, token and cost optimisation, monitoring |
| [D5 Governance](rules/d5-governance.md) | 14% | guardrails, risk registers, human in the loop, compliance as a design constraint (GDPR, HIPAA, FedRAMP), fairness and disclosure |
| [D6 Stakeholders and lifecycle](rules/d6-stakeholders.md) | 14% | discovery, communicating trade-offs, service levels, documentation, lifecycle and deprecation |
| [D2 Models and prompting](rules/d2-models-prompting.md) | 13% | model tier, system prompts and guardrails, prompting techniques, context window, prompt reuse and caching |
| [D7 Developer productivity](rules/d7-developer-productivity.md) | 7% | team tooling (guidance versus enforcement), measuring AI-assisted work, debugging agent incidents |

### Foundations (F1-F5, 30 decisions)

| Domain | Weight | Decisions |
|---|---|---|
| [F1 Agentic Architecture and Orchestration](rules/f1-agentic-architecture.md) | 27% | agentic loops and stop reasons, coordinator and subagents, subagent briefs and context passing, enforcement and handoff, hooks, task decomposition, session state and resumption |
| [F3 Claude Code Configuration and Workflows](rules/f3-claude-code-config.md) | 20% | the CLAUDE.md hierarchy, commands and skills, path-specific rules, plan mode versus direct execution, iterative refinement, CI/CD and headless runs |
| [F4 Prompt Engineering and Structured Output](rules/f4-prompt-engineering.md) | 20% | explicit review criteria, few-shot examples, structured output with tool use and schemas, validation and retry, batch processing, multi-pass review |
| [F2 Tool Design and MCP Integration](rules/f2-tool-design-mcp.md) | 18% | tool descriptions, structured error responses, tool distribution and tool_choice, MCP server configuration, built-in tools (Read, Write, Edit, Bash, Grep, Glob) |
| [F5 Context Management and Reliability](rules/f5-context-reliability.md) | 15% | context window management, escalation and ambiguity, error propagation, codebase exploration, human review and confidence calibration, provenance |

Every Foundations rule also carries an "Exam key vs now" line wherever the exam guide and today's Claude Code or API behave differently, so you can build to the current product and still know what the exam keys.

Also in `rules/`: [vocabulary.md](rules/vocabulary.md) (216 terms), [review-checklist.md](rules/review-checklist.md) (68 checks, one per rule, and the findings format), [sources.md](rules/sources.md).

### Fifteen that decide most questions (Professional)

1. Climb the pattern ladder only when forced: plain call, augmented LLM, workflow, agent, multi-agent.
2. Least privilege means removal. Logging, confirmations and time windows are detective or compensating controls.
3. Login strength does not narrow a scope. Propagate identity, separate credentials, never pass a token through, check every hop.
4. After a data change, suspect retrieval and the index first, then the prompt, then the model.
5. Count the consumers before choosing MCP, a direct call or agent-to-agent. Nobody watching means no streaming and no chat surface.
6. At scale, cache the hot core and discover the long tail.
7. Static content first, then cache it: the one lever that improves latency and cost together.
8. The cheapest technique for the observed failure; the smallest model that reaches the measured bar.
9. Metrics before the build, on tail percentiles, with rubrics and calibrated graders.
10. A prompt change is a production change: suite, A/B, staged rollout, failures minted as regression cases.
11. Enforce before the boundary, in code. The prompt is context, not enforcement.
12. Route human review by consequence and reversibility; measure the override rate.
13. Discovery before design, segmented numbers before promises. A service level has six elements.
14. Decision records carry the alternatives; the handover pack answers how to change safely and how to detect breakage.
15. Guidance is not enforcement; measure the work, not the usage; read the trace before changing anything.

### Ten more from Foundations

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

## An example

You ask: "Our support agent can read tickets, draft replies, issue refunds and delete accounts. Staff only read and draft. We added logging on refunds and deletes. Good enough?"

The skill answers with the rule (D3.1 capability bloat, with D5.1 on control types), the cue ("staff only read and draft"), the call (remove the refund and delete tools from the agent), and why logging does not do it (a detective control records misuse after it happened; the privilege stays wired). Then the paired flip: logging would be the right addition if the role genuinely needed refunds and the requirement were attribution, which it is not.

A Foundations one: "The agent sometimes issues a refund before it has looked the customer up. We added 'always verify the customer first' to the system prompt." The skill answers F1.4: a step that must happen every time, where money is involved, belongs in code (a prerequisite that blocks the refund tool until the lookup returned a verified id, or a PreToolUse hook), because an instruction only makes the right order more likely.

## Where the rules come from

- The domains, weights and task statements are the public exam blueprints (Anthropic, Claude Certified Architect - Professional Exam Guide v1.0 and Foundations Exam Guide v1.0, July 2026): 38 task statements give the D ids, 30 give the F ids, so a rule can be looked up in its guide.
- The calls apply Anthropic's published guidance (Building effective agents, the multi-agent research system write-up, writing tools for agents, advanced tool use, context engineering, contextual retrieval, prompt caching and batch docs, the usage policy) and the Model Context Protocol specification (authorisation, security best practices). Every rule ends with its sources; [rules/sources.md](rules/sources.md) lists them in one place.
- The wording is original. The repo contains no exam questions or answers (Anthropic's certification policy forbids sharing exam content and every candidate signs a non-disclosure agreement) and no third-party course material.
- Anthropic publishes a new guide on 17 November 2026 and changes the exam on 7 December 2026. The principles survive that; the ids may be renumbered, and this repo will follow.

Facts about product behaviour (caching, batch, structured outputs, subagent context) are dated November 2026 and marked where the blueprint's world differs from today's product; see the "Exam key versus current reality" table in the skill.

## Studying for the exam?

The rules double as the study map: one section per task statement, with a "Read more" link per rule. For the method and the registration checklist, see the sibling plugin [cert-coach](https://github.com/mattzimak/claude-cert-coach) and the free guide [How I passed the Claude Certified Architect exam as a non-developer](https://agentmatik.ai/guides/how-i-passed-the-claude-certified-architect-exam-as-a-non-developer).

## About

Built by [Matt Zimak](https://mattzimak.com), who runs an automation agency and passed Claude Certified Architect - Foundations with 851 on 30 September 2026 and sits the Professional exam on 9 November 2026. The rules are the ones he applies to client agents and automations.

Unofficial: not affiliated with, sponsored by or endorsed by Anthropic. Claude and Claude Certified Architect are trademarks of Anthropic, PBC, used here only to describe what the rules refer to. MIT licence.
