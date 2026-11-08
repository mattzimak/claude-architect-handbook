---
paths:
  - "**/agents/**"
  - ".claude/agents/**"
  - "**/*-agent.*"
  - "**/*_agent.*"
  - "**/mcp/**"
  - "**/mcp-*/**"
  - "**/*-mcp*"
  - "**/prompts/**"
  - "**/*system-prompt*"
  - "**/*.prompt.*"
  - "**/workflows/*.json"
  - "**/evals/**"
  - "**/eval/**"
  - "**/retrieval/**"
  - "**/rag/**"
  - "**/guardrails/**"
  - "routines/*.md"
---

# You are touching a file that embodies an AI architecture decision

An agent or subagent definition, an MCP server, a prompt, an n8n workflow export, an eval, a retrieval step, a guardrail, or a cloud routine spec. The 38 architecture rules apply here even when the prompt used no keyword. Your NEXT tool call is `Skill("ai-architect-rules")` unless it already ran in this session, then answer these before you change the file:

- **Tools (D3.1):** does every tool this agent or workflow holds appear in its job's task list? Remove what it never needs; do not guard it with logging, a confirmation or a prompt line.
- **Identity (D3.2):** at every hop, who does the downstream system think is calling and what can that identity reach? No shared or admin credential at a tool boundary, no token forwarded, no secret in a prompt, the requesting user's identity propagated.
- **Output (D1.2, D2.2):** is model output validated in code (schema plus business rules) with a designed failure path, never piped straight downstream, never an empty result on error?
- **Retrieval (D3.5, D3.6):** chunked by structure, one embedding model, re-indexed as a unit after a refresh, live operational data behind a query tool rather than embedded?
- **Human review (D5.3):** approve before execute only on the irreversible path; sample or undo on the reversible one; the escalation trigger validated; the reviewer given the trace.
- **Evidence (D4.2, D4.3, D7.3):** a regression case exists for the behaviour you are changing; a prompt change is a production change (suite, then A/B, then staged rollout); if this is an incident, read the trace before editing.
- **Boundary (D5.4):** if personal or regulated data reaches a model or a vendor here, only the needed fields cross and they are pseudonymised first; logs and indexes are in scope.

Before the change is approved, built or deployed: `Skill("architect-review")` on the plan or the diff, and report its verdict line. This is the file-access complement to the prompt hook the plugin ships (hooks/hooks.json). Copy this file to `.claude/rules/agent-architecture.md` in your project (or `~/.claude/rules/` for every project); plugins cannot install rules for you.
