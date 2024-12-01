#!/bin/bash

# File Description:
# This script interacts with the GitHub API to list and delete untagged versions of a Docker container package.
# It fetches all versions of a specified container package, filters out the untagged versions, and then deletes them
# after user confirmation. It also counts and displays the total number of untagged versions before deletion.

# Prerequisites:
# 1. A GitHub Personal Access Token with the necessary permissions to delete container images in the specified package. write:pakagaes and read.packages permissions.
# 2. jq command-line tool must be installed to process the JSON response from the GitHub API.
# 3. The script requires the owner and package name of the GitHub container registry to be set correctly.
# 4. The GitHub API endpoint should be accessible and the user should have permission to delete the images.

# Set your GitHub Token
GITHUB_TOKEN="Put_your_PAT_here"
OWNER="your_username"
PACKAGE_NAME="your_packages"

# Fetch all untagged versions and display their IDs
echo "Fetching all untagged versions of $PACKAGE_NAME..."

# Fetch versions and print out the version IDs that are untagged
VERSION_IDS=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github+json" \
     "https://api.github.com/users/$OWNER/packages/container/$PACKAGE_NAME/versions" | \
     jq -r '.[] | select(.metadata.container.tags | length == 0) | .id')

# If no untagged versions are found
if [ -z "$VERSION_IDS" ]; then
  echo "No untagged versions found."
  exit 0
fi

# Show the list of untagged version IDs
echo "The following untagged versions will be deleted:"
echo "$VERSION_IDS"

# Count the number of untagged versions
TOTAL_COUNT=$(echo "$VERSION_IDS" | wc -l)

# Print the total count
echo "Total number of untagged images are: $TOTAL_COUNT"

# Ask the user for confirmation
echo "Do you want to proceed with deleting these versions? (y/n)"
read confirmation

if [ "$confirmation" == "y" ]; then
  # Loop through each version ID and delete it
  for VERSION_ID in $VERSION_IDS; do
    echo "Deleting untagged version with ID: $VERSION_ID"
    
    # Delete the untagged version
    curl -X DELETE \
         -H "Authorization: Bearer $GITHUB_TOKEN" \
         -H "Accept: application/vnd.github+json" \
         "https://api.github.com/users/$OWNER/packages/container/$PACKAGE_NAME/versions/$VERSION_ID"
    
    echo "Deleted version ID: $VERSION_ID"
  done
else
  echo "Deletion canceled."
fi


#################Extraaaaaa code, for future reference#############
# jq -r '.[] | select(.metadata.container.tags | length == 0) | {id: .id, sha: .metadata.container.digest, name: .name, tags: .metadata.container.tags}'
