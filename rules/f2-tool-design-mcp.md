# F2 Tool Design and MCP Integration (18% of the Architect - Foundations blueprint, 5 decisions)

Every rule here is about what the model sees when it picks a tool or reads a result: the description, the error, the size of its toolbox, and the config that decided which servers exist at all. Builders go wrong by adding machinery (a router, a classifier, a home-made server) where a sharper description, a smaller toolbox or a structured error would have fixed the cause. Rule ids follow the official CCAR-F task statements 2.1 to 2.5.

## F2.1 Tool descriptions: the description is how the model routes, so fix it first

**Decide:** what to change when an agent keeps calling the wrong one of two similar tools.
**Cues:** "it calls the customer lookup for order questions", "both take an id", "one-line descriptions", "add a routing layer".
**The call:** the model picks a tool by reading its description, so a thin or overlapping one is the root cause and rewriting it is the cheapest, biggest fix (the guide's published sample keys it). Say what the tool does, its input format, what it returns, typical requests, its limits and when to use the neighbouring tool instead; rename or split a catch-all tool if two still blur. Then reread the system prompt, because a keyword instruction can pull requests towards one tool whatever the descriptions say.
**Tempting wrong calls:**
- Few-shot routing examples. Tokens on every call, and the vague descriptions stay.
- A keyword classifier in front of the model. Infrastructure that discards the model's own reading.
- Merging the tools first. Far more work than a rewrite.
- New descriptions on an agent with twenty tools. At that size the count is the problem (F2.3).
**In practice:** an AI Agent node whose "Get record" and "Get details" tools have four-word descriptions; name each one's identifier and limits before adding a Switch node.
**Related:** F2.3, F2.4, D3.1
**Read more:** Anthropic, Define tools (https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools); study lesson https://claudecertificationguide.com/learn/2-tool-design-mcp/2-1-tool-schema-design

## F2.2 Structured tool errors: say what failed, whether resending helps, and what to do instead

**Decide:** what a tool returns when it fails, and how that differs from "found nothing".
**Cues:** "Operation failed", "it retried three times, then escalated", "the account does not exist", "over the refund limit".
**The call:** a failure inside the tool returns as a normal result with `isError: true`, a category (transient, validation, business, permission), an `isRetryable` flag and the next step in words. Only transient failures are resent unchanged; validation means fix the input, business means another path or escalation with a customer-safe reason, permission means someone with access. A query that ran and matched nothing is a success with zero results. Subagents retry transient failures locally and pass up the rest with what they tried and partial results.
**Exam key vs now:** Exam: four categories plus `isRetryable` are the pattern. Now (checked 2026-11-09): MCP defines only `content`, `structuredContent` and `isError`, so category and flag are your convention inside `structuredContent`; the 2026-07-28 spec files invalid arguments under execution errors.
**Tempting wrong calls:**
- One generic error string. A timeout and a policy refusal look the same.
- An empty result treated as a failure. Wasted retries, and a correct answer escalated.
- Validation marked retryable. The same input fails the same way.
- A subagent reporting an empty success after a failed search. The coordinator decides blind.
**In practice:** a sub-workflow tool that answers "failed" on every branch; return category, flag and reason, and a zero count when nobody matched.
**Related:** F5.3, D1.2
**Read more:** MCP specification, Tools (https://modelcontextprotocol.io/specification/2026-07-28/server/tools); study lesson https://claudecertificationguide.com/learn/2-tool-design-mcp/2-2-structured-error-responses

## F2.3 Tool distribution and tool_choice: a few tools per role, a scoped shortcut for the frequent case

**Decide:** which agent holds which tools, and whether the model may answer without calling one.
**Cues:** "eighteen tools on one agent", "the writer runs its own searches", "every fact check goes through the coordinator", "it sometimes answers in prose".
**The call:** give each role only the few tools its job needs; an out-of-role tool invites misuse. Count first: look-alikes in a small set need descriptions, different jobs need a split by role, variants of one job need one tool with an operation parameter. Prefer constrained tools to generic ones. For a frequent, simple slice of another role's work, give a narrow scoped tool and keep hard cases on the coordinator (the guide's published sample keys this). `tool_choice`: `auto` normally, `any` when a call is mandatory, a named tool to force a required first step.
**Exam key vs now:** Exam: `any` and forced selection guarantee the call; 4-5 tools versus 18. Now (checked 2026-11-09): Opus 5.5, Sonnet 5.5, Fable 5.1 and Mythos 5.1 return a 400 for both, and the docs route to `auto` plus strict tool use; tool search docs place degradation at 30-50 tools.
**Tempting wrong calls:**
- Every simple lookup via the coordinator. Extra round trips on the commonest request.
- Half the tools moved to a second MCP server. The model still sees one flat list.
- `auto` where output must be structured. The model may reply in text.
**In practice:** a writing agent that also holds web search; swap it for a tool that checks one claim against one collected source.
**Related:** F2.1, F1.3, D3.1, D3.8
**Read more:** Anthropic, Forcing tool use (https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools#forcing-tool-use); study lesson https://claudecertificationguide.com/learn/2-tool-design-mcp/2-3-tool-distribution-choice

## F2.4 MCP integration: shared servers in the repo, secrets as variables, reuse before you build

**Decide:** where an MCP server is configured, how credentials get in, and whether to build one.
**Cues:** "the whole team needs Jira", "just for me while I try it", "paste the token, the repo is private", "we'll write our own GitHub server".
**The call:** team servers go in `.mcp.json` at the repo root, committed, so every clone gets them; personal and trial servers go in `~/.claude.json`. Credentials appear as `${VAR}`, so the file is safe to commit and each person brings their own token. All configured servers' tools are available together. Use maintained servers for standard systems; build only for team-specific logic or internal systems. Describe MCP tools richly or a well-described built-in like Grep wins, and expose catalogues (schemas, issue lists) as resources so no calls go on discovery.
**Exam key vs now:** Exam: project and user levels, every tool loaded at connection, resources seen by the agent directly. Now (checked 2026-11-09): three scopes (`local` default, `project`, `user`); tool search loads only tool names at start; resources are application-driven, attached through `@server:` mentions.
**Tempting wrong calls:**
- A team server in `~/.claude.json`. Nobody else gets it.
- A literal token in `.mcp.json`. It stays in every clone's history.
- A custom Jira or GitHub server. Maintained ones exist.
- A prompt rule, or removing Grep, to force the MCP tool. Descriptions decide.
**In practice:** `${ENV_VAR}` references each machine fills from its own `.env`; an unset one only warns, so check `claude mcp list` before blaming descriptions.
**Related:** F2.1, F3.1, D3.7, D3.2
**Read more:** Claude Code, MCP (https://code.claude.com/docs/en/mcp); study lesson https://claudecertificationguide.com/learn/2-tool-design-mcp/2-4-mcp-server-integration

## F2.5 Built-in tools: Grep for what files say, Glob for what files are called, Edit before a rewrite

**Decide:** which built-in tool finds and changes code, and in what order.
**Cues:** "find every caller", "find the test files", "Edit failed, the text appears three times", "read the whole repo first".
**The call:** Grep searches inside files (callers, messages, imports); Glob matches paths (`**/*.test.tsx`). Build understanding in steps: Grep an entry point, Read what it names, follow imports, Grep again for names a wrapper or re-export adds. Callers plus tests: Grep the function, Glob the sibling test files, Grep the wrapper names. Edit is the default change, touching only matched text, and needs an anchor that occurs once.
**Exam key vs now:** Exam: with no unique anchor, Read the file and Write it back; Grep and Glob are built in. Now (checked 2026-11-09): Claude widens `old_string` or sets `replace_all: true`; on macOS, Linux and WSL, Glob and Grep leave the default set (search runs through Bash) unless `--tools` or `--allowedTools` names them.
**Tempting wrong calls:**
- Glob for callers. A path says nothing about what a file calls.
- Grep for files by name. Workable, but Glob is the purpose-built, keyed tool.
- Reading every file first. The window fills with code the task never needed.
- Read plus Write for every change. A whole file paid for to change one line.
**In practice:** renaming a helper in a Worker repo starts with a search for the name and each re-exported alias.
**Related:** F5.4, F3.4
**Read more:** Claude Code, Tools reference (https://code.claude.com/docs/en/tools-reference); study lesson https://claudecertificationguide.com/learn/2-tool-design-mcp/2-5-built-in-tools
