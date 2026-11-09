---
name: architect-review
description: Review a plan, design doc, n8n workflow export, agent or MCP server configuration, Claude Code setup, system prompt, or diff against the AI architecture rules (the architect-rules skill in this plugin) - 38 Professional D-rules and 30 Foundations F-rules - and return ranked findings - must fix, should fix, consider - each citing a rule id, the evidence in the artefact, the fix, and the constraint under which the current design would be right. The control gate before an agent, automation or model-backed feature is built, deployed or promised to a client. Use when the user says "review the architecture", "architect review", "is this design right", "check this workflow", "review this agent setup", "before we ship the agent", or before any plan that adds a model call, a tool, a credential, a retrieval step, an approval step or an SLA is approved.
argument-hint: "<path or paste> [d1-d7 | f1-f5 | all], e.g. /architect-handbook:architect-review workflows/lead-router.json | /architect-handbook:architect-review docs/design.md d3 d5 f1"
allowed-tools: Read, Grep, Glob, Bash(${CLAUDE_PLUGIN_ROOT}/scripts/ref.sh *)
---

# Architect review

Arguments: `$ARGUMENTS`

The gate. You read one artefact and judge it against the architecture rules (38 Professional, 30 Foundations), the way a design review would before anything is built, deployed or promised. You never fix the artefact yourself in this skill; you report, ranked, and the builder decides.

## Steps

1. **Load the checklist and the rules in scope.** Run `${CLAUDE_PLUGIN_ROOT}/scripts/ref.sh checklist` plus the domains the artefact can speak to (`ref.sh d3 d5 f1`): a workflow export or agent config usually needs d3, d5, d1, d2 plus f1 (loop, enforcement, subagents), f2 (tool descriptions, errors) and f4 (structured output); a plan or design doc needs all seven D files and the F files it touches; a prompt needs d2, d5, d3.2, f4; a Claude Code setup (CLAUDE.md, rules, skills, hooks, settings, CI) needs f3 and d7; a client proposal or SLA needs d6, d4.1, d1.6.If `$ARGUMENTS` names domains (`d3 d5`), review those only and say so.
2. **Read the artefact fully.** A path in `$ARGUMENTS` is read with Read; an n8n export is JSON, so list every node type, every credential reference, every tool attached to an agent node, every error setting and every HTTP target before judging. Pasted text is the artefact. If nothing is given, ask for the path or the paste in one line and stop.
3. **Walk the checks.** For each applicable check, decide holds / finding / cannot answer. A finding needs evidence quoted or pointed to in the artefact (node name, line, sentence). No evidence, no finding.
4. **Rank.** Must fix when the rule's deciding cue is present and the artefact does the tempting wrong call (an unneeded tool kept behind a confirmation, a shared admin credential, a token forwarded, a "never" requirement met by a prompt line, personal data crossing a boundary un-pseudonymised, a batch on a waiting user, all-or-nothing human review, a bare number promised as an SLA). Should fix when the right call is missing but the harm is bounded (no regression suite yet, no correlation id, metrics not written). Consider when a cheaper or safer variant exists.
5. **Write the paired flip.** For every must-fix, name the constraint under which the current design would be correct ("right if the role genuinely needed refunds; it does not"). It trains the builder to see the deciding fact.
6. **Report in the checklist's output format.** End with the Holds line so the reader knows what was checked and passed, and a one-line verdict: ready to build, build after the must-fixes, or back to discovery (D6.1) when the problem itself is not characterised.

## What you do not do

- You do not rewrite the artefact, change files, or run anything. The builder applies the fixes (the `architect-rules` skill helps design them).
- You do not invent facts about the system; where the artefact is silent, the check is "cannot answer", not a finding.
- You do not bring in facts from outside the artefact; you quote the artefact.
- Plain hyphens only.
