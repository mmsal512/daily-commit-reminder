#!/bin/bash
#==========================================================================
#  Daily Commit Reminder Script with Telegram Notifications
#  Author: Mohammed Alefari (mmsal512)
#  Description: Checks if a commit was made today in the specified
#               repository and sends a Telegram notification if not.
#               Designed to maintain an active GitHub contribution graph.
#==========================================================================

set -euo pipefail

# ========================= Configuration =========================

# Repository to monitor (change to your learning journal path)
REPO_DIR="${REPO_DIR:-$HOME/devops-learning-journal}"

# Telegram Bot Configuration
# Set these as environment variables or replace with your values
TELEGRAM_TOKEN="${TELEGRAM_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

# Notification settings
ENABLE_TELEGRAM="${ENABLE_TELEGRAM:-true}"
ENABLE_TERMINAL="${ENABLE_TERMINAL:-true}"

# Log file
LOG_FILE="${LOG_DIR:-/var/log}/daily-commit-reminder.log"

# ========================= Functions =========================

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE" 2>/dev/null || echo "[$timestamp] [$level] $message"
}

send_telegram() {
    local message="$1"

    if [[ "$ENABLE_TELEGRAM" != "true" ]]; then
        log "INFO" "Telegram notifications disabled. Skipping."
        return 0
    fi

    if [[ -z "$TELEGRAM_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]]; then
        log "WARN" "Telegram TOKEN or CHAT_ID not set. Skipping notification."
        return 1
    fi

    local response
    response=$(curl -s -w "\n%{http_code}" -X POST \
        "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d parse_mode="Markdown" \
        -d text="${message}" 2>&1)

    local http_code
    http_code=$(echo "$response" | tail -1)
    local body
    body=$(echo "$response" | head -n -1)

    if [[ "$http_code" == "200" ]]; then
        log "INFO" "✅ Telegram notification sent successfully."
        return 0
    else
        log "ERROR" "❌ Failed to send Telegram notification. HTTP: $http_code"
        log "ERROR" "Response: $body"
        return 1
    fi
}

check_dependencies() {
    local missing=()
    for cmd in git curl date; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log "ERROR" "Missing dependencies: ${missing[*]}"
        exit 1
    fi
}

get_streak_count() {
    local streak=0
    local check_date
    check_date=$(date +%Y-%m-%d)

    while true; do
        local commit_count
        commit_count=$(git log --oneline --after="${check_date} 00:00:00" --before="${check_date} 23:59:59" 2>/dev/null | wc -l)

        if [[ "$commit_count" -gt 0 ]]; then
            ((streak++))
            check_date=$(date -d "$check_date -1 day" +%Y-%m-%d 2>/dev/null || date -v-1d -j -f "%Y-%m-%d" "$check_date" +%Y-%m-%d 2>/dev/null)
        else
            break
        fi
    done

    echo "$streak"
}

# ========================= Main Logic =========================

main() {
    log "INFO" "=========================================="
    log "INFO" "Daily Commit Reminder - Starting check..."
    log "INFO" "=========================================="

    # Check dependencies
    check_dependencies

    # Verify repository exists
    if [[ ! -d "$REPO_DIR" ]]; then
        log "ERROR" "Repository directory not found: $REPO_DIR"
        send_telegram "❌ *خطأ:* مجلد المستودع غير موجود: \`$REPO_DIR\`"
        exit 1
    fi

    # Navigate to repository
    cd "$REPO_DIR" || {
        log "ERROR" "Cannot access repository: $REPO_DIR"
        exit 1
    }

    # Verify it's a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        log "ERROR" "$REPO_DIR is not a git repository!"
        exit 1
    fi

    # Get today's date and last commit date
    local TODAY
    TODAY=$(date +%Y-%m-%d)
    local LAST_COMMIT
    LAST_COMMIT=$(git log -1 --format=%cd --date=short 2>/dev/null || echo "none")
    local TODAY_COMMITS
    TODAY_COMMITS=$(git log --oneline --since="$TODAY 00:00:00" 2>/dev/null | wc -l)
    local CURRENT_HOUR
    CURRENT_HOUR=$(date +%H)

    log "INFO" "📅 Today: $TODAY"
    log "INFO" "📝 Last commit: $LAST_COMMIT"
    log "INFO" "📊 Today's commits: $TODAY_COMMITS"

    if [[ "$TODAY_COMMITS" -gt 0 ]]; then
        # ✅ Already committed today
        log "INFO" "✅ Great! You already have $TODAY_COMMITS commit(s) today!"

        if [[ "$ENABLE_TERMINAL" == "true" ]]; then
            echo ""
            echo "  ✅ أحسنت! لديك $TODAY_COMMITS التزام(ات) اليوم!"
            echo "  📅 التاريخ: $TODAY"
            echo "  🎯 استمر في العمل الرائع!"
            echo ""
        fi

        # Send success notification (optional - only at end of day)
        if [[ "$CURRENT_HOUR" -ge 22 ]]; then
            local streak
            streak=$(get_streak_count)
            send_telegram "✅ *تقرير يومي:* أنجزت $TODAY_COMMITS التزام(ات) اليوم!
🔥 سلسلة الالتزامات: $streak يوم
📅 التاريخ: $TODAY
💪 استمر في العمل الرائع يا محمد!"
        fi

    else
        # ⚠️ No commits today - send reminder
        log "WARN" "⚠️ No commits today yet!"

        if [[ "$ENABLE_TERMINAL" == "true" ]]; then
            echo ""
            echo "  ⚠️ تنبيه: لم تقم بأي التزام اليوم بعد!"
            echo "  📅 التاريخ: $TODAY"
            echo "  📝 آخر التزام: $LAST_COMMIT"
            echo "  🚀 حان وقت التعلم والعمل!"
            echo ""
        fi

        # Determine urgency based on time of day
        local urgency_emoji="⏰"
        local urgency_text="تذكير"
        if [[ "$CURRENT_HOUR" -ge 20 ]]; then
            urgency_emoji="🚨"
            urgency_text="تنبيه عاجل"
        elif [[ "$CURRENT_HOUR" -ge 16 ]]; then
            urgency_emoji="⚠️"
            urgency_text="تذكير مهم"
        fi

        send_telegram "$urgency_emoji *$urgency_text DevOps:*

لم تقم بأي التزام (commit) اليوم في:
📂 \`devops-learning-journal\`

📝 آخر التزام: $LAST_COMMIT

💡 *أفكار سريعة:*
• وثّق أمر لينكس جديد تعلمته
• أضف ملاحظات عن أداة DevOps
• حدّث ملف التعلم اليومي
• أضف سكربت أو تكوين جديد

🚀 حافظ على الاستمرار يا محمد!"
    fi

    log "INFO" "Check completed successfully."
}

# ========================= Execution =========================

# Handle script arguments
case "${1:-}" in
    --test)
        log "INFO" "Running in test mode..."
        send_telegram "🧪 *اختبار:* سكربت التذكير اليومي يعمل بنجاح! ✅"
        echo "✅ Test notification sent!"
        ;;
    --status)
        cd "$REPO_DIR" 2>/dev/null || { echo "❌ Cannot access repo"; exit 1; }
        echo "📊 Repository Status:"
        echo "  📂 Path: $REPO_DIR"
        echo "  📝 Last commit: $(git log -1 --format='%cd - %s' --date=short 2>/dev/null || echo 'none')"
        echo "  📅 Today's commits: $(git log --oneline --since="$(date +%Y-%m-%d) 00:00:00" 2>/dev/null | wc -l)"
        echo "  🔥 Current streak: $(get_streak_count) days"
        ;;
    --help|-h)
        echo "Usage: $0 [OPTION]"
        echo ""
        echo "Daily Commit Reminder with Telegram Notifications"
        echo ""
        echo "Options:"
        echo "  --test     Send a test notification to Telegram"
        echo "  --status   Show current repository commit status"
        echo "  --help     Show this help message"
        echo ""
        echo "Environment Variables:"
        echo "  TELEGRAM_TOKEN    Telegram Bot API Token"
        echo "  TELEGRAM_CHAT_ID  Telegram Chat ID for notifications"
        echo "  REPO_DIR          Repository path (default: ~/devops-learning-journal)"
        echo "  ENABLE_TELEGRAM   Enable Telegram notifications (default: true)"
        echo "  LOG_DIR           Log directory (default: /var/log)"
        ;;
    *)
        main
        ;;
esac
