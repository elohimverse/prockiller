#!/bin/bash
#########################################################################################
# Script Name : prockiller-ios.sh
# Description : A simple interactive script to view, search, and kill processes by name.
#               This script provides oldschool menu to display the full process list,
#               search for processes by part of their name, and terminate selected processes.
#
# Usage       : Run the script with appropriate permissions (e.g., sudo) as follows:
#                 sudo ./prockiller-ios.sh
#
# Options     :
#   - Display full process list
#   - Search for a process by name
#   - Kill processes interactively
#
# Requirements:
#   - Bash Shell
#   - `ps` command for process listing
#   - `awk` for data processing
#   - `kill` for terminating processes
#
# Author      : Rosen Tsaryanski
# Contact     : rosen@cloudnomad.io
# Version     : 1.0
# License     : MIT License
#########################################################################################


# Colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"
BOLD="\033[1m"

temp_file=$(mktemp /tmp/process_names.XXXXXX) || {
    printf "%b\n" "${RED}Failed to create temp file. Exiting.${RESET}"
    exit 1
}

# Generate process list
ps -eo pid=,comm= | awk '
{
    no=NR
    pid=$1
    cmd=$2
    sub(".*/","",cmd)
    if (substr(cmd,1,1) == "-") {
        cmd=" " cmd
    }
    print no, pid, cmd
}' > "$temp_file"

display_processes() {
    clear
    printf "%b\n" "${BOLD}${CYAN}==================================="
    printf "%b\n" "            PROCESS LIST"
    printf "%b\n" "===================================${RESET}"
    printf "%b\n" "${YELLOW}No.   PID        Process Name       ${RESET}"
    printf "%b\n" "-----------------------------------"
    awk '{
        printf("%-5s %-10s %-20s\n", $1, $2, $3)
    }' "$temp_file"
    printf "%b\n" "${CYAN}===================================${RESET}"
    read -p "Enter the number to kill a process, or press Enter to return: " num
    if [[ -n "$num" ]]; then
        kill_process "$num"
    fi
}

search_process() {
    clear
    read -p "Enter part of the process name to search: " search
    printf "%b\n" "${BOLD}${CYAN}==================================="
    printf "%b\n" "       SEARCH RESULTS: $search"
    printf "%b\n" "===================================${RESET}"
    printf "%b\n" "${YELLOW}No.   PID        Process Name       ${RESET}"
    printf "%b\n" "-----------------------------------"
    awk -v name="$search" '{
        if ($3 ~ name) {
            printf("%-5s %-10s %-20s\n", $1, $2, $3)
        }
    }' "$temp_file"
    printf "%b\n" "${CYAN}===================================${RESET}"
    read -p "Enter the number to kill a process, or press Enter to return: " num
    if [[ -n "$num" ]]; then
        kill_process "$num"
    fi
}

kill_process() {
    local num="$1"
    local pid
    pid=$(awk -v n="$num" 'NR == n {print $2}' "$temp_file")
    if [[ -n "$pid" ]]; then
        printf "%b\n" "${BOLD}${RED}==================================="
        printf "%b\n" "    Killing PID $pid..."
        printf "%b\n" "===================================${RESET}"
        if kill -9 "$pid"; then
            printf "%b\n" "${GREEN}PID $pid killed successfully.${RESET}"
        else
            printf "%b\n" "${RED}Failed to kill PID $pid.${RESET}"
        fi
    else
        printf "%b\n" "${RED}Invalid selection. Please try again.${RESET}"
    fi
    read -p "Press Enter to return to the menu..."
}

while true; do
    clear
    printf "%b\n" "${BOLD}${CYAN}==================================="
    printf "%b\n" "         PROCESS KILLER"
    printf "%b\n" "===================================${RESET}"
    printf "%b\n" "${YELLOW}1. Display full process list${RESET}"
    printf "%b\n" "${YELLOW}2. Search for a process by name${RESET}"
    printf "%b\n" "${YELLOW}3. Quit${RESET}"
    printf "%b\n" "${CYAN}===================================${RESET}"
    read -p "Choose an option: " option

    case "$option" in
        1) display_processes ;;
        2) search_process ;;
        3)
            printf "%b\n" "${GREEN}Exiting. Goodbye!${RESET}"
            break
            ;;
        *)
            printf "%b\n" "${RED}Invalid option. Try again.${RESET}"
            ;;
    esac
done

rm -f "$temp_file"
