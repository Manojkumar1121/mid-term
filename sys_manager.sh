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
### task - 2

if [ "$1" == "setup_projects" ]; then
    if [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: ./sys_manager.sh setup_projects <username> <number_of_projects>"
        exit 1
    fi

    username="$2"
    num_projects="$3"
    base_dir="/home/$username/projects"

    if ! id "$username" &>/dev/null; then
        echo "Error: User '$username' does not exist."
        exit 1
    fi

    mkdir -p "$base_dir"

    for ((i=1; i<=num_projects; i++)); do
        project_dir="$base_dir/project$i"
        mkdir -p "$project_dir"
        readme_file="$project_dir/README.txt"
        echo "Project: project$i" > "$readme_file"
        echo "Created by: $username" >> "$readme_file"
        echo "Date: $(date)" >> "$readme_file"
        chmod 755 "$project_dir"
        chmod 640 "$readme_file"
        chown -R "$username:$username" "$project_dir"
    done

    echo "Created $num_projects projects for user '$username' in $base_dir"

else
    echo "Invalid mode! Use: ./sys_manager.sh setup_projects <username> <number_of_projects>"
    exit 1
fi
###task - 3
if [ "$1" == "setup_projects" ]; then
    if [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: ./sys_manager.sh setup_projects <username> <number_of_projects>"
        exit 1
    fi

    username="$2"
    num_projects="$3"
    base_dir="/home/$username/projects"

    if ! id "$username" &>/dev/null; then
        echo "Error: User '$username' does not exist."
        exit 1
    fi

    mkdir -p "$base_dir"

    for ((i=1; i<=num_projects; i++)); do
        project_dir="$base_dir/project$i"
        mkdir -p "$project_dir"
        readme_file="$project_dir/README.txt"
        echo "Project: project$i" > "$readme_file"
        echo "Created by: $username" >> "$readme_file"
        echo "Date: $(date)" >> "$readme_file"
        chmod 755 "$project_dir"
        chmod 640 "$readme_file"
        chown -R "$username:$username" "$project_dir"
    done

    echo "Created $num_projects projects for user '$username' in $base_dir"

else
    echo "Invalid mode! Use: ./sys_manager.sh setup_projects <username> <number_of_projects>"
    exit 1
fi

