#!/bin/bash

# File to store service information
SERVICE_FILE="services.txt"

# Function to register a service
register_service() {
    local script_path=$1
    local alias=$2

    # Check if the alias already exists
    if grep -q "^$alias|" "$SERVICE_FILE"; then
        echo "Service with alias '$alias' already registered."
        return
    fi

    echo "$alias|$script_path|STOPPED|N/A|med" >> "$SERVICE_FILE"
    echo "Service '$alias' registered successfully."
}

# Function to start a service
start_service() {
    local alias=$1

    # Find the service in the file
    local service_info=$(grep "^$alias|" "$SERVICE_FILE")
    if [ -z "$service_info" ]; then
        echo "Service with alias '$alias' not found."
        return
    fi

    # Extract script path and check if already running
    local script_path=$(echo "$service_info" | cut -d '|' -f 2)
    local status=$(echo "$service_info" | cut -d '|' -f 3)
    if [ "$status" = "RUNNING" ]; then
        echo "Service '$alias' is already running."
        return
    fi

    # Start the service as a daemon
    nohup bash "$script_path" >/dev/null 2>&1 &
    local pid=$!

    # Update the service information
    sed -i "/^$alias|/ s/|STOPPED|N\/A|/|RUNNING|$pid|/" "$SERVICE_FILE"
    echo "Service '$alias' started successfully with PID $pid."
}

# Function to show the status of a service
status_service() {
    local alias=$1

    # Find the service in the file
    local service_info=$(grep "^$alias|" "$SERVICE_FILE")
    if [ -z "$service_info" ]; then
        echo "Service with alias '$alias' not found."
        return
    fi

    local status=$(echo "$service_info" | cut -d '|' -f 3)
    echo "Service '$alias' is $status."
}

# Function to stop a service
stop_service() {
    local alias=$1

    # Find the service in the file
    local service_info=$(grep "^$alias|" "$SERVICE_FILE")
    if [ -z "$service_info" ]; then
        echo "Service with alias '$alias' not found."
        return
    fi

    local status=$(echo "$service_info" | cut -d '|' -f 3)
    if [ "$status" = "STOPPED" ]; then
        echo "Service '$alias' is not running."
        return
    fi

    local pid=$(echo "$service_info" | cut -d '|' -f 4)
    kill "$pid"

    # Update the service information
    sed -i "/^$alias|/ s/|RUNNING|$pid|/|STOPPED|N\/A|/" "$SERVICE_FILE"
    echo "Service '$alias' stopped successfully."
}

# Function to change the priority of a service
change_priority() {
    local priority=$1
    local alias=$2

    # Validate priority
    if [[ "$priority" != "low" && "$priority" != "med" && "$priority" != "high" ]]; then
        echo "Invalid priority: $priority. Valid options are low, med, high."
        return
    fi

    # Find the service in the file
    local service_info=$(grep "^$alias|" "$SERVICE_FILE")
    if [ -z "$service_info" ]; then
        echo "Service with alias '$alias' not found."
        return
    fi

    # Update the service information
    sed -i "/^$alias|/ s/|[^|]*\$|$priority/" "$SERVICE_FILE"
    echo "Priority of service '$alias' changed to $priority."
}

# Function to list all registered services
list_services() {
    while IFS='|' read -r alias _ _ _ _; do
        echo "$alias"
    done < "$SERVICE_FILE"
}

# Function to show details of services
show_details() {
    local alias=$1
    if [ -n "$alias" ]; then
        grep "^$alias|" "$SERVICE_FILE" | awk -F '|' '{print $1 ", " $4 ", " $3 ", " $5 ", " $2}'
    else
        awk -F '|' '{print $1 ", " $4 ", " $3 ", " $5 ", " $2}' "$SERVICE_FILE"
    fi
}

# Main function to handle commands
if [ "$1" = "-o" ]; then
    case $2 in
        register)
            register_service "$4" "$6"
            ;;
        start)
            start_service "$4"
            ;;
        status)
            status_service "$4"
            ;;
        kill)
            stop_service "$4"
            ;;
        priority)
            change_priority "$4" "$6"
            ;;
        list)
            list_services
            ;;
        top)
            show_details "$4"
            ;;
        *)
            echo "Invalid operation: $2"
            ;;
    esac
else
    echo "Usage: $0 -o <operation> [arguments...]"
fi

