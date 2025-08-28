# WP Engine Sync (Bash Command)

Syncs the database and files from a specified WP Engine environment.

- [Installation and Updates](#installation-and-updates)
- [Command Example](#command-example)
- [Command Flags](#command-flags)
- [Note for Domain URLs](#note-for-domain-urls)
- [DDEV Command Setup](#ddev-command-setup)

## Installation and Updates

**Requirements:**
- Docker: https://docs.docker.com/engine/install/
- DDEV: https://ddev.com/get-started/
- Homebrew: https://brew.sh/

**Installation:**

```sh
$ brew tap padillaco/formulas
$ brew install wpengine-sync
```
**Updating to a newer version:**

```sh
$ wpengine-sync --update
```

## Command Example

```sh
$ wpengine-sync --site-name="Example Site" --env=live --live-env-slug=example-live --test-env-slug=example-test --dev-env-slug=example-dev --live-domain=example.com --test-domain=staging.example.com --dev-domain=dev.example.com --ddev-domain=example.ddev.site
```

## Command Flags

| Flag                | Description                                                                    |
|---------------------|--------------------------------------------------------------------------------|
| `--site-name`       | The name of the site on the WP Engine dashboard (e.g., "Example Site").        |
| `--env`             | The environment to pull from ("dev", "test", or "live").                       |
| `--live-env-slug`   | The live environment slug.                                                     |
| `--test-env-slug`   | The test/staging environment slug.                                             |
| `--dev-env-slug`    | The development environment slug.                                              |
| `--test-domain`     | One or more test/staging domains for the site. See the note below for details. |
| `--dev-domain`      | One or more development domains for the site. See the note below for details.  |
| `--ddev-domain`     | One or more DDEV domains for the site. See the note below for details.         |
| `--verbose`         | Enables verbose output for debugging purposes.                                 |
| `--version`         | Shows the version of the script.                                               |
| `--update`          | Updates the "wpengine-sync" homebrew formula.                                  |
| `--help`            | Shows command usage and available flags.                                       |

## Note for Domain URLs

1. To specify multiple domains for an environment, provide a comma-separated list of domains for that environment domain flag as shown below.

    **Example:**

    In this example, there are 3 different domains for a multisite on WP Engine (the default WP Engine environment URL, the main custom domain, and a subdomain). Each environment domain flag would contain the following domains as a comma-separated list:

    **Live**

    ```sh
    --live-domain=examplelive.wpenginepowered.com,example.com,blog.example.com
    ```
    **Test/Staging**
    ```sh
    --test-domain=exampletest.wpenginepowered.com,staging.example.com,staging.blog.example.com
    ```
    **Development**
    ```sh
    --dev-domain=exampledev.wpenginepowered.com,dev.example.com,dev.blog.example.com
    ```
    **DDEV**
    ```sh
    --ddev-domain=example.ddev.site,example.ddev.site,blog.example.ddev.site
    ```

2. The order of domains in each environment domain flag determines the mapping to the DDEV domain. The script will replace each environment domain found in the database with the corresponding DDEV domain.

## DDEV Command Setup

1. Copy the [template.sh](template.sh) file to `.ddev/commands/host/wpengine-sync.sh`.
2. In the **Configuration** section within the file, add the required values for each configuration setting.
3. Run `ddev sync` to sync the database and files from the **live** site, or specify an environment to sync from by running `ddev sync --env=(dev|test|live)`.

**Note:** Running `ddev sync` for the first time will install the `pantheon-sync` command from the set of available Homebrew formulas located at [https://github.com/padillaco/homebrew-formulas](https://github.com/padillaco/homebrew-formulas).
