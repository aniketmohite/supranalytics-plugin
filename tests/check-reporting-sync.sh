#!/bin/sh
# Checks that every skill bundles an identical copy of the shared reporting
# standards and loads that copy. skills/shared/REPORTING.md is the source of truth.
#
# Usage: sh tests/check-reporting-sync.sh
# To fix a failure, edit the source, then copy it over the reported skill's
# references/REPORTING.md.

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
source_file="$root/skills/shared/REPORTING.md"
load_line='Load `references/REPORTING.md`'
stale_path='skills/shared/REPORTING.md'
failures=0
checked=0

fail() {
  echo "FAIL  $1"
  failures=$((failures + 1))
}

if [ ! -f "$source_file" ]; then
  echo "FAIL  source file is missing: skills/shared/REPORTING.md"
  exit 1
fi

for skill_md in "$root"/skills/*/SKILL.md; do
  [ -f "$skill_md" ] || continue
  skill_dir=$(dirname -- "$skill_md")
  skill=$(basename -- "$skill_dir")
  copy="$skill_dir/references/REPORTING.md"
  checked=$((checked + 1))
  before=$failures

  if [ -L "$copy" ]; then
    fail "$skill: references/REPORTING.md is a symlink, not a bundled copy"
  elif [ ! -f "$copy" ]; then
    fail "$skill: references/REPORTING.md is missing"
  elif ! cmp -s "$source_file" "$copy"; then
    fail "$skill: references/REPORTING.md differs from skills/shared/REPORTING.md"
  fi

  if ! grep -Fq "$load_line" "$skill_md"; then
    fail "$skill: SKILL.md does not load references/REPORTING.md"
  fi
  if grep -Fq "$stale_path" "$skill_md"; then
    fail "$skill: SKILL.md still points to skills/shared/REPORTING.md"
  fi

  [ "$failures" -eq "$before" ] && echo "ok    $skill"
done

if [ "$checked" -eq 0 ]; then
  echo "FAIL  no skills found under skills/"
  exit 1
fi

if [ "$failures" -gt 0 ]; then
  echo "$failures problem(s) across $checked skills"
  exit 1
fi

echo "All $checked skills are in sync with skills/shared/REPORTING.md"
