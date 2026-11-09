# D7 Developer Productivity and Operational Enablement (7% of the blueprint, 3 decisions)

The smallest domain and the most predictable: guidance is not enforcement, measure the work not the usage, and read the evidence before changing anything. No rule here depends on a filename. Rule ids follow the official CCAR-P task statements.

## D7.1 Team tooling configuration: guidance is not enforcement, and committed configuration beats a wiki page

**Decide:** where a team rule for a coding agent lives so it actually holds.
**Cues:** "we wrote it in the shared instructions file", "an onboarding page explains the setup", "only seniors may use it", "retype every generated change", "a lower setting should allow what the policy denies".
**The call:** the shared instruction file (CLAUDE.md) shapes what the agent tries to do; that is guidance. Permission rules, hooks and managed policy decide what the client allows; that is enforcement. Anything that must never happen gets the enforced layer. Committed configuration is inherited on clone and reviewed in pull requests; a page depends on every person reproducing it. Restrictive rules combine: a denial at any scope stays in force below it.
**Tempting wrong calls:**
- A prohibition in the instruction file treated as prevention.
- An onboarding page or training session as the answer to divergent setups.
- Restricting the tool to senior engineers, or a human retyping every change: both discard the tool and keep its risks.
- Assuming a permission granted at a lower scope widens what a higher scope forbids.
- One long instruction file holding every rule. It loads in every session, adherence drops as it grows (the docs aim for under 200 lines) and contradictory lines get resolved arbitrarily; scope narrow rules to file paths so they load only with matching files, and move procedures into skills.
**In practice:** the hook that denies a bad write versus the CLAUDE.md sentence that asks nicely; the same idea as D3 "an instruction is not an access control" and D5's control hierarchy, in the developer's own environment.
**Read more:** Claude Code settings and permissions (https://code.claude.com/docs/en/settings), hooks (https://code.claude.com/docs/en/hooks), memory and rules (https://code.claude.com/docs/en/memory); study lesson https://claudecertificationguide.com/ccar-p/learn/7-developer-productivity/7-1-team-tooling-configuration

## D7.2 AI-assisted developer workflows: measure the work, review in a fresh context, package the practice

**Decide:** how to tell whether the tooling worked, what to automate first, and who approves.
**Cues:** "80% adoption", "accept rate", "the team loves it", "let the agent review its own PR", "start with the architecture decisions", "Jan has a great prompt for this".
**The call:** measure the work against a baseline taken before the rollout: cycle time, defect escape rate, review latency. Usage, accept rate and satisfaction count how much and how it felt, not what changed. Whatever produced a change does not review it; review happens in a fresh context or by a different reviewer, and a named human holds merge authority. Automate first where the check is fast and objective; unverifiable work (architecture choices) only feeds the review bottleneck. Package what worked as a shared, versioned command or skill anyone can invoke by name.
**Tempting wrong calls:**
- Adoption, accept rate or a survey reported as the return.
- The producer of a change recording it as reviewed.
- Automation aimed first at work nothing can check cheaply.
- A measured improvement whose procedure lives in one person's memory.
- A turn or spend cap as the safety control for an unattended run. Caps (`--max-turns`, `--max-budget-usd`) limit how much runs; permission rules, `--tools` and `--disallowedTools` limit what can run, and `--allowedTools` only skips the prompt for the tools it names.
**In practice:** a second session reviews the pull request; a person presses merge; the procedure becomes a skill in the repo. Make the check the agent's stop condition rather than a request: a Stop hook that sends Claude back until the tests pass is enforced by the client; a sentence asking it to run the tests is not. Scope a reviewing agent to correctness and the stated requirements and tell it to skip style.
**Read more:** Claude Code best practices (https://code.claude.com/docs/en/best-practices); Agent Skills (https://code.claude.com/docs/en/skills); study lesson https://claudecertificationguide.com/ccar-p/learn/7-developer-productivity/7-2-ai-assisted-developer-workflows

## D7.3 Debugging and operational resolution: evidence before change, containment by blast radius

**Decide:** the first move when an agent misbehaves in production, and what closes the incident.
**Cues:** "rewrite the prompt", "revert everything to be safe", "the agent says it did X", "one clean re-run, so it is fixed", "the on-call has no trace access".
**The call:** correlate symptom onset with the change history and read what the failing runs did (tool calls, outputs, versions) before editing anything; the edit makes the failure unreproducible. The agent's account of its own behaviour is a hypothesis to check against the trace, and under non-determinism one clean run proves nothing. Contain (revert, disable) in proportion to ongoing harm, one change at a time so attribution survives. Close with the fix, a regression case and a runbook update, and make sure the on-call engineer can actually read traces and roll back.
**Tempting wrong calls:**
- Rewriting the prompt or the shared instructions as the first move.
- Reverting several changes at once with no ongoing harm to stop.
- Accepting the agent's self-report as root cause, or clearing a hypothesis on one re-run.
- Closing with a fix and nothing else, or a plan that assumes access nobody granted.
- Counting on session rewind to undo what an agent did. Checkpoints track the agent's own file edits; files changed only by shell commands, most subagent edits and outside changes are not restored, so version control stays the real undo.
**In practice:** read the execution log before you touch the prompt; roll back only the node that is doing damage; add the failing input to the regression folder.
**Read more:** Claude Code hooks (https://code.claude.com/docs/en/hooks) and monitoring (https://code.claude.com/docs/en/monitoring-usage); study lesson https://claudecertificationguide.com/ccar-p/learn/7-developer-productivity/7-3-debugging-and-operational-resolution
