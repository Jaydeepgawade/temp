#!/usr/bin/env bash
set -euo pipefail

files=(
  DSA/10-List-In-CSharp.md
  DSA/11-Dictionary-In-CSharp.md
  DSA/12-HashSet-In-CSharp.md
  DSA/13-Stack-In-CSharp.md
  DSA/14-Queue-In-CSharp.md
)

for file in "${files[@]}"; do
  test -f "$file" || { echo "Missing: $file"; exit 1; }
  lines=$(wc -l < "$file")
  (( lines >= 500 && lines <= 600 )) || { echo "$file has $lines lines"; exit 1; }
  problems=$(rg -c '^## Solved Problem [1-5]:' "$file")
  dry_runs=$(rg -c '^### Dry Run' "$file")
  (( problems >= 5 )) || { echo "$file has only $problems solved problems"; exit 1; }
  (( dry_runs >= 5 )) || { echo "$file has only $dry_runs dry runs"; exit 1; }
  for number in 1 2 3 4 5; do
    count=$(rg -c "^## Solved Problem ${number}:" "$file")
    (( count == 1 )) || { echo "$file must contain Solved Problem $number exactly once"; exit 1; }
  done
  if rg -q '^Revision checkpoint' "$file"; then
    echo "$file contains repetitive revision padding"
    exit 1
  fi
  if LC_ALL=C rg -q '[^\x00-\x7F]' "$file"; then
    echo "$file contains non-ASCII text; chapters must remain English-only"
    exit 1
  fi
  fences=$(rg -c '^```' "$file")
  (( fences % 2 == 0 )) || { echo "$file has an unclosed code fence"; exit 1; }
done

expected=(
  DSA/15-Graph-Basics-BFS-DFS.md
  DSA/16-Greedy-Algorithm-Basics.md
  DSA/17-Dynamic-Programming-Basics.md
)
for file in "${expected[@]}"; do
  test -f "$file" || { echo "Missing renumbered chapter: $file"; exit 1; }
done

old=(
  DSA/10-Graph-Basics-BFS-DFS.md
  DSA/11-Greedy-Algorithm-Basics.md
  DSA/12-Dynamic-Programming-Basics.md
)
for file in "${old[@]}"; do
  test ! -e "$file" || { echo "Old chapter name still exists: $file"; exit 1; }
done

echo "Foundation chapter validation passed."
