# D6 Stakeholder Communication and Lifecycle Management (14% of the blueprint, 5 decisions)

These look like soft skills and are not: every right call is a professional behaviour under pressure, measured, segmented and honest, with the decision left to its owner. Four wrong postures recur: capitulation (agreeing to the impossible), evasion (complying silently or building it your own way), obstruction (going over the owner's head first) and theatre (more meetings, metrics and documents). Rule ids follow the official CCAR-P task statements.

## D6.1 Structured discovery: characterise the problem before you shape or price it

**Decide:** what must be known before a design, a demo or a quote exists.
**Cues:** "build a quick demo on sample data", "what will it cost", "improve the customer experience", "we will sort out data access in design".
**The call:** discovery establishes the baseline, the cost of a wrong answer, who owns the decision, and the facts about the data (access, quality, lawful basis). Success criteria name a metric, a threshold and a population. A price or a date comes from a priced discovery phase, not from the stated request. An honest refusal can be the right answer.
**Tempting wrong calls:**
- A clickable demo before the problem is characterised: the demo becomes the requirement.
- A price or delivery date from the request as stated.
- Deferring data quality, access or lawful basis to the design phase.
- Accepting a criterion phrased as a direction ("improve the experience").
**In practice:** the first paid workshop before any build quote; "first reply under 2 hours for 95% of B2B enquiries", not "faster replies".
**Read more:** Anthropic, Define success criteria (https://docs.claude.com/en/docs/test-and-evaluate/define-success); study lesson https://claudecertificationguide.com/ccar-p/learn/6-stakeholder-lifecycle/6-1-structured-discovery

## D6.2 Communicating decisions and trade-offs: present the measured trade-off, leave the decision with its owner

**Decide:** what to do when you hold evidence against a decision, and how to answer "how accurate will it be".
**Cues:** "the sponsor wants it anyway", "I will just build it my way", "escalate to the CTO", "how accurate will it be".
**The call:** put the measured trade-off and a recommendation in front of the accountable owner and leave the decision there. Record the decision, the evidence and the condition that would reopen it, then build what was decided. Escalate last, and only where the owner's authority does not cover the consequence. Accuracy is a range on a defined population plus the measurement that would narrow it, never a single confident number.
**Tempting wrong calls:**
- Implementing a decision you hold evidence against, without comment.
- Building it your way quietly after losing the argument.
- Going to the owner's superior before the trade-off was put to the owner.
- Answering "how accurate" with one point estimate.
**In practice:** the one-page note: option A, option B, what we measured, what we recommend, your call.
**Read more:** official CCAR-P Exam Guide role description (collaborating with cross-functional stakeholders, communicating architectural decisions); study lesson https://claudecertificationguide.com/ccar-p/learn/6-stakeholder-lifecycle/6-2-communicating-decisions-trade-offs

## D6.3 Expectation alignment and service levels: six elements, the whole pipeline, visible narrowing only

**Decide:** what a commitment on latency, availability or accuracy must contain.
**Cues:** "under 5 seconds", "we will promise 99.9%", "drop the price lookup to make it faster", "exclude the hard cases and the number works".
**The call:** a service level has six elements: the metric, the percentile, the measurement point (where the clock starts and stops), the window, the population, and the breach behaviour. Commit on the measured envelope of the whole pipeline including human review, and never above the platform underneath (a best-effort tier cannot back a hard uptime promise). Meet a latency ask by showing the decomposition and improving perceived responsiveness where a person waits (streaming, progressive disclosure, async with notification), never by deleting a control. Narrow the population only visibly, with the excluded segment given its own target, owner and plan.
**Tempting wrong calls:**
- A bare number in a schedule as the service level.
- Meeting a latency target by dropping a retrieval or verification stage.
- Streaming or partial results where the consumer is a pipeline.
- Quietly narrowing the population until the headline number is true.
**In practice:** "p95 under 8 s measured at the webhook, over a calendar month, for car quotes; fleet quotes have their own target and owner".
**Read more:** Anthropic, Reduce latency (https://docs.claude.com/en/docs/test-and-evaluate/strengthen-guardrails/reduce-latency); study lesson https://claudecertificationguide.com/ccar-p/learn/6-stakeholder-lifecycle/6-3-expectation-alignment-and-slas

## D6.4 Documentation and implementation guidance: the pack answers how to change safely and how to detect breakage

**Decide:** which artefacts a handover needs, and which are theatre.
**Cues:** "we delivered 40 documents", "here is the architecture diagram", "a recorded walkthrough", "it is all in Confluence" (which the team does not use).
**The call:** two questions decide the pack: how does someone change the system safely, and how do they detect breakage? Decision records with the options weighed, the consequences accepted and the condition for revisiting each choice. The evaluation baseline: the suite, its data, the numbers at handover and how to re-run and compare. Operational runbooks. Kept beside the code, versioned with it, changed in the review that changes the behaviour.
**Tempting wrong calls:**
- Page count as evidence of handover.
- A complete component and data-flow view with no record of why anything was chosen.
- A recording, a prompt archive or a list of ideas offered as the critical artefact.
- A thorough pack in a tool the inheriting team does not open.
**In practice:** the decision entries in the worklog and the runbook folder next to the workflow JSON, not a slide deck.
**Read more:** architecture decision records and runbooks are long-standing industry practice, not Anthropic products; study lesson https://claudecertificationguide.com/ccar-p/learn/6-stakeholder-lifecycle/6-4-documentation-and-implementation-guidance

## D6.5 Lifecycle phases: each phase produces what the next needs, and discovery can be reopened

**Decide:** what must be true before ownership transfers, and what a deprecation or a quiet system demands.
**Cues:** "no complaints, so it is fine", "the model is being retired, tell procurement", "we edit the prompt after each complaint", "production contradicts the discovery assumption but the plan says continue".
**The call:** discovery, design, build, handoff, monitoring, iteration, each producing what the next needs to begin honestly. Re-run the baseline after any corpus or model change; a quiet system with a changed corpus is not a proven one. A model deprecation is architectural work (re-validate against the baseline on the replacement), not vendor management. Iteration means each edit runs against the regression suite and the baseline before shipping. When production evidence contradicts a discovery assumption, go back to discovery; carrying on because the plan says so meets the date and misses the outcome.
**Tempting wrong calls:**
- Reading a complaint-free system as healthy.
- Handing the deprecation to the commercial owner.
- Prompt edits in response to last week's complaints, called iteration.
- Building on against evidence that has already contradicted the plan.
**In practice:** the model retirement email is a re-test job, not a procurement job.
**Read more:** Anthropic, Model deprecations (https://docs.claude.com/en/docs/about-claude/model-deprecations); study lesson https://claudecertificationguide.com/ccar-p/learn/6-stakeholder-lifecycle/6-5-lifecycle-phases
