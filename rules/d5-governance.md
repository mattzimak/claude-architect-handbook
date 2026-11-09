# D5 Governance, Safety and Risk Management (14% of the blueprint, 5 decisions)

Governance items prefer the control that removes or gates a risk over the one that watches it, and they test whether an obligation became a design constraint. Rule ids follow the official CCAR-P task statements.

## D5.1 Guardrails and safety controls: the prompt is context, not enforcement

**Decide:** where a safety control lives and which kind of control the requirement needs.
**Cues:** "must never reach a user", "before it is sent", "cannot be undone", "after the fact", "we strengthened the system prompt", "a bigger model would resist injection".
**The call:** read the requirement for the phrase that fixes the surface. A guarantee ("never reaches a user") is met at the output gate, in code outside the model, or by removing the capability. The system prompt is one layer among several (input screening, least privilege on tools, output validation), never the enforcement point. Preventive controls make the bad thing impossible; detective controls find it afterwards; compensating controls reduce harm while the risk stays. When the role never needs a capability, remove it; friction in front of an unnecessary privilege leaves the privilege in place.
**Tempting wrong calls:**
- A stronger prompt forbidding a behaviour the system is still wired to perform.
- A more capable model to stop policy violations or resist prompt injection. Model size is unrelated to authorisation scope.
- Logging or a periodic review against a requirement written as "never".
- A confirmation, approval or alert in front of a tool the role does not need.
- Putting third-party text (inbound emails, web pages, uploaded files, search results) into the system prompt or a plain user message. Anthropic's injection guidance passes it only inside tool results, JSON-encoded where possible, under a system-prompt line saying tool content is data to report, not instructions to follow.
- Appending your own instructions to a tool result. Claude treats tool-result text as untrusted, so the instruction may be ignored or flagged as an injection; send it as a user turn after the tool result.
**In practice:** a validation node after the AI node, not a bold line in the prompt; a deleted tool, not an approval button in front of it.
**Read more:** Anthropic, Mitigate jailbreaks and prompt injection (https://docs.claude.com/en/docs/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks); study lesson https://claudecertificationguide.com/ccar-p/learn/5-governance-safety/5-1-guardrails-and-safety-controls

## D5.2 Risks, limitations and failure modes: register the irreversible actions, rank by consequence

**Decide:** how risk is described for a system that takes actions, not just one that answers.
**Cues:** "accuracy is 97%", "what could go wrong", "a disclaimer on the email", "the human checks it", "rank the risks".
**The call:** one register row per failure mode. For every irreversible action: the control, the owner and the detection signal (how the team would notice). Rank by consequence and detectability, so the silent, irreversible failure sits first, not the frequent loud one. A per-item accuracy figure says nothing about blast radius or detection. A human review step counts as a control only once its override rate has been measured.
**Tempting wrong calls:**
- Accepting an accuracy figure as the risk posture of a system that acts.
- Ordering the register by how often each failure fires.
- A disclaimer or notice on an action that has already left the organisation.
- A review gate with no measured override rate: an assumption on the register, not a control.
- Quoting a per-step accuracy for an agent that chains many steps. Errors compound across steps; the levers are scope, number of steps, reversibility and checkpoints, not a better per-item figure.
**In practice:** the list of "what this automation could break, who notices, who owns it", with the payment and deletion rows at the top.
**Read more:** Anthropic, Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/5-governance-safety/5-2-risks-limitations-failure-modes

## D5.3 Human in the loop: route by consequence and reversibility, give each path its own pattern

**Decide:** where a person sits in the flow, what they see, and what proves the gate works.
**Cues:** "approve everything", "two reviewers can handle 40 a day", "spot check", "undo", "payments", "confidence below 0.7 escalates", "legal or medical advice".
**The call:** five patterns. Approve before execute for irreversible external effects (payments, deletions, outbound messages). Review before release for consequential content a person is accountable for. Triggered escalation for routine volume with uncertain or high-value cases routed to a person, where the trigger is validated like any classifier. Post-hoc sampled audit for high-volume, reversible, low-severity work. Automate with a reversibility guarantee (audit trail, undo, compensating transaction) for low-impact reversible actions. When a request has both a throughput limit and a reversibility split, give each path its own pattern. Reviewers need the trace, the sources, information the model did not have, and time per item; measure their override rate. In high-risk areas (legal, medical, credit, insurance, housing, employment decisions) a qualified person with authority to change the recommendation reviews it, and the person affected is told AI was involved.
**Tempting wrong calls:**
- Human approval for every action: volume turns reviewers into rubber stamps.
- A periodic retrospective review for harm that has already left the organisation.
- A second or more senior reviewer who sees the same draft: two rubber stamps.
- Escalation on a confidence score nobody validated.
- Training reviewers harder to stop rubber-stamping. Automation bias is fixed in the design: what the reviewer sees beyond the model's own inputs, how many items each person gets, and where the gate sits.
**In practice:** refunds wait for approval; status tags run and get spot-checked; availability updates run with an undo. Anthropic's Usage Policy attaches the review and disclosure duties to the recommendation delivered about a specific person. Internal drafting or analysis that is not the final recommendation, applying a fixed rule with no judgement about the individual, and business operations that decide nothing about a person are excluded; a wholly favourable decision such as paying a claim may go ahead without review where the law allows, and a partial approval is not wholly favourable.
**Read more:** Anthropic Usage Policy, high-risk use cases (https://www.anthropic.com/legal/aup); Building effective agents (https://www.anthropic.com/research/building-effective-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/5-governance-safety/5-3-human-in-the-loop-validation

## D5.4 Regulatory compliance as a design constraint: reduce what crosses the boundary, before it crosses

**Decide:** how an obligation (GDPR, HIPAA, FedRAMP) changes the architecture, and how far it reaches.
**Cues:** "patient records to the vendor", "EU customers", "federal agency", "we added encryption and a privacy notice", "the DPA at renewal", "the vendor is FedRAMP authorised".
**The call:** sort the options by what still crosses the boundary afterwards; only one usually changes that. Send only the fields the task needs, pseudonymise or tokenise before they cross and keep the key inside, re-associate locally; an instruction to the model acts too late. Logs, traces, retrieval indexes and evaluation sets are copies of the same regulated data and sit inside the assessment, retention and deletion scope. The processor agreement comes before the first disclosure, with flow-down to subcontractors. One line each: GDPR covers personal data of people in the EU (minimisation, purpose limitation, erasure on request); HIPAA covers US protected health information (de-identify before it leaves the boundary); FedRAMP covers US federal cloud deployments (authorised environments at the required impact level, and the agency's own authorising official still grants the authorisation to operate; a vendor's badge is not the agency's authorisation).
**Tempting wrong calls:**
- A privacy notice, encryption, shorter retention, access limits or consent while the same fields keep crossing.
- Drawing the assessment around the user-facing app while logs and indexes sit outside it.
- Signing the processor agreement at the vendor's next renewal.
- Treating a supplier's FedRAMP status as the agency's authorisation to operate.
- Assuming a zero-data-retention arrangement covers every endpoint. Batch, the Files API and code execution are stateful and outside ZDR; the API does not block them, so using one quietly steps outside the arrangement for that data; content flagged by trust and safety systems can be kept for up to two years under any arrangement.
**In practice:** replace the customer name with a token before the API call and map it back afterwards; sign the vendor contract before the pilot, not after. On the Claude API, where inference runs is a per-request setting with two values, `global` (default) and `us`, and `us` costs 1.1 times standard prices on Claude 4.6 and later; there is no EU-only value, so a client who requires EU-only processing hears that in discovery. Health data needs a HIPAA-ready organisation rather than ZDR; that organisation blocks non-eligible features with a 400 and does not cover Claude Code, so other work runs in a separate organisation.
**Read more:** Anthropic, Privacy and data handling in the Claude Developer Platform (https://docs.claude.com/en/docs/about-claude/data-usage); study lesson https://claudecertificationguide.com/ccar-p/learn/5-governance-safety/5-4-regulatory-compliance

## D5.5 Ethical AI: measure outcomes by cohort, disclose at the moment of use, explain the person's own outcome

**Decide:** how fairness is checked and how people are told and can contest.
**Cues:** "we do not use gender or ethnicity", "the base model is biased", "it is in our policy page", "explain the decision", "tighten the confidence interval".
**The call:** break outcomes down by cohort against a stated fairness criterion justified by the decision at hand; removing the protected field proves nothing because proxies (postcode, name, purchase history) carry it. Framing, decision constraints, remit and monitoring belong to the application, so "the training data" is not a root cause. Disclosure is owed to the person at the moment they use the system, not in a policy page. An explanation is about that person's own outcome, in everyday language, with a way to contest it; a description of the pipeline is not one.
**Tempting wrong calls:**
- Concluding the system is fair because no protected attribute is collected.
- Recording the foundation model's training data as the root cause and documenting it as a limitation.
- A model card, policy page or terms paragraph offered as disclosure.
- Explaining a decision by describing the model or the architecture.
**In practice:** approval rates by district, not a note that says "we do not use gender"; the line on the letter that says the draft was AI-assisted and who to call to challenge it. Traceability is the third transparency duty beside disclosure and explanation: keep which model version, prompt version and retrieved context produced each decision, long enough to answer a challenge months later. Separate from the high-risk rules, every consumer-facing chatbot or agent that talks to outside users must say it is AI, at least at the start of each session or in the interface; it need not name Anthropic or Claude.
**Read more:** Anthropic Usage Policy (https://www.anthropic.com/legal/aup); study lesson https://claudecertificationguide.com/ccar-p/learn/5-governance-safety/5-5-ethical-ai-bias-fairness-transparency
