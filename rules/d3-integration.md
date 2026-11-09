# D3 Integration (19% of the blueprint, 8 decisions)

The largest domain and the one builders get wrong most often, because every rule here is about a boundary: who is calling, what they can reach, what the model is handed, and which mechanism connects the parts. Rule ids follow the official CCAR-P task statements.

## D3.1 Capability bloat: give the agent only the tools its job needs

**Decide:** which tools an agent is wired with.
**Cues:** "the agent can also...", a tool list longer than the role's task list, "just in case", "the users only ever need to...".
**The call:** start from the role's task list and remove every tool it does not need. Every extra tool costs twice: it widens what can go wrong and it degrades the model's choice among tools. Consolidate what survives into a few well-described tools.
**Tempting wrong calls:**
- Keep the dangerous tool and add logging. That is a detective control; it records misuse after it happened.
- Keep it and add a confirmation step. A compensating control; the privilege is still wired in.
- Tell the model in the system prompt not to use it. An instruction is not an access control.
- Swap in a bigger model "that follows instructions better". Model capability has nothing to do with authorisation scope.
- Wiring every tool the platform offers so the agent "can handle anything". Each definition costs context on every request, tool choice gets worse past roughly 30 to 50 tools, and every extra tool is reachable attack surface. Wire the named tasks' tools and put a large catalogue behind tool search.
**In practice:** an n8n AI Agent node with twelve tools for a job that needs two; a Claude Code agent with every MCP server in the house attached. Delete the node, do not guard it.
**Read more:** Anthropic, Writing tools for agents (https://www.anthropic.com/engineering/writing-tools-for-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-1-capability-bloat

## D3.2 Authentication and authorisation gaps: fix the scope, not the login

**Decide:** where privilege leaks along the chain user -> client -> agent -> tool -> downstream system.
**Cues:** "shared API key", "service account", "the agent can read every record", "forward the user's token", "add MFA", "admin credential on the tool".
**The call:** measure effective privilege at every hop. Narrow the scope, propagate the requesting user's identity into each downstream call so reads and writes are limited to that user, give every hop its own scoped credential, keep secrets in a secrets manager and inject them at the tool boundary. Attribution (who asked, which tool, which resource) is designed into the calls.
**Tempting wrong calls:**
- Stronger login (MFA, SSO) for an over-broad scope. Login decides who gets a session, not what the session can reach.
- Logging every call as the fix for a structural privilege problem. Detective, not preventive.
- Forwarding the user's token downstream because it is simple. Token passthrough is forbidden by the MCP authorisation spec: it breaks audience validation, destroys attribution, bypasses the token's limits and lets a stolen token travel.
- Securing one hop while the gap sits at another. An agent-level scope changes nothing if its tool still uses an admin key.
**In practice:** one instance-wide admin credential used by every workflow is the maximum blast radius and zero attribution. After a leak: rotate first, then move the privileged call behind a backend the client cannot bypass. A local stdio MCP server takes its credentials from the environment and sits outside the MCP authorisation flow, so its reach is whatever that key can touch: give it a narrow key. A remote server starts with the smallest scope set and asks for more through step-up authorisation when an operation needs it, instead of taking everything at connect time.
**Read more:** MCP security best practices (https://modelcontextprotocol.io/specification/2025-06-18/basic/security_best_practices) and authorisation (https://modelcontextprotocol.io/specification/2025-06-18/basic/authorization); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-2-authentication-authorisation-gaps

## D3.3 Accuracy versus latency: meet both named requirements, never trade one away

**Decide:** how to hit a latency target without giving up a quality or safety control the use case calls critical.
**Cues:** "p95 under N seconds", "reranking adds 400 ms", "verification pass", "a parser consumes the output", "nightly job".
**The call:** write the latency budget as a sum of stages, then restructure: route by value or risk so the expensive path runs only where it is justified, cache the stable prefix, run independent calls in parallel, pick a model tier per stage. The justification names both sides: meets the stated p95 while holding the measured error rate.
**Tempting wrong calls:**
- Drop reranking or verification to hit the target. A named requirement was deleted.
- Verify every request when only a subset is high stakes.
- Offer streaming when the consumer is a machine. Streaming changes perceived latency for a person watching tokens; total generation time is unchanged.
- Parallelise a chain where step B needs step A's output. Dependent steps stay serial however they are scheduled.
**In practice:** reply to the webhook at once and do the heavy work in a second workflow; the user feels the first stage, not the whole pipeline.
**Read more:** Anthropic, Reduce latency (https://docs.claude.com/en/docs/test-and-evaluate/strengthen-guardrails/reduce-latency); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-3-accuracy-latency-trade-offs

## D3.4 Observability at scale: instrument quality, not just uptime

**Decide:** what to capture so an incident can be reconstructed and a wrong answer can be seen.
**Cues:** "support says the answers are wrong but the dashboards are green", "re-run it a few times", "store every prompt and response", "five services, one broken request".
**The call:** end-to-end traces with a correlation id across every stage, each span carrying the prompt version, retrieved context, tool calls and decisions. Aggregate everything, sample payloads, keep every detected failure. Add sampled, automated quality scoring; uptime and mean latency cannot see a fabricated answer. Debug from the trace, not from re-runs: non-determinism makes a single re-run uninformative.
**Tempting wrong calls:**
- More uptime and latency alerting for a quality problem.
- Persisting every full prompt and output forever: cost scales with volume and the payloads carry personal data.
- Tracing single calls with no correlation id.
**In practice:** one execution id carried through a parent workflow and its sub-workflows; full data kept for one run in fifty plus every failed run.
**Read more:** Anthropic, Effective context engineering (https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-4-observability-at-scale

## D3.5 RAG pipeline design: after a document change, suspect the index first

**Decide:** how documents are chunked and indexed, and where to look when a retrieval system goes wrong.
**Cues:** "confident but wrong since the refresh", "model and latency unchanged", "chunk size", "overlap", "embedding model changed".
**The call:** chunk by document structure (sections, headings, tables) so each chunk carries one complete idea; keep the embedding model consistent between indexing and query; rebuild the index as a unit after a refresh. Measure retrieval recall and precision on a labelled set separately from answer quality, so a failure isolates to a stage. Confident wrong answers right after a document refresh, with the model unchanged, mean retrieval is handing the model stale or irrelevant chunks: that is the first place to look.
**Tempting wrong calls:**
- Upgrade the model. It generates faithfully from whatever it is handed.
- Retrieve more chunks from a broken index: more stale content, not less.
- Tune chunk size on complaints without retrieval metrics.
- Evaluate only end to end, which cannot say which stage failed.
- Forcing heading-based chunking onto documents that have no reliable structure. Plain text and PDFs without clear headings usually do better with fixed-size chunks and an overlap; structure-aware splitting wins only where the structure is real.
**In practice:** you replaced the price list PDF but the vector store still serves last year's pages. Before embedding, prefix each chunk with a line that places it in its document (which contract, which section); Anthropic measured this cutting failed retrievals by 35%, by 49% with keyword search on the same enriched chunks, and by 67% with re-ranking added.
**Read more:** Anthropic, Contextual retrieval (https://www.anthropic.com/news/contextual-retrieval); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-5-rag-pipeline-design

## D3.6 Retrieval strategy: one strategy per data shape and query pattern

**Decide:** which retrieval method fits each corpus and each kind of question.
**Cues:** "stock levels", "account balances", "part numbers", "no relevant document may be missed", "simple lookup with a tight budget", "three kinds of questions".
**The call:** match the method to the shape. Exact identifiers want keyword search; meaning wants semantic search; most real corpora want hybrid plus re-ranking; a lookup with a known filter wants one filtered query; live operational data (stock, balances, orders) stays in the database behind a query tool and is never embedded. Recall-critical work gets hybrid search plus re-ranking. Combined strategies are usually the right answer when the question presents several query families.
**Tempting wrong calls:**
- Embedding live operational data: stale the moment it is indexed, and the structure that made queries exact is gone.
- Reusing the strategy that worked for the first corpus on every data shape.
- Agentic multi-hop retrieval for a simple, latency-budgeted lookup.
- A precision-first or speed-first option where the requirement says nothing may be missed.
- Building a retrieval pipeline for a small, stable corpus. Below about 200,000 tokens (roughly 500 pages) the whole set fits in one cached prompt, with no index to go stale and no retrieval step to miss.
**In practice:** ask the shop database for today's stock; vector-search the manuals.
**Read more:** Anthropic, Contextual retrieval (https://www.anthropic.com/news/contextual-retrieval); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-6-retrieval-strategy-matching

## D3.7 Integration mechanism: count the consumers before choosing MCP, API or agent-to-agent

**Decide:** MCP server, direct API or CLI call, or delegation to another agent.
**Cues:** "several teams will use this", "one pipeline", "nightly", "the other system makes its own decisions", "needs HTTP".
**The call:** count consumers and surfaces, and ask whether the other side decides anything. Several consumers reusing one capability: MCP (M plus N integrations instead of M times N). One fixed pipeline with one consumer: a direct API or CLI call. A peer that plans its own work: agent-to-agent. Transport is deployment topology inside MCP (stdio for a local subprocess, streamable HTTP for a remote shared server), not a reason to reject MCP. Unattended jobs get no chat surface and no streaming.
**Tempting wrong calls:**
- An MCP server for a bespoke, single-consumer integration nobody will reuse.
- Rejecting MCP because the deployment needs HTTP.
- Wrapping a deterministic operation as an "agent".
- Streaming tokens into a nightly batch job.
**In practice:** one connector that Claude Code, claude.ai and an n8n agent all use, instead of three hand-built integrations; a sub-workflow is a tool, a colleague with a brief is an agent.
**Read more:** MCP specification (https://modelcontextprotocol.io/specification/2025-06-18); Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-7-integration-mechanisms

## D3.8 Progressive discovery versus monolithic context: cache the core, discover the tail

**Decide:** whether to load every tool and document up front or let the agent find them on demand.
**Cues:** "300 tools", "the whole runbook library", "it fits in the window", "the surface must keep growing", "tight SLA".
**The call:** decide by four cues: the ratio of the whole surface to the slice any one request needs, how often each item is used, the latency budget, and how stable the surface is. Keep the few hot tools and documents loaded and cached; put the long tail behind search or discovery. The hybrid is the usual answer. "It fits in the window" is not a cue: recall degrades as the window fills and every request pays for capability it never uses.
**Tempting wrong calls:**
- Load everything because the window is big enough.
- Keep everything in the prompt and rely on a cache breakpoint to make it cheap: caching makes the prefix cheaper, not smaller.
- Cap the tool count permanently when the requirement says the surface must grow.
- Defer everything, including the tools nearly every session uses.
**In practice:** ten always-on tools plus a search over three hundred more, instead of three hundred and ten tools on every call.
**Read more:** Anthropic, Advanced tool use (https://www.anthropic.com/engineering/advanced-tool-use); Agent Skills (https://www.anthropic.com/news/skills); study lesson https://claudecertificationguide.com/ccar-p/learn/3-integration/3-8-progressive-discovery
