#!/usr/bin/env bash

## Description: Sync the database and files from a specified WP Engine environment to the local DDEV environment. This script uses the `wpengine-sync` command-line tool to perform the synchronization.
## Usage: sync
## Example: "ddev sync --env=live --db"
## Flags: [{"Name":"env","Shorthand":"e","Usage":"The environment to pull from (\"dev\", \"test\", or \"live\")","Type":"string","DefValue":"live"},{"Name":"db","Usage":"Sync the database only","Type":"bool","DefValue":"0"},{"Name":"database","Usage":"Sync the database only (alias for --db)","Type":"bool","DefValue":"0"},{"Name":"files","Usage":"Sync the files only","Type":"bool","DefValue":"0"},{"Name":"ssh-identity","Shorthand":"i","Usage":"Path to an SSH identity file","Type":"string","DefValue":""},{"Name":"verbose","Shorthand":"v","Usage":"Enable verbose output","Type":"bool","DefValue":"0"}]

# ---------------------------- REQUIREMENTS & USAGE ----------------------------

# Requirements:
#   - Docker: https://docs.docker.com/engine/install/
#   - DDEV: https://ddev.com/get-started/
#   - Homebrew: https://brew.sh/
#
# 1. Set the website configuration values in the `wpengine-sync` command below.
#
# 2. Run `wpengine-sync --help` to see command usage, available flags,
#    and important notes.
#
# 3. Run `ddev sync` to sync the database and files from the default environment.
#    Use flags to customize the sync behavior:
#
#      --env=<env>   Pull from a specific environment: "dev", "test", or "live"
#                    e.g., `ddev sync --env=dev`
#      --db          Sync the database only
#                    e.g., `ddev sync --db`
#      --files       Sync the files only
#                    e.g., `ddev sync --files`
#      --verbose     Enable verbose output for debugging
#                    e.g., `ddev sync --verbose`

# ---------------------------- DEFAULT FLAG VALUES -----------------------------

ENV="live"
SYNC="all"
VERBOSE=0
SSH_IDENTITY=""

# -------------------------- WEBSITE CONFIGURATION ----------------------------

# The name of the WP Engine site, used for identification.
SITE_NAME=""

# Enable multisite mode. Set to 1 for WordPress multisite installs, 0 for standard installs.
MULTISITE=0

# The WP Engine live environment slug.
# e.g., "liveenv" if the URL is https://liveenv.wpenginepowered.com
LIVE_ENV_SLUG=""

# The WP Engine test/staging environment slug.
# e.g., "testenv" if the URL is https://testenv.wpenginepowered.com
TEST_ENV_SLUG=""

# The WP Engine development environment slug.
# e.g., "devenv" if the URL is https://devenv.wpenginepowered.com
DEV_ENV_SLUG=""

# Custom domains to search/replace for the live environment.
# Use a comma-separated list to specify multiple domains.
# Note: the WP Engine environment URL ({slug}.wpenginepowered.com) is auto-added.
LIVE_SOURCE_DOMAINS=""

# The replacement domains for the live environment (the local DDEV domains).
# Use a comma-separated list to match the order of LIVE_SOURCE_DOMAINS.
LIVE_REPLACEMENT_DOMAINS=""

# Custom domains for the test environment (optional, falls back to live domains if not set).
# Use a comma-separated list to specify multiple domains.
TEST_SOURCE_DOMAINS=""

# The replacement domains for the test environment (the local DDEV domains).
# Use a comma-separated list to match the order of TEST_SOURCE_DOMAINS.
TEST_REPLACEMENT_DOMAINS=""

# Custom domains for the dev environment (optional, falls back to live domains if not set).
# Use a comma-separated list to specify multiple domains.
DEV_SOURCE_DOMAINS=""

# The replacement domains for the dev environment (the local DDEV domains).
# Use a comma-separated list to match the order of DEV_SOURCE_DOMAINS.
DEV_REPLACEMENT_DOMAINS=""

# ------------------------------------------------------------------------------

for arg in "$@"; do
  case $arg in
    -e=*|--env=*)
      ENV="${arg#*=}"
      ;;

    --db|--database)
      SYNC="db"
      ;;

    --files)
      SYNC="files"
      ;;

    -i=*|--ssh-identity=*)
      SSH_IDENTITY="${arg#*=}"
      ;;

    -v|--verbose)
      VERBOSE=1
      ;;

    -*|--*)
      echo -e "\033[0;31mUnknown option $arg\033[0m"
      exit 1
      ;;
  esac
done

wpengine-sync \
  --site-name="$SITE_NAME" \
  --live-env-slug="$LIVE_ENV_SLUG" \
  --test-env-slug="$TEST_ENV_SLUG" \
  --dev-env-slug="$DEV_ENV_SLUG" \
  --live-source-domains="$LIVE_SOURCE_DOMAINS" \
  --live-replacement-domains="$LIVE_REPLACEMENT_DOMAINS" \
  --test-source-domains="$TEST_SOURCE_DOMAINS" \
  --test-replacement-domains="$TEST_REPLACEMENT_DOMAINS" \
  --dev-source-domains="$DEV_SOURCE_DOMAINS" \
  --dev-replacement-domains="$DEV_REPLACEMENT_DOMAINS" \
  --env="$ENV" \
  --multisite=$MULTISITE \
  --sync="$SYNC" \
  --ssh-identity="$SSH_IDENTITY" \
  --verbose=$VERBOSE
