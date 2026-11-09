# Claude Architect Handbook

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) ![Plugin 0.1.1](https://img.shields.io/badge/plugin-0.1.1-black) ![38 rules](https://img.shields.io/badge/rules-38-2ea043) ![Unofficial](https://img.shields.io/badge/unofficial-not%20affiliated%20with%20Anthropic-lightgrey)

The judgement an architect applies when building with Claude, as a Claude Code plugin that fires while you build. 38 decisions about agents, tools, credentials, MCP, retrieval, evals, human review, guardrails, compliance data, model tiers, caching, SLAs and team setup, keyed to the public Claude Certified Architect blueprint (Professional level now; the Foundations set, on Claude Code mechanics, is next). Each rule names the cue in a request that makes it the live question, the right call, and the tempting wrong call most builders reach for first.

It is written for people who build with automations (n8n, Workers, pipelines) and coding agents, with or without an engineering background. The 85-term vocabulary translates every engineering word into the thing it corresponds to in automation or client work.

## What it does

- **Answers design questions by rule.** Ask "should this be an agent", "which model", "do we need MCP", "where does the human sit", "how do we measure it". Claude names the rule (for example D3.2), quotes the cue from your request, gives the call, and names the shortcut it replaces (add logging, add MFA, bigger model, more agents, fine-tune, batch it, enable caching, strengthen the prompt).
- **Gates plans and workflows.** `/architect-handbook:architect-review <path>` reads a plan, an n8n export, an agent or MCP config, a system prompt or a diff and returns ranked findings (must fix, should fix, consider), each with the rule id, the evidence quoted from the artefact, the fix, and the constraint under which your current design would have been right.
- **Fires while you build.** A prompt hook recognises architecture decisions in what you type and reminds Claude to apply the rules, once in full per session and then in one line. A rule template does the same when Claude touches an agent, MCP, prompt, workflow or eval file.
- **Explains the words.** `vocab p95`, `vocab confused deputy`, `vocab token passthrough`: plain meaning, the "in your world" line, and the rules it serves.

## Install

In Claude Code:

```
/plugin marketplace add mattzimak/claude-architect-handbook
/plugin install architect-handbook@mattzimak-architect
```

Then:

```
/architect-handbook:architect-rules should my refund flow be an agent or a workflow?
/architect-handbook:architect-review workflows/lead-router.json
```

From a terminal: `claude plugin marketplace add mattzimak/claude-architect-handbook`, then `claude plugin install architect-handbook@mattzimak-architect`. If the short form fails, add the marketplace by its URL: `https://github.com/mattzimak/claude-architect-handbook.git`.

Optional, for the file trigger: copy [templates/agent-architecture.md](templates/agent-architecture.md) to `.claude/rules/agent-architecture.md` in your project (or `~/.claude/rules/` for every project). Plugins cannot install rules, so this one step is yours.

You can also just talk. "Is this design right", "review the architecture", "which search for stock levels" load the right skill.

## The rules

One file per domain under [rules/](rules/), one section per decision. Weights are the blueprint's.

| Domain | Weight | Decisions |
|---|---|---|
| [D3 Integration](rules/d3-integration.md) | 19% | capability bloat, authentication and authorisation gaps, accuracy versus latency, observability, RAG pipeline design, retrieval strategy, integration mechanism (MCP, API, agent-to-agent), progressive discovery |
| [D1 Solution Design](rules/d1-solution-design.md) | 17% | translating the business problem, the six stages of an end-to-end architecture, pattern selection, multi-agent systems, decomposition, business value pillars |
| [D4 Evaluation](rules/d4-evaluation.md) | 16% | metrics, eval sets and graders, A/B and rollout, diagnosing failures, token and cost optimisation, monitoring |
| [D5 Governance](rules/d5-governance.md) | 14% | guardrails, risk registers, human in the loop, compliance as a design constraint (GDPR, HIPAA, FedRAMP), fairness and disclosure |
| [D6 Stakeholders and lifecycle](rules/d6-stakeholders.md) | 14% | discovery, communicating trade-offs, service levels, documentation, lifecycle and deprecation |
| [D2 Models and prompting](rules/d2-models-prompting.md) | 13% | model tier, system prompts and guardrails, prompting techniques, context window, prompt reuse and caching |
| [D7 Developer productivity](rules/d7-developer-productivity.md) | 7% | team tooling (guidance versus enforcement), measuring AI-assisted work, debugging agent incidents |

Also in `rules/`: [vocabulary.md](rules/vocabulary.md) (85 terms), [review-checklist.md](rules/review-checklist.md) (the 38 checks and the findings format), [sources.md](rules/sources.md).

### Fifteen that decide most questions

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

## An example

You ask: "Our support agent can read tickets, draft replies, issue refunds and delete accounts. Staff only read and draft. We added logging on refunds and deletes. Good enough?"

The skill answers with the rule (D3.1 capability bloat, with D5.1 on control types), the cue ("staff only read and draft"), the call (remove the refund and delete tools from the agent), and why logging does not do it (a detective control records misuse after it happened; the privilege stays wired). Then the paired flip: logging would be the right addition if the role genuinely needed refunds and the requirement were attribution, which it is not.

## Where the rules come from

- The domains, weights and 38 task statements are the public exam blueprint (Anthropic, Claude Certified Architect - Professional Exam Guide v1.0, July 2026). The ids in this repo follow it, so a rule can be looked up in the guide.
- The calls apply Anthropic's published guidance (Building effective agents, the multi-agent research system write-up, writing tools for agents, advanced tool use, context engineering, contextual retrieval, prompt caching and batch docs, the usage policy) and the Model Context Protocol specification (authorisation, security best practices). Every rule ends with its sources; [rules/sources.md](rules/sources.md) lists them in one place.
- The wording is original. The repo contains no exam questions or answers (Anthropic's certification policy forbids sharing exam content and every candidate signs a non-disclosure agreement) and no third-party course material.
- Anthropic publishes a new guide on 17 November 2026 and changes the exam on 7 December 2026. The principles survive that; the ids may be renumbered, and this repo will follow.

Facts about product behaviour (caching, batch, structured outputs, subagent context) are dated November 2026 and marked where the blueprint's world differs from today's product; see the "Exam key versus current reality" table in the skill.

## Studying for the exam?

The rules double as the study map: one section per task statement, with a "Read more" link per rule. For the method and the registration checklist, see the sibling plugin [cert-coach](https://github.com/mattzimak/claude-cert-coach) and the free guide [How I passed the Claude Certified Architect exam as a non-developer](https://agentmatik.ai/guides/how-i-passed-the-claude-certified-architect-exam-as-a-non-developer).

## About

Built by [Matt Zimak](https://mattzimak.com), who runs an automation agency and passed Claude Certified Architect - Foundations with 851 on 30 September 2026 and sits the Professional exam on 9 November 2026. The rules are the ones he applies to client agents and automations.

Unofficial: not affiliated with, sponsored by or endorsed by Anthropic. Claude and Claude Certified Architect are trademarks of Anthropic, PBC, used here only to describe what the rules refer to. MIT licence.
