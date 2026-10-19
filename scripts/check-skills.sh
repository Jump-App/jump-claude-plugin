#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

prod_url="https://my.jumpapp.com/mcp"
jump_tools=(
  jump_search_jump_contact
  jump_search_meeting_participants
  jump_list_meetings
  jump_list_participant_meetings
  jump_semantic_meeting_search
  jump_get_meeting_content
  jump_semantic_document_search
  jump_get_document_content
  jump_list_documents
  jump_list_jump_tasks
)

failures=0

fail() {
  echo "FAIL: $*"
  failures=$((failures + 1))
}

python3 -I -m json.tool .claude-plugin/plugin.json >/dev/null || fail ".claude-plugin/plugin.json is not valid JSON"
python3 -I -m json.tool .mcp.json >/dev/null || fail ".mcp.json is not valid JSON"

mcp_url="$(python3 -I -c 'import json; print(json.load(open(".mcp.json"))["mcpServers"]["jump"]["url"])')"
[[ "$mcp_url" == "$prod_url" ]] || fail ".mcp.json points to $mcp_url instead of $prod_url"

shopt -s nullglob
skill_files=(skills/*/SKILL.md)

for file in ${skill_files[@]+"${skill_files[@]}"}; do
  dir="$(basename "$(dirname "$file")")"

  [[ "$(head -n 1 "$file")" == "---" ]] || fail "$file: missing frontmatter"

  frontmatter="$(awk 'NR == 1 { next } /^---$/ { exit } { print }' "$file")"
  name="$(sed -n 's/^name: *//p' <<<"$frontmatter")"
  description="$(sed -n 's/^description: *//p' <<<"$frontmatter")"

  [[ "$name" == "$dir" ]] || fail "$file: name '$name' does not match folder '$dir'"
  [[ -n "$description" ]] || fail "$file: empty description"
  grep -q '^compatibility: ' <<<"$frontmatter" || fail "$file: missing compatibility"
  (( ${#description} <= 1024 )) || fail "$file: description has ${#description} characters (max 1024)"

  while read -r tool; do
    [[ " ${jump_tools[*]} " == *" $tool "* ]] || fail "$file: unknown tool $tool"
  done < <(grep -oE 'jump_[a-z_]+' "$file" | sort -u)

  while IFS= read -r line; do
    grep -qi 'never' <<<"$line" || fail "$file: requests a transcript: $line"
  done < <(grep -E 'detail_level[^.]*"transcript"' "$file" || true)
done

while IFS= read -r stray; do
  fail "remove $stray"
done < <(find . -name .DS_Store)

if (( failures > 0 )); then
  echo "$failures check(s) failed"
  exit 1
fi

echo "All checks passed for ${#skill_files[@]} skills"
