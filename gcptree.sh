#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <ORGANIZATION_ID or FOLDER_ID> [-v]"
    exit 1
fi

STARTING_ID=$1
VERBOSE=false

# Check for the verbose flag as the last argument
if [[ "${@: -1}" == "-v" ]]; then
    VERBOSE=true
    # Remove the verbose flag from the arguments
    set -- "${@:1:$(($#-1))}"
fi

# Function to determine the type of the starting ID (organization or folder)
function get_resource_id() {
    # Check if it's an organization
    ORG_CHECK=$(gcloud organizations list --filter="name:organizations/$STARTING_ID" --format="value(displayName)" 2>/dev/null)
    if [[ -n "$ORG_CHECK" ]]; then
        echo "organizations/$STARTING_ID"
        return
    fi

    # Check if it's a folder
    FOLDER_CHECK=$(gcloud resource-manager folders describe $STARTING_ID --format="value(name)" 2>/dev/null)
    if [[ -n "$FOLDER_CHECK" ]]; then
        echo "folders/$STARTING_ID"
        return
    fi

    # If neither, exit with an error
    echo "Error: Invalid ID. Not an organization or folder."
    exit 1
}

# Determine the starting resource type
SCOPE=$(get_resource_id)

function print_tree() {
    local LEVEL
    let "LEVEL = $2 + 1"
    # FOLDERS
    if [[ "$5" == *organization* ]]; then
        # PARENT=ORGANIZATION
        RESULT=$(echo "$1" | jq -r \
            '.[] 
            | select(.id | test("folders")) 
            | select(.parentType | test("Organization")) 
            | [.displayName, .id] 
            | @csv' | sort)
    else
        # PARENT=FOLDERS
        RESULT=$(echo "$1" | jq -r --argjson LEVEL $LEVEL \
            '.[] 
            | select(.id | test("folders")) 
            | select(.parents | length == $LEVEL) 
            | [.displayName, .id, (.parents | join(";"))] 
            | @csv' | grep $4 | sort)
    fi
   
    if [[ ! -z "$RESULT" ]]; then
        # Count the total number of lines in RESULT
        total_lines=$(echo "$RESULT" | wc -l)
        current_line=0
        # Loop over each result and process
        while IFS= read -r line; do
            # Increment the current line counter
            ((current_line++))
            # Split CSV into individual fields
            IFS=',' read -r displayName id parents <<< "$line"
            NAME=$(echo $displayName | tr -d '"')
            ID=$(basename $id | tr -d '"')

            # Check if this is the last iteration
            if [[ $current_line -eq $total_lines ]]; then
                if [ "$VERBOSE" = true ]; then
                    echo "$3└── 📁 ${NAME} (${ID})"
                else
                    echo "$3└── 📁 ${NAME}"
                fi
                # Recurse for child folders
                print_tree "$1" $LEVEL "$3    " "$ID" "folder"
            else
                if [ "$VERBOSE" = true ]; then
                    echo "$3├── 📁 ${NAME} (${ID})"
                else
                    echo "$3├── 📁 ${NAME}"
                fi
                # Recurse for child folders
                print_tree "$1" $LEVEL "$3│   " "$ID" "folder"
            fi
        done <<< "$RESULT"
    fi

    # PROJECTS
    if [[ "$5" == *organization* ]]; then
        # PARENT=ORGANIZATION
        RESULT=$(echo "$1" | jq -r \
            '.[] 
            | select(.id | test("projects")) 
            | select(.parentType | test("Organization")) 
            | [.displayName, .id] 
            | @csv' | sort)
    else
        # PARENT=FOLDERS
        RESULT=$(echo "$1" | jq -r --argjson LEVEL $2 \
            '.[] 
            | select(.id | test("projects"))  
            | select(.parents | length == $LEVEL) 
            | [.displayName, .id, (.parents | join(";"))] 
            | @csv' | grep $4 | sort)
    fi
    if [[ ! -z "$RESULT" ]]; then
        # Count the total number of lines in RESULT
        total_lines=$(echo "$RESULT" | wc -l)
        current_line=0
        # Loop over each result and process
        while IFS= read -r line; do
            # Increment the current line counter
            ((current_line++))
            # Split CSV into individual fields
            IFS=',' read -r displayName id parents <<< "$line"
            NAME=$(echo $displayName | tr -d '"')
            ID=$(basename $id | tr -d '"')

            # Check if this is the last iteration
            if [[ $current_line -eq $total_lines ]]; then
                if [ "$VERBOSE" = true ]; then
                    echo "$3└── 📦 ${NAME} (${ID})"
                else
                    echo "$3└── 📦 ${NAME}"
                fi
            else
                if [ "$VERBOSE" = true ]; then
                    echo "$3├── 📦 ${NAME} (${ID})"
                else
                    echo "$3├── 📦 ${NAME}"
                fi
            fi
        done <<< "$RESULT"
    fi
}

# Function to fetch all resources using the Asset Inventory API
function fetch_hierarchy() {
    PARENT=$1
    PARENT_TYPE=$2

    # Fetch all resources under the parent
    ASSETS=$(gcloud asset search-all-resources \
        --scope="$PARENT" \
        --asset-types="cloudresourcemanager.googleapis.com/Folder,cloudresourcemanager.googleapis.com/Project,cloudresourcemanager.googleapis.com/Organization" \
        --format=json 2>/dev/null)

    if [[ -z "$ASSETS" ]]; then
        echo "No resources found under $PARENT"
        return
    fi

    ASSET_DATA=$(echo $ASSETS |  jq '[.[] | select(.state == "ACTIVE") | {id: .name, parents: .folders, displayName: .displayName, parentType: .parentAssetType}]')

    # Find the minimum number of parents
    LEVEL=$(echo "$ASSET_DATA" | jq '[.[] | .parents | length] | min')

    print_tree "$ASSET_DATA" $LEVEL "" "$STARTING_ID" "$PARENT_TYPE"

}

# Start fetching the hierarchy
echo""
echo "Google Cloud Resource Tree"
echo""
if [[ "$SCOPE" == organizations/* ]]; then
    ORG_NAME=$(gcloud organizations describe $STARTING_ID --format="value(displayName)")
    echo "🌐 $ORG_NAME ($STARTING_ID)"
    fetch_hierarchy "$SCOPE" "organization"
elif [[ "$SCOPE" == folders/* ]]; then
    FOLDER_NAME=$(gcloud resource-manager folders describe $STARTING_ID --format="value(displayName)")
    echo "📁 $FOLDER_NAME ($STARTING_ID)"
    fetch_hierarchy "$SCOPE" "folder"
fi