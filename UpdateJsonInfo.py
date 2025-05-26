#!/usr/bin/env python3

import json
import requests
import os
import subprocess
import logging


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
        logging.error(f"Cannot fetch {owner}/{repo}: ERROR {response.status_code}")
    return None


# Nix-prefetch-url command
def nix_prefetch_url(tarball_url):
    command = ['nix-prefetch-url', '--unpack', tarball_url]
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        logging.error(f"nix-prefetch-url --unpack {tarball_url} failed")
        return None


# Update json information
def update_json_info(file_path):
    # Check if the file exists
    if not os.path.exists(file_path):
        raise Exception(f"File {file_path} does not exist")

    # Read the JSON file
    with open(file_path, 'r') as file:
        data = json.load(file)

    # Get the latest tag information
    logging.info(f"Retrieving lastest updates for {data['owner']}/{data['repo']}...")
    logging.debug(f"Current values: version={data['version']}, sha256={data['sha256']}")
    latest_tag = get_latest_tag(data['owner'], data['repo'])

    if latest_tag is None:
        raise Exception("Cannot retrieve latest tag")

    # Update the version and sha256 fields
    latest_version = latest_tag['name']
    latest_sha256 = nix_prefetch_url(latest_tag['tarball_url'])

    if latest_version is None or latest_sha256 is None:
        raise Exception("Cannot retrieve data")

    logging.debug(f"New values: version={latest_version}, sha256={latest_sha256}")

    # Update JSON file if needed
    if (latest_version != data['version'] or latest_sha256 != data['sha256']): 
        logging.info(f"Updated {data['version']} -> {latest_version}")

        # Update data
        data['version']=latest_version
        data['sha256']=latest_sha256

        # Save the JSON file
        with open(file_path, 'w') as file:
            json.dump(data, file, indent=4)
    else:
        logging.info("Nothing to update")


def main():
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    for file_path in version_files:
        try:
            update_json_info(file_path)
        except Exception as e:
            logging.error(e)


if __name__ == "__main__":
    main()
