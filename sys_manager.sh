#!/bin/bash

if [ "$1" == "add_users" ]; then
    if [ -z "$2" ]; then
        echo "Usage: ./sys_manager.sh add_users <usernames_file>"
        exit 1
    fi

    if [ ! -f "$2" ]; then
        echo "Error: File '$2' not found!"
        exit 1
    fi

    created=0
    exists=0

    while read -r username; do
        if [ -z "$username" ]; then
            continue
        fi

        if id "$username" &>/dev/null; then
            echo "User '$username' already exists."
            ((exists++))
        else
            useradd -m "$username"
            if [ $? -eq 0 ]; then
                echo "User '$username' created successfully."
                ((created++))
            else
                echo "Failed to create user '$username'."
            fi
        fi
    done < "$2"

    echo
    echo "Summary:"
    echo "Users created: $created"
    echo "Users already existed: $exists"

else
    echo "Invalid mode! Use: ./sys_manager.sh add_users <usernames_file>"
    exit 1
fi

