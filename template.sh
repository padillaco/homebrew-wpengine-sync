#!/usr/bin/env bash

## Description: Sync the database and files from a specified WP Engine environment to the local DDEV environment. This script uses the `wpengine-sync` command-line tool to perform the synchronization.
## Usage: sync
## Example: "ddev sync --env=live"
## Flags: [{"Name":"env","Shorthand":"e","Usage":"The environment to pull from (\"dev\", \"test\", or \"live\")","Type":"string","DefValue":"live"},{"Name":"verbose","Shorthand":"v","Usage":"Enable verbose output","Type":"bool","DefValue":"0"}]

# --------------------------- SETUP INSTRUCTIONS ---------------------------

# Requirements:
#   - Docker: https://docs.docker.com/engine/install/
#   - DDEV: https://ddev.com/get-started/
#   - Homebrew: https://brew.sh/
#
# 1. Edit the configuration below to set the WP Engine site name, slug,
#    ID, environment URLs, and default environment to pull from.
#
# 2. Run `wpengine-sync --help` to see command usage, available flags,
#    and important notes. If `wpengine-sync` is not installed, running
#    `ddev sync`, as described below, will install it using Homebrew.
#
# 3. Run `ddev sync` to pull the database and files from the live WP Engine
#    environment into the local DDEV environment, or specify a different
#    environment using the `--env` flag (e.g., `ddev sync --env=dev`).

# ----------------------------- CONFIGURATION ------------------------------

# The name of the WP Engine site, which is used for identification
SITE_NAME=""
# The default WP Engine environment to pull from
ENV=""
# The WP Engine development site slug, which is the unique identifier for the site,
# which can be found in any WP Engine environment URL for the site
# e.g., https://liveenv.wpenginepowered.com
LIVE_ENV_SLUG=""
# The WP Engine test/staging site slug, which is the unique identifier for the site,
# which can be found in any WP Engine environment URL for the site
# e.g., https://liveenv.wpenginepowered.com
TEST_ENV_SLUG=""
# The WP Engine development site slug, which is the unique identifier for the site,
# which can be found in any WP Engine environment URL for the site
# e.g., https://devenv.wpenginepowered.com
DEV_ENV_SLUG=""
# The WP Engine live environment URL. Use a comma-separated
# list to specify multiple/alternative domains
LIVE_DOMAIN=""
# The WP Engine test environment URL. Use a comma-separated
# list to specify multiple/alternative domains
TEST_DOMAIN=""
# The WP Engine development environment URL. Use a comma-separated
# list to specify multiple/alternative domains
DEV_DOMAIN=""
# The DDEV domain for the local development environment
DDEV_DOMAIN=""
# Enables verbose output for debugging purposes
VERBOSE=0

# --------------------------- END CONFIGURATION ----------------------------

while [[ $# -gt 0 ]]; do
  case $1 in
    -e=*|--env=*)
      ENV="${1#*=}"
      shift
      ;;

    -v|--verbose)
      VERBOSE=1
      shift
      ;;

    -*|--*)
      echo -e "\033[0;31mUnknown option $1\033[0m"
      exit 0
      ;;

    *)
      shift # past argument
      ;;
  esac
done

# Check if Homebrew is installed
# If not, prompt the user to install it
if ! command -v brew >/dev/null 2>&1; then
  echo -e "\033[0;36mHomebrew is required to run this command. See https://brew.sh/ for installation instructions.\033[0m"
  exit 1
fi

# Check if wpengine-sync is installed
# If not, install it using Homebrew
if ! command -v wpengine-sync >/dev/null 2>&1; then
  echo -e "\033[0;33mwpengine-sync is required to run this command.\033[0m\n"
  echo "Installing wpengine-sync using Homebrew..."
  echo -e "\033[0;36m>\033[0m brew tap padillaco/formulas"
  echo -e "\033[0;36m>\033[0m brew install wpengine-sync\n"

  brew tap padillaco/formulas
  brew install wpengine-sync

  echo -e "\n"
  sleep 1
fi

# Run `wpengine-sync --help` to see command usage and available flags
wpengine-sync \
  --site-name="$SITE_NAME" \
  --env="$ENV" \
  --live-env-slug="$LIVE_ENV_SLUG" \
  --test-env-slug="$TEST_ENV_SLUG" \
  --dev-env-slug="$DEV_ENV_SLUG" \
  --live-domain="$LIVE_DOMAIN" \
  --test-domain="$TEST_DOMAIN" \
  --dev-domain="$DEV_DOMAIN" \
  --ddev-domain="$DDEV_DOMAIN" \
  --verbose=$VERBOSE
