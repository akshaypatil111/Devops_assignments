#!/bin/bash

# Function to find top n processes by memory or CPU
top_process() {
    local n=$1
    local type=$2

    if [ "$type" == "memory" ]; then
        ps -eo pid,comm,%mem --sort=-%mem | head -n "$((n + 1))"
    elif [ "$type" == "cpu" ]; then
        ps -eo pid,comm,%cpu --sort=-%cpu | head -n "$((n + 1))"
    else
        echo "Invalid type: $type. Use 'memory' or 'cpu'."
    fi
}

# Function to kill process with the least priority (lowest PID)
kill_least_priority_process() {
    local pid=$(ps -eo pid --sort=pid | tail -n 1)
    
    if [ "$pid" != "PID" ]; then
        kill "$pid" && echo "Killed process with PID $pid"
    else
        echo "No processes found."
    fi
}

# Function to show the running duration of a process by name or PID
running_duration_process() {
    local identifier=$1

    if [[ "$identifier" =~ ^[0-9]+$ ]]; then
        ps -p "$identifier" -o etime= 2>/dev/null
    else
        pid=$(pgrep -f "$identifier")
        if [ -n "$pid" ]; then
            ps -p "$pid" -o etime= 2>/dev/null
        else
            echo "No process found with name '$identifier'."
        fi
    fi
}

# Function to list orphan processes
list_orphan_process() {
    ps -eo pid,ppid,comm | awk '$2 == 1 {print $0}'
}

# Function to list zombie processes
list_zombie_process() {
    ps -eo pid,stat,comm | awk '$2 ~ /Z/ {print $0}'
}

# Function to kill a process by name or PID
kill_process() {
    local identifier=$1

    if [[ "$identifier" =~ ^[0-9]+$ ]]; then
        kill "$identifier" && echo "Killed process with PID $identifier"
    else
        pkill -f "$identifier" && echo "Killed process with name '$identifier'"
    fi
}

# Function to list processes waiting for resources
list_waiting_process() {
    ps -eo pid,stat,comm | awk '$2 ~ /D/ {print $0}'
}

# Main function to handle commands
case $1 in
    topProcess)
        if [ "$#" -ne 3 ]; then
            echo "Usage: $0 topProcess <n> <memory|cpu>"
            exit 1
        fi
        top_process "$2" "$3"
        ;;
    killLeastPriorityProcess)
        kill_least_priority_process
        ;;
    RunningDurationProcess)
        if [ "$#" -ne 2 ]; then
            echo "Usage: $0 RunningDurationProcess <processName|processID>"
            exit 1
        fi
        running_duration_process "$2"
        ;;
    listOrphanProcess)
        list_orphan_process
        ;;
    listZoombieProcess)
        list_zombie_process
        ;;
    killProcess)
        if [ "$#" -ne 2 ]; then
            echo "Usage: $0 killProcess <processName|processID>"
            exit 1
        fi
        kill_process "$2"
        ;;
    ListWaitingProcess)
        list_waiting_process
        ;;
    *)
        echo "Usage: $0 {topProcess <n> <memory|cpu>|killLeastPriorityProcess|RunningDurationProcess <processName|processID>|listOrphanProcess|listZoombieProcess|killProcess <processName|processID>|ListWaitingProcess}"
        ;;
esac

