#!/usr/bin/env python3

import json
import requests
import os
import sys
import subprocess


version_files = [
    "./src/drivers/hid-fanatecff/version.json"
]


# Function to get the latest release information from GitHub
def get_latest_tag(owner, repo):
    url = f'https://api.github.com/repos/{owner}/{repo}/tags'
    response = requests.get(url)
    if response.status_code == 200:
        tags = response.json()
        if tags:
            return tags[0]
    else:
        print(f"Error fetching latest release for {owner}/{repo}: {response.status_code} - {response.text}")
        return None


# Prefetch a tarball using the nix-prefetch-url command
def prefetch_tarball(tarball_url):
    command = ['nix-prefetch-url', '--unpack', tarball_url]
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return ""


# Function to update the JSON data for multiple files
def update_github_info(file_path):
    # Check if the file exists
    if not os.path.exists(file_path):
        print(f"File {file_path} does not exist.")
        return 1

    # Read the JSON file
    with open(file_path, 'r') as file:
        data = json.load(file)

    # Get the latest tag information
    latest_tag = get_latest_tag(data['owner'], data['repo'])

    if latest_tag:
        # Update the version and sha256 fields
        latest_version = latest_tag['name']
        latest_sha256 = prefetch_tarball(latest_tag['tarball_url'])

        if len(latest_version) > 0 and len(latest_sha256) > 0 and \
           (latest_version != data['version'] or latest_sha256 != data['sha256']):
            print(f"Repository {data['owner']}/{data['repo']} in {file_path} was updated")
            print(f"   Old values:  version={data['version']}, sha256={data['sha256']}")
            print(f"   New values:  version={latest_version}, sha256={latest_sha256}")

            # Update data
            data['version']=latest_version
            data['sha256']=latest_sha256

            # Save the JSON file
            with open(file_path, 'w') as file:
                json.dump(data, file, indent=4)
        else:
            print(f"Repository {data['owner']}/{data['repo']} in {file_path} unchanged")
            print(f"   Values:  version={data['version']}, sha256={data['sha256']}")
    else:
        print(f"Failed to update {data['owner']}/{data['repo']}.")
        return 2

    return 0


def main():
    for file_path in version_files:
        result = update_github_info(file_path)
        if result != 0 :
            sys.exit(result)


if __name__ == "__main__":
    main()
