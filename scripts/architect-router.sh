#!/bin/bash
# UserPromptSubmit hook shipped by the architect-handbook plugin (Claude Architect Handbook).
#
# Skill choice is model judgement and many skills compete for it, so this hook routes by NAME when a
# prompt is about an architecture decision: agents, tools on agents, credentials and scopes, MCP, RAG and
# retrieval, evals, human review, guardrails, compliance data flows, model choice, caching and batch,
# SLAs, prompt contracts. The full text fires once per session, a one-line reminder after that
# (markers under ${TMPDIR:-/tmp}/architect-handbook-sessions, pruned after 7 days). It prints nothing
# when the prompt is about something else. Output contract: hookSpecificOutput.additionalContext.

INPUT="$(cat)"
PROMPT="$(printf '%s' "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)"
SID="$(printf '%s' "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)"
[ -z "$PROMPT" ] && exit 0

POS='\b(agents?|sub-?agents?|multi-?agent|orchestrat\w*|ai agent node|tools? (for|on|to) the agent|tool list|attach(ing)? (a |another )?tool|capability bloat|least privilege|service account|credential scope|scoped? (credential|token|key)s?|token pass-?through|identity propagation|confused deputy|mcp( server| client| protocol)?|a2a|agent-to-agent|rag|retrieval|embeddings?|chunk(ing|s)?|vector (store|db|database|search)|re-?rank\w*|hybrid search|guardrails?|human[- ]in[- ]the[- ]loop|hitl|human (review|approval|checks?|sign-?off|oversight)|where (does|should) (the |a )?(human|person|reviewer) sit|approval (step|flow|gate)|approve before|review before|escalat\w*|override rate|evals?|evaluation|eval set|golden set|llm[- ]as[- ]a?[- ]?judge|rubric|a/b test\w*|regression suite|canary|shadow (mode|traffic)|prompt caching|cache(d)? (the )?prefix|batch(ing)? (api|job|process\w*)|message batches|model (choice|selection|tier|routing)|which model|escalation cascade|extended thinking|slas?|slos?|p9[59]|latency budget|time to first token|system prompt|prompt contract|hallucinat\w*|grounding|gdpr|hipaa|fedramp|pii|phi|pseudonymi[sz]\w*|de-?identif\w*|data residency|dpa|processor agreement|architect\w*|design (an? |the )?(agent|workflow|pipeline|automation|system|mcp server|rag)|(new|build|create|plan) (an? |the )?(agent|mcp server|rag pipeline|approval flow)|pattern ladder|routing pattern|prompt chaining|evaluator-?optimi[sz]er|orchestrator-?workers?|decomposition|progressive (discovery|disclosure)|tool search|context (window|rot|engineering|editing)|compaction)\b'

printf '%s' "$PROMPT" | grep -iqE "$POS" || exit 0

DIR="${TMPDIR:-/tmp}/architect-handbook-sessions"
mkdir -p "$DIR" 2>/dev/null
find "$DIR" -type f -mtime +7 -delete 2>/dev/null

if [ -n "$SID" ] && [ -f "$DIR/$SID" ]; then
  CTX='AI ARCHITECT RULES still apply this session: for any decision about an agent, its tools or credentials, MCP, retrieval, evals, human review, guardrails, compliance data flows, model tier, caching or batch, prompts or an SLA, name the rule id (D1-D7) and its deciding cue before answering (skill architect-rules); gate any plan or diff that adds one of those with the architect-review skill before it is built or deployed.'
else
  [ -n "$SID" ] && : > "$DIR/$SID" 2>/dev/null
  CTX='AI ARCHITECT RULES - apply if this turn designs, changes, reviews or explains anything that calls a model or acts for a user: an agent or subagent, the tools or credentials it holds, an MCP server or integration mechanism, a retrieval or RAG step, an eval or A/B, a human approval or escalation step, a guardrail, a data flow with personal or regulated data, a model tier or caching or batch decision, a system prompt, or a promise on accuracy, latency or uptime.
(1) Load the architect-rules skill now unless it already ran this session. Name the rule in play (D1.1-D7.3) and quote the deciding cue from the request before giving the call; name the tempting wrong call it replaces (add logging, add MFA, bigger model, more agents, fine-tune, batch it, enable caching, strengthen the prompt).
(2) Build to the call, not the shortcut: remove unneeded tools instead of guarding them; scope and propagate identity at every hop, never forward a token; suspect retrieval first after a data change; static prefix first and cached; metrics and a held-out set before the build; approve-before-execute only on the irreversible path; pseudonymise before data crosses a boundary; a service level with its six elements on the whole pipeline.
(3) Before a plan or diff that adds any of the above is approved, built or deployed: run the architect-review skill on it (ranked findings with rule ids and evidence) and report its verdict line.
If this turn is not about such a decision, ignore this note.'
fi

jq -n --arg ctx "$CTX" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $ctx}}'
exit 0
