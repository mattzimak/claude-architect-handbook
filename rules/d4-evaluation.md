# D4 Evaluation, Testing and Optimization (16% of the blueprint, 6 decisions)

Evaluation is discipline: metrics before the build, one change at a time, evidence before a fix, and a regression case out of every failure. Rule ids follow the official CCAR-P task statements.

## D4.1 Evaluation metrics: decide them before the build, on tail percentiles and rubrics

**Decide:** what "good" means in numbers, before anything is built.
**Cues:** "we will define metrics once we have real data", "average latency", "accuracy", "harmful output rate", "how will we know it works".
**The call:** write the metrics first, from the business requirement, not from what the system happens to achieve. Latency on tail percentiles (p95, p99) and name the latency the user feels (time to first token versus total completion). Safety in both directions: harmful output and over-refusal of legitimate requests. Subjective quality through written rubrics scored by graders; exact match and length measure nothing subjective.
**Tempting wrong calls:**
- Mean latency as the target. Means hide the tail, and the tail is who churns.
- Metrics after launch, calibrated to whatever the system does.
- Safety as harmful-output rate alone: a system that refuses everything scores perfectly.
- Optimising a stand-in number (reply length, judge score, thumbs-up rate) without checking that it still moves with the outcome it stands for. Pushed hard enough, a proxy drifts away from the goal; audit it against the real outcome and drop it when the two part.
**In practice:** "first reply under 2 hours for 95% of B2B enquiries, measured at the webhook", not "faster replies".
**Read more:** Anthropic, Define success criteria (https://docs.claude.com/en/docs/test-and-evaluate/define-success); study lesson https://claudecertificationguide.com/ccar-p/learn/4-evaluation-testing/4-1-defining-evaluation-metrics

## D4.2 Evaluation datasets and test frameworks: cover the real risks, pair each metric with a grader that can score it

**Decide:** what goes in the eval set and how each case is graded.
**Cues:** "our LLM judge", "all human grading", "more test cases", "we pasted the examples into the prompt", "recurring incidents but the suite is green".
**The call:** a labelled set that is representative of production, covers the edge, adversarial and regression populations, is versioned, and is kept out of the prompt (held out). Mixed grading: code checks for exact and schema facts; an LLM judge with a rubric for subjective quality, calibrated against human labels before its scores count; humans for calibration, ambiguous cases and where the stakes demand. Recurring production incidents next to a passing suite mean a missing case population, not a missing model.
**Tempting wrong calls:**
- Trusting a judge nobody has checked against human labels.
- All-human grading as "the rigorous option": less coverage at more cost.
- Eval cases that also sit in the prompt as few-shot examples: passing proves recall, not capability.
- More happy-path cases to fix incidents that live in the edge cases.
- Letting the model that wrote the output also grade it. Anthropic's eval guidance generally uses a different model as the judge.
**In practice:** fifty real tickets with approved answers, kept apart from the two examples in the prompt; an IF node checks the JSON, a second model scores tone against a rubric, a person checks one in twenty.
**Read more:** Anthropic, Develop test cases (https://docs.claude.com/en/docs/test-and-evaluate/develop-tests); study lesson https://claudecertificationguide.com/ccar-p/learn/4-evaluation-testing/4-2-evaluation-datasets-test-frameworks

## D4.3 A/B testing and iteration: one variable, offline suite, then live, then staged rollout

**Decide:** how a change proves itself before everyone gets it.
**Cues:** "we are migrating the model and rewriting the prompt anyway", "the offline suite passed, ship it", "it looks clearly better on ten cases", "we have a rollback plan".
**The call:** change one variable at a time, or nothing can be attributed. Offline regression suite first, then A/B on live traffic against predefined success and guard metrics (safety, cost, latency must not regress), with the sample size decided before the test, then a staged rollout (shadow, canary, widen). The losing variant's failures become regression cases. A prompt change is a production change.
**Tempting wrong calls:**
- Bundling a model migration with a prompt rewrite.
- Treating a green offline suite as licence to ship to everyone.
- Declaring a winner on a handful of cases: LLM variance makes small samples noise.
- A rollback plan instead of staged exposure: everyone is still exposed to an unvalidated change.
**In practice:** half the inbound leads get prompt B for two weeks, reply rate as success, complaint rate as the guard; 5% of traffic on the new workflow version before the rest.
**Read more:** Anthropic, Define success criteria (https://docs.claude.com/en/docs/test-and-evaluate/define-success); study lesson https://claudecertificationguide.com/ccar-p/learn/4-evaluation-testing/4-3-ab-testing-iterative-improvement

## D4.4 Diagnosing failures: follow the correlation, name the stage before the fix

**Decide:** whether a wrong output is a retrieval problem, a prompt problem or a model problem.
**Cues:** "started after the corpus refresh", "the model ignores the format", "inconsistent answers", "temperature zero", "just upgrade the model".
**The call:** evidence before conclusions. Find the correlation the symptom gives you (a refresh, a prompt edit, a traffic shift) and name the stage. Grounding failures (the model was handed bad or missing context) are pipeline fixes; generation failures (the context was right and the model still invented) are prompt-contract fixes: answer only from the text, allow "not in the source", allow null fields. A model upgrade is only right after a stronger-tier test confirms a capability gap. "First place to investigate" is a different question from "best eventual fix".
**Exam key vs now:** Exam: temperature appears as a setting worth adjusting (the guide's published Domain 4 sample lists it among the wrong answers). Now: `temperature`, `top_p` and `top_k` return a 400 at any non-default value on Claude 4.7 and later models, and API version 2026-10-21 removes them for every model; steer behaviour with the prompt (model deprecations docs, checked 9 Nov 2026).
**Tempting wrong calls:**
- Upgrade the model first: it fabricates just as fluently from a broken index and obeys ambiguous instructions more expensively.
- Rewrite the prompt to suppress hallucinations that began with a corpus refresh: patching downstream of the fault.
- Temperature zero as a correctness fix: it is not fully deterministic and fixes none of the failure classes.
- Calling every wrong output "a hallucination" and treating it as one problem.
**In practice:** wrong data into a node versus the node mis-processing good data; the fix goes to a different layer.
**Read more:** Anthropic, Reduce hallucinations (https://docs.claude.com/en/docs/test-and-evaluate/strengthen-guardrails/reduce-hallucinations); study lesson https://claudecertificationguide.com/ccar-p/learn/4-evaluation-testing/4-4-diagnosing-system-issues

## D4.5 Token, latency and cost optimisation: match the lever to the dominant term

**Decide:** which optimisation actually moves the number that matters.
**Cues:** "the bill doubled", "the same 8,000-token policy on every call", "10,000 records overnight", "switch to the small model", "p95 blew up".
**The call:** name the dominant term, then pick the lever that targets it. Repeated static prefix: cache it (cost and time to first token together). Unattended volume: batch it (about half price, results within hours, no waiting user). Quality versus cost: right-size per stage with an escalation cascade, and re-run the evals on the smaller model before shipping it. Output tokens are slower and dearer than input tokens, so trim what the model writes before you trim what it reads.
**Tempting wrong calls:**
- Batch for a user-facing, latency-sensitive flow: the cue for batch is the absence of someone waiting.
- The smallest model as a cost fix with no eval re-run: the saving is measured, the quality loss is not.
- Caching for window overflow, wrong answers or one-off documents: caching reuses a repeated prefix; it does not shrink context, add capacity or change what the model says.
- Changing model when effort is the cheaper dial. On current models effort shapes every output token (text, tool calls and thinking), and Anthropic makes it the main cost and latency control; sweep it against the evals before swapping or adding a model.
**In practice:** cache the 20-page policy, send the customer's question last; run the nightly enrichment as a batch, never the chat reply. Batch and prompt caching discounts stack, so a nightly batch with a long shared prefix should use both; a batch expires if it has not finished within 24 hours and its results stay downloadable for 29 days, so the step that collects them must run inside that window.
**Read more:** Anthropic, Prompt caching (https://docs.claude.com/en/docs/build-with-claude/prompt-caching) and Message Batches (https://docs.claude.com/en/docs/build-with-claude/batch-processing); study lesson https://claudecertificationguide.com/ccar-p/learn/4-evaluation-testing/4-5-token-latency-cost-optimisation

## D4.6 Monitoring in production: uptime does not measure wrongness

**Decide:** what the team watches after launch and what happens when an incident closes.
**Cues:** "the dashboards are green", "we eval before every release", "the ticket is closed", "quality drifted and nobody noticed".
**The call:** continuous scoring of sampled traffic against the D4.1 targets, because drift arrives between releases (corpora refresh, traffic shifts, prompts accumulate edits). Every closed incident mints a regression case so the same failure cannot come back under a new ticket number. Instrumentation (D3.4) is how the signals exist; monitoring is the practice of watching them.
**Tempting wrong calls:**
- Green uptime and mean latency presented as evidence of health.
- Skipping continuous evaluation because the team evals before releases.
- Closing incidents with a fix and no regression case.
- Alerting on every metric. A team paged for everything learns to ignore pages; alert on guard metrics at tail percentiles, with thresholds taken from the measured baseline, and decide on purpose what stays silent.
**In practice:** the classifier that was fine in March and quietly wrong by June because the catalogue changed; nobody re-ran the baseline. Four cheap signals move before quality scores do, and each points at a stage: tokens per request (inputs grew or a prompt edit landed), refusal rate (traffic shifted or a policy line clashes with new inputs), tool-failure rate (an upstream API changed), and input length (a new client or integration arrived).
**Read more:** Anthropic, Effective context engineering (https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents); study lesson https://claudecertificationguide.com/ccar-p/learn/4-evaluation-testing/4-6-monitoring-observability
