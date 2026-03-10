#!/bin/bash
#==========================================================================
#  Uninstall Script for Daily Commit Reminder
#  Author: Mohammed Alefari (mmsal512)
#==========================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🗑️ Removing Daily Commit Reminder...${NC}"

# Remove cron entries
(crontab -l 2>/dev/null | grep -v "daily-commit-reminder") | crontab - 2>/dev/null || true
echo -e "${GREEN}✅ Cron jobs removed.${NC}"

# Remove script
if [[ -f "$HOME/.local/bin/daily-commit-reminder.sh" ]]; then
    rm -f "$HOME/.local/bin/daily-commit-reminder.sh"
    echo -e "${GREEN}✅ Script removed.${NC}"
fi

# Remove config
if [[ -f "$HOME/.daily-commit-reminder.env" ]]; then
    read -rp "Remove configuration file? (y/n) [n]: " REMOVE_CONFIG
    if [[ "${REMOVE_CONFIG:-n}" =~ ^[Yy]$ ]]; then
        rm -f "$HOME/.daily-commit-reminder.env"
        echo -e "${GREEN}✅ Configuration removed.${NC}"
    else
        echo -e "${YELLOW}⏭️ Configuration kept at: $HOME/.daily-commit-reminder.env${NC}"
    fi
fi

echo -e "${GREEN}✅ Uninstall complete!${NC}"
