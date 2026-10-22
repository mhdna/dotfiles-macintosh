#!/bin/bash
input=$(cat)

# Extract data
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
CONTEXT_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
SESSION_LIMIT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
WEEKLY_LIMIT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)

# Build progress bars (10 segments)
build_bar() {
  local pct=$1
  local filled=$((pct / 10))
  local empty=$((10 - filled))
  printf '█%.0s' $(seq 1 $filled)
  printf '░%.0s' $(seq 1 $empty)
}

SESSION_BAR=$(build_bar $SESSION_LIMIT)
WEEKLY_BAR=$(build_bar $WEEKLY_LIMIT)

# Output: [Model] Context: 42% | Session: ███░░░░░░░ 30% | Weekly: ██░░░░░░░░ 15%
echo "[$MODEL] Context: $CONTEXT_PCT% | Session: $SESSION_BAR $SESSION_LIMIT% | Weekly: $WEEKLY_BAR $WEEKLY_LIMIT%"
