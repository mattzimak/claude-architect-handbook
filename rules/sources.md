# Sources

Every rule in this skill traces to one of these public sources. Nothing here reproduces exam content, course material or a third party's text; the rules are original wording.

## The blueprint

- Anthropic, Claude Certified Architect - Professional, Exam Guide v1.0 (July 2026): the seven domains, their weights (D3 Integration 19, D1 Solution Design 17, D4 Evaluation 16, D5 Governance 14, D6 Stakeholder and Lifecycle 14, D2 Models and Prompting 13, D7 Developer Productivity 7), the 38 task statements that give the rules their ids, and three published sample items with rationales (least privilege is removal; static content first plus prompt caching; confident-wrong after a document refresh points at retrieval). Download from the exam page: https://anthropic-partners.skilljar.com/claude-certified-architect-professional-certification. Anthropic publishes a new guide on 17 November 2026 and the exam content changes on 7 December 2026; the rules are principles and survive that, the ids may be renumbered.

## Anthropic guidance the rules apply

- Building effective agents: https://www.anthropic.com/research/building-effective-agents
- How we built our multi-agent research system: https://www.anthropic.com/engineering/multi-agent-research-system
- Writing tools for agents: https://www.anthropic.com/engineering/writing-tools-for-agents
- Advanced tool use (tool search, programmatic tool calling): https://www.anthropic.com/engineering/advanced-tool-use
- Effective context engineering for AI agents: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Contextual retrieval: https://www.anthropic.com/news/contextual-retrieval
- Agent Skills: https://www.anthropic.com/news/skills
- Usage Policy (high-risk use cases, disclosure): https://www.anthropic.com/legal/aup
- Claude Developer Platform docs: prompt caching, Message Batches, structured outputs, extended thinking, context editing, system prompts, prompt engineering, define success criteria, develop test cases, reduce hallucinations, reduce latency, mitigate jailbreaks, choosing a model, model deprecations, data usage: https://docs.claude.com
- Claude Code docs: settings and permissions, hooks, memory and rules, skills, best practices, monitoring: https://code.claude.com/docs

## Protocol specifications

- Model Context Protocol, specification 2025-06-18: authorization (https://modelcontextprotocol.io/specification/2025-06-18/basic/authorization) and security best practices, including the token passthrough and confused deputy sections (https://modelcontextprotocol.io/specification/2025-06-18/basic/security_best_practices)

## Study material that shaped the emphasis (not reproduced)

- The lesson site claudecertificationguide.com/ccar-p (one lesson per task statement; the "Read more" links in each rule point there as further reading).
- Matthew Purcell's CCAR-P practice set, second edition (3 November 2026, CC BY-NC 4.0), for the item formats.
- Amey Thakur's CLAUDE-CERTIFICATIONS repository, for the one-page cheat sheet structure.
- Reports from candidates who sat the exam in October and November 2026 (LinkedIn and Reddit), for which decisions surprise builders.

## Not in scope

Exam questions or answers (Anthropic's Certification Exam Policy forbids distributing exam content, and every candidate accepts a non-disclosure agreement), cloud-vendor specifics (Bedrock, Vertex), model internals, billing mechanics, exact current model names.
