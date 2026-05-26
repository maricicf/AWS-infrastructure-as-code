#!/bin/bash

# Konfiguracija
REPO="maricicf/AWS-infrastructure-as-code"
OUTPUT_FILE="failed_runs_report.txt"
HOURS=24

# datum 24h pre
SINCE=$(date -d "$HOURS hours ago" --utc +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -v-${HOURS}H +%Y-%m-%dT%H:%M:%SZ)

echo "Fetching failed workflow runs from last $HOURS hours..."

# failed runs
RUNS=$(gh run list \
  --repo "$REPO" \
  --status failure \
  --limit 100 \
  --json "databaseId,name,headBranch,createdAt" \
  --jq ".[] | select(.createdAt > \"$SINCE\")")

# report
echo "=====================================" > "$OUTPUT_FILE"
echo "Failed GitHub Actions Runs Report" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "Repository: $REPO" >> "$OUTPUT_FILE"
echo "Period: Last $HOURS hours" >> "$OUTPUT_FILE"
echo "=====================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ -z "$RUNS" ]; then
  echo "No failed runs found in the last $HOURS hours." >> "$OUTPUT_FILE"
else
  echo "$RUNS" | jq -r '. | "Workflow: \(.name)\nRun ID: \(.databaseId)\nBranch: \(.headBranch)\nTime: \(.createdAt)\n---"' >> "$OUTPUT_FILE"
fi

echo "Report saved to $OUTPUT_FILE"
cat "$OUTPUT_FILE"