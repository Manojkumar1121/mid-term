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
sys_report() {
    local output_file="$1"

    # Validate argument
    if [[ -z "$output_file" ]]; then
        echo -e "\e[31m[Error]\e[0m Usage: $0 sys_report <output_file>"
        exit 1
    fi

    # Try to create or overwrite the output file
    if ! touch "$output_file" 2>/dev/null; then
        echo -e "\e[31m[Error]\e[0m Cannot write to $output_file"
        exit 1
    fi

    {
        echo "===== System Monitoring Report ====="
        echo "Generated on: $(date)"
        echo ""

        echo "== Disk Usage =="
        df -h
        echo ""

        echo "== Memory Info =="
        free -h
        echo ""

        echo "== CPU Info =="
        lscpu | grep -E 'Architecture|Model name|CPU\(s\)|Thread|Core|Socket|Vendor ID|CPU MHz'
        echo ""

        echo "== Top 5 Memory-consuming Processes =="
        ps aux --sort=-%mem | head -n 6
        echo ""

        echo "== Top 5 CPU-consuming Processes =="
        ps aux --sort=-%cpu | head -n 6
        echo ""

    } > "$output_file"

    echo -e "\e[32m[Success]\e[0m System report saved to $output_file"
}



