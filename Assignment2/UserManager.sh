#!/bin/bash

function add_team {
    sudo groupadd "$1"
}

function add_user {
    sudo useradd -m -g "$2" -s /bin/bash "$1"
    
    if ! grep -q "^ninja:" /etc/group; then
        sudo groupadd ninja
    fi
    
    sudo usermod -aG ninja "$1"
    
    sudo mkdir -p /home/"$1"/{team,ninja}
    sudo chown -R "$1":"$2" /home/"$1"
    sudo chmod 751 /home/"$1"
    sudo chmod 770 /home/"$1"/team
    sudo chmod 770 /home/"$1"/ninja
}

function del_team {
    sudo groupdel "$1"
}

function del_user {
    sudo userdel -r "$1"
}

function change_password {
    sudo passwd "$1"
}

function change_shell {
    sudo usermod -s "$2" "$1"
}

function list_users {
    echo "Users:"
    awk -F: '/\/home/ {print $1}' /etc/passwd
}

function list_teams {
    echo "Teams:"
    awk -F: '{ print $1 }' /etc/group
}

case "$1" in
    addTeam)
        add_team "$2"
        ;;
    addUser)
        add_user "$2" "$3"
        ;;
    delTeam)
        # Check if the team exists and has any members
        if getent group "$2" &>/dev/null; then
            members=$(getent group "$2" | cut -d: -f4)
            if [ -z "$members" ]; then
                del_team "$2"
            else
                echo "Cannot delete team '$2': it has members."
            fi
        else
            echo "Team '$2' does not exist."
        fi
        ;;
    delUser)
        if id "$2" &>/dev/null; then
            del_user "$2"
        else
            echo "User '$2' does not exist."
        fi
        ;;
    changePasswd)
        if id "$2" &>/dev/null; then
            change_password "$2"
        else
            echo "User '$2' does not exist."
        fi
        ;;
    changeShell)
        if id "$2" &>/dev/null; then
            change_shell "$2" "$3"
        else
            echo "User '$2' does not exist."
        fi
        ;;
    ls)
        if [ "$2" == "User" ]; then
            list_users
        elif [ "$2" == "Team" ]; then
            list_teams
        else
            echo "Invalid option for ls. Use 'User' or 'Team'."
        fi
        ;;
    *)
        echo "Invalid command"
        ;;
esac

