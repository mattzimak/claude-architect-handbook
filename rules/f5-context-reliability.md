# F5 Context Management and Reliability (15% of the Architect - Foundations blueprint, 6 decisions)

This domain decides what the model has in front of it when it matters, and what the system does when something is missing, wrong or uncertain: facts that survive summarisation, errors that reach the coordinator intact, findings that outlast a long session, review effort spent where accuracy is weakest, and sources that survive synthesis. The usual failure is a quiet loss: a summary that drops the amount, an empty result reported as success, a citation stripped on the way. Rule ids follow the official CCAR-F task statements 5.1 to 5.6.

## F5.1 Conversation context: keep the facts outside anything that gets summarised

**Decide:** what each request carries in a long conversation or a multi-agent hand-off.
**Cues:** "it says 'your recent order' instead of the number", "we summarise older turns", "the lookup returns 40 fields".
**The call:** the API keeps no state, so every call resends a growing history. Summarise the narrative if you must, but lift the hard facts (order numbers, amounts, dates, statuses, promises made) into a case-facts block that rides in every prompt and is never summarised, one entry per issue. Trim tool results to the fields the task uses before they enter the history. In aggregated input, lead with a key-findings summary and put detail under headers; the middle of a long input is where findings get missed. Ask upstream agents for structured facts with dates and sources, not their reasoning.
**Exam key vs now:** Exam: always send the complete history. Now: context editing and server-side compaction clear chosen content by design; blind truncation still loses facts.
**Tempting wrong calls:**
- Tell the summariser to keep every number. Still a probabilistic pass over the facts.
- Keep full tool results "in case".
- A prompt line asking the model to mind the middle. Position is structural.
- A bigger window: dearer, and recall falls as it fills.
**In practice:** a JSON facts object, written by Code nodes, injected into the AI Agent's system message every run beside its chat memory.
**Related:** D2.4, F1.5, F5.6
**Read more:** Anthropic, Effective context engineering for AI agents (https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents); study lesson https://claudecertificationguide.com/learn/5-context-management/5-1-context-window-management

## F5.2 Escalation and ambiguity: escalate on a request, a policy gap or a dead end, never on mood

