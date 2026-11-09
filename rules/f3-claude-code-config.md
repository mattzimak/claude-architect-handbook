# F3 Claude Code Configuration and Workflows (20% of the Architect - Foundations blueprint, 6 decisions)

This domain decides where an instruction lives so the right people and sessions receive it, and how Claude Code behaves when nobody is at the keyboard. The usual mistake is a rule at the wrong level (personal instead of shared, always-on instead of on demand, guidance where enforcement was needed), followed by blaming the model. Several exam keys here lag the product, so each rule gives the keyed answer and today's behaviour side by side. Rule ids follow the official CCAR-F task statements 3.1 to 3.6.

## F3.1 CLAUDE.md hierarchy: team standards in the repo, personal taste at home, hard rules in settings

**Decide:** which CLAUDE.md level an instruction belongs at, and why one person's sessions miss it.
**Cues:** "works for me but not for the new hire", "same repo, same branch", "the file is 600 lines", "which file wins".
**The call:** `~/.claude/CLAUDE.md` is personal and never travels with the repo; `CLAUDE.md` or `.claude/CLAUDE.md` in the repo is the team's; a subdirectory CLAUDE.md covers one package. When a newcomer misses conventions others get, find them in someone's user-level file and move them into the project. Split a big file with `@path` imports per package or topic files in `.claude/rules/`. Files are concatenated, not ranked, so a contradiction may resolve either way; a rule that must hold every run goes in settings permissions or a hook.
**Exam key vs now:** Exam: `/memory` shows which memory files loaded; the directive is called "@import". Now (checked 2026-11-09): `/memory` lists and opens the files, `/context all` shows what loaded under Memory files, and the directive is `@` plus a path, which does not shrink context.
**Tempting wrong calls:**
- "The more specific file wins." The docs describe a load order, not precedence.
- Running `/memory` to load a file. It diagnoses; location decides loading.
- A CLAUDE.md in every folder for one convention. That is a path-scoped rule (F3.3).
- A capitalised "never" as the security control. Still guidance (D7.1).
**In practice:** shared rules in the repo's CLAUDE.md, project hooks that deny the writes that must never happen, personal style in the home folder.
**Related:** F3.3, F3.2, D7.1
**Read more:** Claude Code, Memory (https://code.claude.com/docs/en/memory); study lesson https://claudecertificationguide.com/learn/3-claude-code-config/3-1-claude-md-hierarchy

## F3.2 Skills and slash commands: shared workflows in the repo, noisy ones forked, standards stay in CLAUDE.md

**Decide:** where a reusable command or skill lives, how it is configured, and whether it should be a skill at all.
**Cues:** "everyone who clones should get /review", "my own variant", "the analysis floods the conversation", "keep it read-only", "people forget the ticket number".
**The call:** a team command lives in the repo: `.claude/commands/<name>.md` (the guide's location, keyed by its published sample) or `.claude/skills/<name>/SKILL.md` (canonical now); both create `/name`. Personal ones live under `~/.claude/`, and a personal variant gets its own name so teammates are unaffected. A skill with long exploratory output gets `context: fork`, running in an isolated subagent that returns a summary. Skills hold on-demand procedures; always-on standards stay in CLAUDE.md or `.claude/rules/`.
**Exam key vs now:** Exam: `allowed-tools` restricts the skill's tools; `argument-hint` prompts for missing parameters. Now (checked 2026-11-09): `allowed-tools` pre-approves tools for the invoking turn and restricts nothing (`disallowed-tools` and deny rules restrict); `argument-hint` is an autocomplete hint; a personal skill beats a same-named project one.
**Tempting wrong calls:**
- A team command in `~/.claude/commands/`. It never leaves that laptop.
- A loose `review.md` inside `.claude/skills/`. A skill is a folder with a SKILL.md.
- A step-by-step procedure in CLAUDE.md. Every session pays for it.
**In practice:** skills symlinked from a private repo into `~/.claude/skills/` are personal scope; what a client team must share goes in that project's `.claude/skills/`.
**Related:** F3.1, F3.3, D2.5, D3.8
**Read more:** Claude Code, Skills (https://code.claude.com/docs/en/skills); study lesson https://claudecertificationguide.com/learn/3-claude-code-config/3-2-slash-commands-skills

## F3.3 Path-specific rules: one glob-scoped rule file beats a CLAUDE.md in every folder

**Decide:** where conventions go that apply to one kind of file scattered across the codebase.
**Cues:** "tests sit next to the source in fifty folders", "Terraform rules only matter under infra", "the root file is bloated", "nothing for developers to invoke".
**The call:** write a file in `.claude/rules/` whose YAML frontmatter `paths:` lists glob patterns such as `**/*.test.tsx` or `terraform/**/*`. The rule enters context only when Claude works on a matching file, so it costs nothing elsewhere, and one file covers every directory, new ones included; the guide's published sample keys this. Universal standards stay in root CLAUDE.md, one package's conventions can stay in its own CLAUDE.md, and a procedure run on purpose is a skill.
**Exam key vs now:** Exam: the rule loads when a matching file is edited. Now (checked 2026-11-09): it loads when Claude reads, writes or edits a matching file; `paths` is the only frontmatter field read; a rule without `paths` loads at launch like `.claude/CLAUDE.md`.
**Tempting wrong calls:**
- The conventions copied into each directory's CLAUDE.md. Fifty copies drift apart.
- Everything in root CLAUDE.md. Every session pays for rules it never touches.
- A skill for per-file conventions. Skills are task workflows, rules are standing guidance.
**In practice:** a security rule in `.claude/rules/` scoped to server, auth and config paths loads when Claude opens those files and stays out of a copy-editing session.
**Related:** F3.1, F3.2, D2.4
**Read more:** Claude Code, Path-specific rules (https://code.claude.com/docs/en/memory#path-specific-rules); study lesson https://claudecertificationguide.com/learn/3-claude-code-config/3-3-path-specific-rules

## F3.4 Plan mode versus direct execution: choose by ambiguity, not difficulty

**Decide:** whether Claude investigates and proposes before editing, or makes the change straight away.
**Cues:** "split the monolith", "migrate the logging library across 45 files", "two ways to integrate", "clear stack trace, one function".
**The call:** plan mode when the task carries architectural consequences, several valid approaches or many files that must change alike; Claude reads, proposes and edits nothing until the plan is approved. Direct execution when the fix, its location and the approach are known, however hard the bug. Migrations take both: plan the pattern once, then apply it file by file. Hand verbose discovery to the Explore subagent so the main context keeps only its summary. If the request already states the complexity, plan from the start (the guide's published sample keys this).
**Tempting wrong calls:**
- Direct execution for a multi-file restructure. Dependencies surface mid-change and force rework.
- Plan mode for a one-line fix with a known cause. Overhead with no decision to make.
- Starting direct and switching once trouble appears. The complexity was in the brief.
- Writing "plan first" into the prompt. The mode is switched (Shift+Tab, `--permission-mode plan`, a `/plan` prefix).
**In practice:** plan mode as the approval gate before a schema or public API change, however small, because it is hard to undo.
**Related:** F5.4, F1.6, D1.3
**Read more:** Claude Code, Plan mode (https://code.claude.com/docs/en/permission-modes#analyze-before-you-edit-with-plan-mode); study lesson https://claudecertificationguide.com/learn/3-claude-code-config/3-4-plan-mode-execution

## F3.5 Iterative refinement: match the feedback technique to why the output is off

**Decide:** how to steer Claude Code when the first result is not what you meant.
**Cues:** "it does it differently every time", "lots of edge cases", "I've never built a cache", "these three fixes affect each other", "two unrelated nits".
**The call:** pick by diagnosis. A known transformation that prose conveys inconsistently: two or three concrete before-and-after examples. A complex transformation: tests first (behaviour, edge cases, performance where it matters), then feed back the failures, which say exactly what is wrong. An unfamiliar domain: have Claude question you before building, so the considerations you would miss surface. Interacting fixes go in one message so every constraint is visible together; independent ones go one at a time. A missed edge case gets its own example input and expected output.
**Tempting wrong calls:**
- Rewriting the prose more carefully. Still open to interpretation.
- The interview pattern when you know the exact output. There is nothing for questions to uncover.
- Interacting fixes sent one by one. Each lands on a state the next one changes.
- Unrelated nits batched together. Feedback gets applied in the wrong place.
**In practice:** an AI node formatting dates three ways gets two input-output pairs, not a longer rule paragraph; a build outside your field starts with Claude interviewing you into a spec.
**Related:** F4.2, F4.4, D2.3
**Read more:** Claude Code, Best practices (https://code.claude.com/docs/en/best-practices); study lesson https://claudecertificationguide.com/learn/3-claude-code-config/3-5-iterative-refinement

## F3.6 Claude Code in CI/CD: print mode, schema-checked JSON, and a reviewer that did not write the code

**Decide:** how to run Claude Code unattended so it finishes, emits parseable output and reviews honestly.
**Cues:** "the job hangs waiting for input", "inline PR comments", "the same comments on every push", "generated tests duplicate ours".
**The call:** `claude -p` (`--print`) runs the prompt, prints and exits; without it the job waits for a keyboard (the guide's published sample keys it). Add `--output-format json` with `--json-schema` so findings arrive validated in the envelope's `structured_output` field. Project context reaches the run through CLAUDE.md (testing standards, fixtures, review criteria). Review in a separate invocation from generation, pass previous findings and ask only for new or unresolved ones, and include existing tests when generating more. Blocking checks use real-time calls; the Batch API suits overnight work.
**Tempting wrong calls:**
- An environment variable, an invented flag or stdin redirection to stop the hang. Only `-p` changes the mode.
- The generating session reviewing its own diff. It defends the reasoning it already holds.
- `--system-prompt` to add review rules. It replaces the default prompt, tool guidance included; `--append-system-prompt` adds to it.
- `--allowedTools "Read"` as proof the reviewer cannot write. It pre-approves; `--tools` or `--disallowedTools` restrict.
**In practice:** headless `claude -p` runs with a schema on the output and a second run as reviewer; avoid `--bare`, which skips CLAUDE.md, when the repo's standards must apply.
**Related:** F4.6, F4.5, D7.2
**Read more:** Claude Code, Run Claude Code programmatically (https://code.claude.com/docs/en/headless); study lesson https://claudecertificationguide.com/learn/3-claude-code-config/3-6-cicd-integration
