#!/usr/bin/env bash
set -euo pipefail

INPUT="timeline.tsv"
README="README.md"
TEMP="README.md.tmp"

awk -F '\t' '
BEGIN {
  print "| Period | Milestone |"
  print "| --- | --- |"
}
{
  gsub(/\|/, "\\|", $2)
  printf "| %s | %s |\n", $1, $2
}' "$INPUT" > timeline.generated.md

awk '
BEGIN { inside=0 }
/<!-- START_TIMELINE -->/ {
  print
  while ((getline line < "timeline.generated.md") > 0) print line
  close("timeline.generated.md")
  inside=1
  next
}
/<!-- END_TIMELINE -->/ { inside=0 }
!inside { print }
' "$README" > "$TEMP"

mv "$TEMP" "$README"
rm timeline.generated.md
