#!/bin/sh
# Print this plugin's rule files by short name, for example:
#   ref.sh d3 d5          ref.sh checklist          ref.sh vocab
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
    vocab|vocabulary) file="vocabulary.md" ;;
    checklist|review) file="review-checklist.md" ;;
    sources) file="sources.md" ;;
    *) echo "ref.sh: unknown reference '$name' (use d1..d7, vocab, checklist, sources)" >&2; exit 1 ;;
  esac
  printf '\n<!-- ai-architect-rules reference: %s -->\n\n' "$file"
  cat "$dir/$file"
done