**Decide:** when the agent hands a case to a person, and what it does when a lookup is ambiguous.
**Cues:** "I want a person", "the customer is furious", "escalate below confidence 7", "three accounts match that name".
**The call:** three valid triggers. An explicit request for a human is honoured in that same reply, with no lookup first. A policy gap (the policy is silent on this request) goes to someone who can grant an exception; a clear policy "no" the agent answers itself. A real dead end, after genuine attempts, goes over with a structured handoff. A frustrated customer with a simple problem gets an acknowledgement and the fix, and is escalated only on asking again. Several matching records mean asking for another identifier. When calibration is off, first add explicit criteria and few-shot escalate-or-resolve examples to the system prompt, as the guide's published sample keys.
**Tempting wrong calls:**
- Escalate on negative sentiment. Anger does not track case difficulty.
- Escalate on self-rated confidence. Often sure on hard cases, unsure on easy ones.
- A classifier on past tickets before the prompt is fixed.
- Pick the newest or busiest of several matches. Wrong account, wrong refund, privacy breach.
**In practice:** a client chatbot prompt lists the three triggers with an example each; a fired trigger posts a structured handoff to the team channel.
**Related:** D5.3, F1.4
**Read more:** Customer support agent (use-case guide) (https://platform.claude.com/docs/en/about-claude/use-case-guides/customer-support-chat); study lesson https://claudecertificationguide.com/learn/5-context-management/5-2-escalation-ambiguity

## F5.3 Error propagation: report what failed, what was tried and what survived

**Decide:** what a failing subagent or tool sends back, and how the coordinator recovers.
**Cues:** "the search timed out", "return an empty list so the run carries on", "one failure kills the job", "search unavailable".
**The call:** retry transient failures locally first (backoff, a fallback source) and pass up only what cannot be fixed there. What goes up is structured, as the guide's published sample on a subagent timeout keys: failure type (transient, validation, business rule, permission), the exact query and target, any partial results, and alternatives worth trying. Keep an access failure (the source was never reached; a retry may help) apart from a valid empty result (the query ran and found nothing; that is the answer). The coordinator then retries, switches source, continues on partial results or escalates, and the report notes which areas are thin because a source was down.
**Tempting wrong calls:**
- Report a timeout as success with no results. The gap turns invisible.
- Abort the whole pipeline on one failure. Finished work is thrown away.
- Retry quietly, then return a bare "unavailable". The coordinator loses the query, the partial data and the options.
- Retry a genuine zero-result query.
**In practice:** a sub-workflow returns `status`, `failureType`, `attempted`, `partial` and `alternatives` instead of an empty array, so the parent workflow can branch.
**Related:** D1.2, F1.2, F5.6
**Read more:** Anthropic, Writing tools for agents (https://www.anthropic.com/engineering/writing-tools-for-agents); study lesson https://claudecertificationguide.com/learn/5-context-management/5-3-error-propagation

## F5.4 Long exploration: write findings down outside the context, delegate the noisy reading

**Decide:** how a long codebase or document exploration keeps hold of what it found and survives interruption.
**Cues:** "it talks about 'typical patterns' instead of the classes it named", "hours into the session", "phase two redid phase one".
**The call:** newer verbose output buries earlier precise findings long before the window is full, so this is attention, not space. From the start, keep a scratchpad file of names, paths and dependency chains and re-read it before later questions. Hand verbose searches to subagents that return summaries, so the main context stays clean; isolation is the point, parallelism a bonus. Between phases, summarise and inject the summary into the next phase's subagents. Run `/compact` early, saying what to keep. For crashes, each agent writes a state manifest to a known path that the coordinator loads and injects on restart.
**Exam key vs now:** Exam: crash recovery comes from manifests. Now: Claude Code keeps subagent transcripts in the session, so resuming the session can resume a subagent with its full history.
**Tempting wrong calls:**
- A larger context window. It fills with the same noise.
- Restart without saving state. The findings go with it.
- Paste the full transcript into each new subagent.
- Save `/compact` for when the window is full.
**In practice:** findings in a scratchpad file, broad searches sent to the Explore subagent, a summary handed to the next session.
**Related:** D2.4, F1.3, F1.7
**Read more:** Explore the context window (https://code.claude.com/docs/en/context-window); study lesson https://claudecertificationguide.com/learn/5-context-management/5-4-codebase-exploration

## F5.5 Human review and calibration: validate per segment, calibrate scores, sample even the confident

**Decide:** which extractions a person checks, which run unreviewed, and how you know that split is safe.
**Cues:** "97% accurate overall", "automate everything above 0.95 confidence", "reviewers work in arrival order", "a new supplier layout".
**The call:** an average hides its segments. Measure accuracy per document type and per field before cutting review; a minority of hard documents (handwritten, scanned, foreign layouts) can fail badly behind a fine headline figure. Have the model emit field-level confidence, then calibrate it against a labelled validation set, because one raw score means different accuracy on different fields. Set thresholds from that calibration. Keep stratified random sampling running on the automated, high-confidence items to measure error rates and catch new failure patterns. Order the review queue by uncertainty, ambiguous or contradictory sources included, not by arrival.
**Tempting wrong calls:**
- Automate on the headline accuracy figure.
- Use raw confidence scores as thresholds.
- Sample only low-confidence items. The automated ones are where an unseen error hides.
- Spread reviewers evenly across all items.
**In practice:** an invoice extraction workflow that writes value and confidence per field, routes by calibrated thresholds, and pulls a weekly random sample per supplier type for a human check.
**Related:** D4.6, D5.3, F5.2
**Read more:** Define success criteria and build evaluations (https://platform.claude.com/docs/en/test-and-evaluate/develop-tests); study lesson https://claudecertificationguide.com/learn/5-context-management/5-5-human-review-calibration

## F5.6 Provenance in synthesis: every claim travels with its source and date, conflicts stay visible

**Decide:** how findings keep their sources through a pipeline, and what happens when sources disagree.
**Cues:** "the final report has no citations", "two sources give different figures", "use the newer number", "average them".
**The call:** attribution dies where text is compressed, most often at synthesis. Subagents return claim-source records (claim, URL, document name, supporting excerpt, publication or collection date), and the synthesis step must keep and merge them into inline citations or a reference list. When credible sources disagree, show both values with source and date and let the reader or coordinator decide; the analysis step records the conflict instead of resolving it. Dates often turn an apparent contradiction into a trend. Keep well-established findings apart from contested ones, and render by content: figures as tables, events as prose, technical findings as lists.
**Tempting wrong calls:**
- Keep the newest, the most authoritative or the average. Information lost, false certainty added.
- Sources left inline in prose, hoping synthesis keeps them.
- Hold every disagreement for a person. Annotation lets the reader judge; a person is for when one figure must be chosen.
- One format for every kind of content.
**In practice:** a research workflow whose search branch outputs rows of `claim`, `url`, `title`, `excerpt`, `date`, and whose report step must cite a row for every sentence.
**Related:** F1.3, F5.1, F5.3
**Read more:** Citations (https://platform.claude.com/docs/en/build-with-claude/citations); study lesson https://claudecertificationguide.com/learn/5-context-management/5-6-information-provenance
