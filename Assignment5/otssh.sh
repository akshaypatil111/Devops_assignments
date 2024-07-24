#!/bin/bash

# File to store SSH connection details
CONFIG_FILE="$HOME/.otssh_config"

# Function to add a new SSH connection
add_ssh_connection() {
    local name=$1
    local host=$2
    local user=$3
    local port=$4
    local key=$5

    if grep -q "^$name:" "$CONFIG_FILE"; then
        echo "[ERROR]: Connection with name '$name' already exists."
        exit 1
    fi

    echo "$name:$host:$user:$port:$key" >> "$CONFIG_FILE"
    echo "Connection '$name' added."
}

# Function to list SSH connections
list_ssh_connections() {
    if [ "$1" == "-d" ]; then
        while IFS=: read -r name host user port key; do
            if [ -z "$port" ] && [ -z "$key" ]; then
                echo "$name: ssh $user@$host"
            elif [ -z "$key" ]; then
                echo "$name: ssh -p $port $user@$host"
            else
                echo "$name: ssh -i $key -p $port $user@$host"
            fi
        done < "$CONFIG_FILE"
    else
        while IFS=: read -r name _; do
            echo "$name"
        done < "$CONFIG_FILE"
    fi
}

# Function to update an SSH connection
update_ssh_connection() {
    local name=$1
    local new_host=$2
    local new_user=$3
    local new_port=$4
    local new_key=$5

    if ! grep -q "^$name:" "$CONFIG_FILE"; then
        echo "[ERROR]: Connection with name '$name' does not exist."
        exit 1
    fi

    grep -v "^$name:" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "$name:$new_host:$new_user:$new_port:$new_key" >> "$CONFIG_FILE"
    echo "Connection '$name' updated."
}

# Function to delete an SSH connection
delete_ssh_connection() {
    local name=$1

    if ! grep -q "^$name:" "$CONFIG_FILE"; then
        echo "[ERROR]: Connection with name '$name' does not exist."
        exit 1
    fi

    grep -v "^$name:" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "Connection '$name' deleted."
}

# Function to connect to an SSH server
connect_to_server() {
    local name=$1

    if ! grep -q "^$name:" "$CONFIG_FILE"; then
        echo "[ERROR]: Server information is not available, please add server first."
        exit 1
    fi

    IFS=: read -r _ host user port key < <(grep "^$name:" "$CONFIG_FILE")

    if [ -z "$port" ] && [ -z "$key" ]; then
        ssh "$user@$host"
    elif [ -z "$key" ]; then
        ssh -p "$port" "$user@$host"
    else
        ssh -i "$key" -p "$port" "$user@$host"
    fi
}

# Ensure the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
fi

# Main command handling
case "$1" in
    -a)
        shift
        while getopts "n:h:u:p:i:" opt; do
            case "$opt" in
                n) name=$OPTARG ;;
                h) host=$OPTARG ;;
                u) user=$OPTARG ;;
                p) port=$OPTARG ;;
                i) key=$OPTARG ;;
                *) echo "Invalid option"; exit 1 ;;
            esac
        done
        add_ssh_connection "$name" "$host" "$user" "$port" "$key"
        ;;
    ls)
        list_ssh_connections "$2"
        ;;
    -u)
        shift
        while getopts "n:h:u:p:i:" opt; do
            case "$opt" in
                n) name=$OPTARG ;;
                h) new_host=$OPTARG ;;
                u) new_user=$OPTARG ;;
                p) new_port=$OPTARG ;;
                i) new_key=$OPTARG ;;
                *) echo "Invalid option"; exit 1 ;;
            esac
        done
        update_ssh_connection "$name" "$new_host" "$new_user" "$new_port" "$new_key"
        ;;
    rm)
        delete_ssh_connection "$2"
        ;;
    *)
        connect_to_server "$1"
        ;;
esac

