#!/bin/bash
#==========================================================================
#  Setup Script for Daily Commit Reminder
#  Author: Mohammed Alefari (mmsal512)
#  Description: Installs and configures the daily commit reminder
#               with cron job and Telegram integration.
#==========================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║     📅 Daily Commit Reminder - Setup Script         ║"
echo "║     Author: Mohammed Alefari (mmsal512)             ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ========================= Step 1: Telegram Bot Setup =========================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📱 Step 1: Telegram Bot Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if environment variables are already set
if [[ -n "${TELEGRAM_TOKEN:-}" && -n "${TELEGRAM_CHAT_ID:-}" ]]; then
    echo -e "${GREEN}✅ Telegram credentials detected from environment.${NC}"
    TOKEN="$TELEGRAM_TOKEN"
    CHAT_ID="$TELEGRAM_CHAT_ID"
else
    echo -e "${YELLOW}To set up Telegram notifications:${NC}"
    echo "  1. Open Telegram and search for @BotFather"
    echo "  2. Send /newbot and follow the instructions"
    echo "  3. Copy the bot token provided"
    echo "  4. Start a chat with your bot and send any message"
    echo "  5. Visit: https://api.telegram.org/bot<TOKEN>/getUpdates"
    echo "  6. Find your chat_id in the response"
    echo ""

    read -rp "🔑 Enter your Telegram Bot Token (or press Enter to skip): " TOKEN
    read -rp "💬 Enter your Telegram Chat ID (or press Enter to skip): " CHAT_ID
fi

# ========================= Step 2: Repository Path =========================

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📂 Step 2: Repository Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

DEFAULT_REPO="$HOME/devops-learning-journal"
read -rp "📁 Repository path [$DEFAULT_REPO]: " REPO_PATH
REPO_PATH="${REPO_PATH:-$DEFAULT_REPO}"

# ========================= Step 3: Install Script =========================

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}⚙️ Step 3: Installing Script${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PATH="$HOME/.local/bin/daily-commit-reminder.sh"

# Create bin directory if it doesn't exist
mkdir -p "$HOME/.local/bin"

# Copy script
cp "$SCRIPT_DIR/daily-commit-reminder.sh" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"
echo -e "${GREEN}✅ Script installed to: $INSTALL_PATH${NC}"

# ========================= Step 4: Environment File =========================

ENV_FILE="$HOME/.daily-commit-reminder.env"
cat > "$ENV_FILE" << EOF
# Daily Commit Reminder Configuration
# Generated on: $(date '+%Y-%m-%d %H:%M:%S')

export TELEGRAM_TOKEN="${TOKEN:-YOUR_BOT_TOKEN_HERE}"
export TELEGRAM_CHAT_ID="${CHAT_ID:-YOUR_CHAT_ID_HERE}"
export REPO_DIR="${REPO_PATH}"
export ENABLE_TELEGRAM="true"
export ENABLE_TERMINAL="true"
export LOG_DIR="/var/log"
EOF

chmod 600 "$ENV_FILE"
echo -e "${GREEN}✅ Environment file created: $ENV_FILE${NC}"

# ========================= Step 5: Cron Job Setup =========================

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}⏰ Step 5: Cron Job Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Cron entries - reminders at 10 AM, 4 PM, and 9 PM
CRON_ENTRIES=(
    "0 10 * * * source $ENV_FILE && $INSTALL_PATH"
    "0 16 * * * source $ENV_FILE && $INSTALL_PATH"
    "0 21 * * * source $ENV_FILE && $INSTALL_PATH"
)

echo "The following cron jobs will be added:"
for entry in "${CRON_ENTRIES[@]}"; do
    echo "  📌 $entry"
done
echo ""

read -rp "Add cron jobs? (y/n) [y]: " ADD_CRON
ADD_CRON="${ADD_CRON:-y}"

if [[ "$ADD_CRON" =~ ^[Yy]$ ]]; then
    # Backup existing crontab
    crontab -l > /tmp/crontab_backup_$(date +%Y%m%d) 2>/dev/null || true

    # Remove old entries if they exist
    (crontab -l 2>/dev/null | grep -v "daily-commit-reminder") > /tmp/crontab_new || true

    # Add new entries
    echo "" >> /tmp/crontab_new
    echo "# Daily Commit Reminder - Added on $(date '+%Y-%m-%d')" >> /tmp/crontab_new
    for entry in "${CRON_ENTRIES[@]}"; do
        echo "$entry" >> /tmp/crontab_new
    done

    crontab /tmp/crontab_new
    rm -f /tmp/crontab_new
    echo -e "${GREEN}✅ Cron jobs installed successfully!${NC}"
else
    echo -e "${YELLOW}⏭️ Skipped cron setup. You can add them manually later.${NC}"
fi

# ========================= Step 6: Test =========================

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🧪 Step 6: Testing${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [[ -n "${TOKEN:-}" && -n "${CHAT_ID:-}" && "$TOKEN" != "YOUR_BOT_TOKEN_HERE" ]]; then
    read -rp "Send a test notification? (y/n) [y]: " SEND_TEST
    SEND_TEST="${SEND_TEST:-y}"

    if [[ "$SEND_TEST" =~ ^[Yy]$ ]]; then
        source "$ENV_FILE"
        "$INSTALL_PATH" --test
    fi
else
    echo -e "${YELLOW}⏭️ Skipping test (Telegram not configured).${NC}"
    echo "   Configure your token in: $ENV_FILE"
fi

# ========================= Summary =========================

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗"
echo -e "║                 ✅ Setup Complete!                    ║"
echo -e "╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  📜 Script:      ${GREEN}$INSTALL_PATH${NC}"
echo -e "  🔧 Config:      ${GREEN}$ENV_FILE${NC}"
echo -e "  📂 Repository:  ${GREEN}$REPO_PATH${NC}"
echo ""
echo -e "  ${YELLOW}Quick Commands:${NC}"
echo -e "  • Test:    ${CYAN}source $ENV_FILE && $INSTALL_PATH --test${NC}"
echo -e "  • Status:  ${CYAN}source $ENV_FILE && $INSTALL_PATH --status${NC}"
echo -e "  • Check:   ${CYAN}source $ENV_FILE && $INSTALL_PATH${NC}"
echo ""
echo -e "  ${YELLOW}⏰ Cron Schedule:${NC}"
echo -e "  • 10:00 AM - Morning reminder"
echo -e "  • 04:00 PM - Afternoon reminder"
echo -e "  • 09:00 PM - Evening reminder (urgent)"
echo ""
