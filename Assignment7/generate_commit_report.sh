#!/bin/bash

# Function to fetch commits and generate the report in CSV format
generate_csv_report() {
    local repo_url=$1
    local days=$2
    local output_file="commit_report.csv"

    # Clone the repository using PAT for authentication
    git clone "git@github.com:akshaypatil111/Mygurukulam_devops.git" repo_temp
    cd repo_temp || exit

    # Get the commits within the specified number of days
    git log --since="${days} days ago" --pretty=format:'%H,%an,%ae,"%s"' --name-only | \
    awk '
    BEGIN {
        FS = ","
        OFS = ","
        print "Commit ID", "Author Name", "Author Email", "Commit Message", "Changed Files"
    }
    {
        if (NR % 2 == 1) {
            commit_id = $1
            author_name = $2
            author_email = $3
            commit_message = $4
        } else {
            print commit_id, author_name, author_email, commit_message, $0
        }
    }' > "$output_file"

    cd ..
    rm -rf repo_temp
}

# Function to fetch commits and generate the report in HTML format
generate_html_report() {
    local repo_url=$1
    local days=$2
    local output_file="commit_report.html"

    # Clone the repository using PAT for authentication
    git clone "git@github.com:akshaypatil111/Mygurukulam_devops.git" repo_temp
    cd repo_temp || exit

    # Create HTML report
    {
        echo "<html>"
        echo "<head><title>Commit Report</title></head>"
        echo "<body>"
        echo "<h1>Commit Report</h1>"
        echo "<table border='1'>"
        echo "<tr><th>Commit ID</th><th>Author Name</th><th>Author Email</th><th>Commit Message</th><th>Changed Files</th></tr>"

        git log --since="${days} days ago" --pretty=format:'%H,%an,%ae,"%s"' --name-only | \
        awk '
        BEGIN {
            FS = ","
        }
        {
            if (NR % 2 == 1) {
                commit_id = $1
                author_name = $2
                author_email = $3
                commit_message = $4
                files = ""
            } else {
                files = files $0 "<br>"
                print "<tr><td>" commit_id "</td><td>" author_name "</td><td>" author_email "</td><td>" commit_message "</td><td>" files "</td></tr>"
            }
        }'
        
        echo "</table>"
        echo "</body>"
        echo "</html>"
    } > "$output_file"

    cd ..
    rm -rf repo_temp
}

# Parse command-line arguments
while getopts "u:d:f:" opt; do
    case $opt in
        u )
            repo_url=$OPTARG
            ;;
        d )
            days=$OPTARG
            ;;
        f )
            format=$OPTARG
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" >&2
            exit 1
            ;;
    esac
done

# Check if required arguments are provided
if [ -z "git@github.com:akshaypatil111/Mygurukulam_devops.git" ] || [ -z "$days" ] || [ -z "$format" ]; then
    echo "Usage: $0 -u <repo_url> -d <days> -f <format (csv|html)>"
    exit 1
fi

# Add PAT to repo URL
# Prompt user for the PAT securely
echo -n " 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 "
read -s token

# Replace `username` with your GitHub username
repo_url=$(echo "git@github.com:akshaypatil111/Mygurukulam_devops.git" | sed "s|https://|https://akshaypatil111:${token}@|")

# Generate report based on the chosen format
case $format in
    csv)
        generate_csv_report "$repo_url" "$days"
        ;;
    html)
        generate_html_report "$repo_url" "$days"
        ;;
    *)
        echo "Invalid format: $format. Use 'csv' or 'html'."
        exit 1
        ;;
esac

echo "Report generated in ${format} format."
