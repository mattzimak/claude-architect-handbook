# Changelog

## 0.2.0 - 2026-11-09

The Foundations rule set. 30 decisions keyed to the Claude Certified Architect - Foundations task statements (`rules/f1..f5`: agentic architecture and orchestration, tool design and MCP, Claude Code configuration and workflows, prompt engineering and structured output, context management and reliability), each with an "Exam key vs now" line where the exam guide and today's product differ. The rules skill gained a Foundations decision table, ten more deciding rules and new exam-key-versus-reality rows; the review skill reviews against both levels (`d1-d7`, `f1-f5`) and covers Claude Code setups; `ref.sh` serves `f1` .. `f5`; the vocabulary grew from 85 to 216 terms (83 Foundations terms and 48 Professional terms from the study glossaries) and the checklist from 38 to 68 checks; the Professional rules gained 40 additions from the revised lessons and the glossary, quick reference and exercise pages (idempotent retries, effort, adaptive thinking, cache minimums, contextual retrieval, injection placement, data retention and residency, checkpoints) and 12 new exam-key rows; the router hook and the rule template recognise Foundations topics. README: install steps per surface (terminal, VS Code extension via /plugins, shell).

## 0.1.1 - 2026-11-09

Renamed: repository `claude-architect-handbook` (was `ai-architect-rules`; GitHub redirects the old URL), plugin `architect-handbook`, rules skill `architect-rules`. Named for the skillset rather than the exam; the Foundations rule set is planned as 0.2.0. No rule content changed.

## 0.1.0 - 2026-11-09

First release. 38 decision rules across seven domains (`rules/d1..d7`), the `ai-architect-rules` skill (router, decision table, 15 rules, exam key versus current reality), the `architect-review` skill (ranked findings with rule ids, evidence and the paired flip), an 85-term vocabulary for non-developers, a 38-check review checklist, a UserPromptSubmit hook that fires the rules on architecture prompts, and a path-scoped rule template for `.claude/rules/`.
