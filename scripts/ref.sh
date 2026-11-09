#!/bin/sh
# Print this plugin's rule files by short name, for example:
#   ref.sh d3 d5          ref.sh f1 f4          ref.sh checklist          ref.sh vocab
# The skills call it through the Bash tool (allowed by their frontmatter), so the rules load
# without a file-read permission prompt. It only reads files inside the plugin's own rules/ folder.
dir="$(cd "$(dirname "$0")/../rules" && pwd)" || exit 1
for name in "$@"; do
  case "$name" in
    d1) file="d1-solution-design.md" ;;
    d2) file="d2-models-prompting.md" ;;
    d3) file="d3-integration.md" ;;
    d4) file="d4-evaluation.md" ;;
    d5) file="d5-governance.md" ;;
    d6) file="d6-stakeholders.md" ;;
    d7) file="d7-developer-productivity.md" ;;
    f1) file="f1-agentic-architecture.md" ;;
    f2) file="f2-tool-design-mcp.md" ;;
    f3) file="f3-claude-code-config.md" ;;
    f4) file="f4-prompt-engineering.md" ;;
    f5) file="f5-context-reliability.md" ;;
    vocab|vocabulary) file="vocabulary.md" ;;
    checklist|review) file="review-checklist.md" ;;
    sources) file="sources.md" ;;
    *) echo "ref.sh: unknown reference '$name' (use d1..d7, f1..f5, vocab, checklist, sources)" >&2; exit 1 ;;
  esac
  printf '\n<!-- architect-handbook reference: %s -->\n\n' "$file"
  cat "$dir/$file"
done
