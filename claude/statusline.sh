#!/bin/bash

# Read JSON input once
input=$(cat)

# Helper functions for common extractions
get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version'; }
get_cost() { echo "$input" | jq -r '.cost.total_cost_usd'; }
get_duration() { echo "$input" | jq -r '.cost.total_duration_ms'; }
get_lines_added() { echo "$input" | jq -r '.cost.total_lines_added'; }
get_lines_removed() { echo "$input" | jq -r '.cost.total_lines_removed'; }
get_context_pct() { echo "$input" | jq -r '.context_window.used_percentage // 0'; }

# Use the helpers
MODEL=$(get_model_name)
DIR=$(get_current_dir)
COST=$(get_cost)
DURATION=$(get_duration)
CONTEXT_PCT=$(get_context_pct | cut -d. -f1)

# costとdurationのフォーマット処理
if [ "$COST" != "null" ] && [ -n "$COST" ]; then
    # 小数点2桁までに制限（2.48のように表示、それ以降は切り捨て）
    COST_FORMATTED=$(awk "BEGIN {printf \"%.2f\", $COST}")
    COST_DISPLAY=" 💰 \$${COST_FORMATTED}"
else
    COST_DISPLAY=""
fi

if [ "$DURATION" != "null" ] && [ -n "$DURATION" ]; then
    # ミリ秒を秒に変換（awkを使用して小数点以下1桁まで表示）
    # ゼロでも表示する（処理時間が実際に記録されていることを示すため）
    DURATION_SEC=$(awk "BEGIN {printf \"%.1f\", $DURATION / 1000}")
    DURATION_DISPLAY=" ⏱ ${DURATION_SEC}s"
else
    DURATION_DISPLAY=""
fi

CONTEXT_DISPLAY=" 🧠 ${CONTEXT_PCT}%"

echo "[$MODEL] 📁 ${DIR##*/}${COST_DISPLAY}${DURATION_DISPLAY}${CONTEXT_DISPLAY}"
