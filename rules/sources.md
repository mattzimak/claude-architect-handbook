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

## Foundations: the blueprint and the pages the F rules cite

- Anthropic, Claude Certified Architect - Foundations, Exam Guide v1.0 (July 2026): five domains and their weights (D1 Agentic Architecture and Orchestration 27, D2 Tool Design and MCP Integration 18, D3 Claude Code Configuration and Workflows 20, D4 Prompt Engineering and Structured Output 20, D5 Context Management and Reliability 15), the six scenarios, the 30 task statements that give the F rules their ids, and twelve published sample items with rationales. The F rules reference those samples by lesson in their own words.
- Study layer that set the emphasis (not reproduced): claudecertificationguide.com/learn, 30 lessons with glossary, quick reference and exercise pages, snapshot 9 November 2026.

- https://platform.claude.com/docs/en/build-with-claude/handling-stop-reasons
- https://code.claude.com/docs/en/agent-sdk/subagents
- https://code.claude.com/docs/en/agent-sdk/hooks
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices#chain-complex-prompts
- https://code.claude.com/docs/en/agent-sdk/sessions
- https://platform.claude.com/docs/en/about-claude/use-case-guides/customer-support-chat
- https://code.claude.com/docs/en/context-window
- https://platform.claude.com/docs/en/test-and-evaluate/develop-tests
- https://platform.claude.com/docs/en/build-with-claude/citations
- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/cli-reference
- https://code.claude.com/docs/en/hooks
- https://platform.claude.com/docs/en/build-with-claude/context-editing
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview
- https://anthropic-partners.skilljar.com/page/partner-certifications
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools#forcing-tool-use
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/strict-tool-use
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-search-tool
- https://platform.claude.com/docs/en/build-with-claude/structured-outputs
- https://modelcontextprotocol.io/specification/2026-07-28/server/tools
- https://modelcontextprotocol.io/specification/2026-07-28/server/resources
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/tools-reference
- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/memory#path-specific-rules
- https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/commands
- https://code.claude.com/docs/en/permission-modes#analyze-before-you-edit-with-plan-mode
- https://code.claude.com/docs/en/best-practices
- https://code.claude.com/docs/en/headless
- https://platform.claude.com/docs/en/build-with-claude/batch-processing
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/server-tools

## Professional additions, 9 November 2026: the pages behind the patched rules and the exam-key rows

Checked with an HTTP 200 on 9 November 2026. They back the additions made after comparing the revised study lessons and the per-domain glossary, quick reference and exercise pages with the rules (idempotent retries, effort, adaptive thinking, sampling parameters, cache minimums, compaction, tool search, prompt injection placement, MCP revision 2026-07-28, data retention and residency, service tiers, Usage Policy, checkpoints).

- https://claude.com/blog/four-role-based-claude-certifications
- https://code.claude.com/docs/en/agent-sdk/python
- https://code.claude.com/docs/en/agent-sdk/secure-deployment
- https://code.claude.com/docs/en/checkpointing
- https://code.claude.com/docs/en/code-review
- https://code.claude.com/docs/en/discover-plugins
- https://code.claude.com/docs/en/github-actions
- https://code.claude.com/docs/en/monitoring-usage
- https://code.claude.com/docs/en/plugins
- https://code.claude.com/docs/en/plugins/manifest-reference
- https://platform.claude.com/docs/en/about-claude/model-deprecations
- https://platform.claude.com/docs/en/about-claude/models/overview
- https://platform.claude.com/docs/en/about-claude/pricing
- https://platform.claude.com/docs/en/agents-and-tools/mcp-connector
- https://platform.claude.com/docs/en/agents-and-tools/tool-use/handle-tool-calls
- https://platform.claude.com/docs/en/api/migration-2026-10-21
- https://platform.claude.com/docs/en/api/service-tiers
- https://platform.claude.com/docs/en/build-with-claude/compaction
- https://platform.claude.com/docs/en/build-with-claude/context-windows
- https://platform.claude.com/docs/en/build-with-claude/effort
- https://platform.claude.com/docs/en/build-with-claude/extended-thinking
- https://platform.claude.com/docs/en/build-with-claude/prompt-caching
- https://platform.claude.com/docs/en/build-with-claude/thinking
- https://platform.claude.com/docs/en/manage-claude/api-and-data-retention
- https://platform.claude.com/docs/en/manage-claude/data-residency
- https://platform.claude.com/docs/en/manage-claude/usage-cost-api
- https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks
- https://www.anthropic.com/research/statistical-approach-to-model-evals
- https://academy.claude.com/courses
- https://academy.claude.com/courses/claude-code-101
- https://academy.claude.com/courses/claude-code-in-action
- https://anthropic-partners.skilljar.com/claude-certified-architect-foundations-certification
- https://anthropic-partners.skilljar.com/claude-certified-associate-foundations-certification
- https://anthropic-partners.skilljar.com/claude-certified-developer-foundations-certification
- https://anthropic-partners.skilljar.com/page/certification-eligibility
- https://anthropic-partners.skilljar.com/page/faq-certifications
- https://anthropic-partners.skilljar.com/page/policies-certifications
- https://anthropic-partners.skilljar.com/path/partner-badge-claude-code
- https://everpath-course-content.s3-accelerate.amazonaws.com/instructor%2F6nizmqk8tpzpfjvt6qmmav7rh%2Fpublic%2F1783542750%2FClaude+Certified+Architect+%E2%80%93+Foundations+Exam+Guide.pdf
- https://everpath-course-content.s3-accelerate.amazonaws.com/instructor%2F6nizmqk8tpzpfjvt6qmmav7rh%2Fpublic%2F1783542810%2FClaude+Certified+Architect+%E2%80%93+Professional+Exam+Guide.pdf
- https://everpath-course-content.s3-accelerate.amazonaws.com/instructor%2F6nizmqk8tpzpfjvt6qmmav7rh%2Fpublic%2F1783542847%2FClaude+Certified+Associate+%E2%80%93+Foundations+Exam+Guide.pdf
- https://everpath-course-content.s3-accelerate.amazonaws.com/instructor%2F6nizmqk8tpzpfjvt6qmmav7rh%2Fpublic%2F1783542875%2FClaude+Certified+Developer+%E2%80%93+Foundations+Exam+Guide.pdf
- https://www.pearsonvue.com/us/en/anthropic.html
- https://modelcontextprotocol.io/docs/learn/architecture
- https://modelcontextprotocol.io/specification/2026-07-28/basic/authorization
- https://modelcontextprotocol.io/specification/2026-07-28/basic/transports
- https://modelcontextprotocol.io/specification/latest
- https://www.fedramp.gov/2026/reference/minimum-assessment-scope

## Study material that shaped the emphasis (not reproduced)

- The lesson site claudecertificationguide.com/ccar-p (one lesson per task statement; the "Read more" links in each rule point there as further reading).
- Matthew Purcell's CCAR-P practice set, second edition (3 November 2026, CC BY-NC 4.0), for the item formats.
- Amey Thakur's CLAUDE-CERTIFICATIONS repository, for the one-page cheat sheet structure.
- Reports from candidates who sat the exam in October and November 2026 (LinkedIn and Reddit), for which decisions surprise builders.

## Not in scope

Exam questions or answers (Anthropic's Certification Exam Policy forbids distributing exam content, and every candidate accepts a non-disclosure agreement), cloud-vendor specifics (Bedrock, Vertex), model internals, billing mechanics, exact current model names.
