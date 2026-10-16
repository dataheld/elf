# elf

## Overview

elf is a fairly random collection of R helpers I like to use.

## Installation

```r
# install.packages("pak")
pak::pak("dataheld/elf")
```

## Development

Development uses [nullkomma](https://github.com/dataheld/nullkomma)'s core
Nix R environment, without its non-Nix R plugin. Install Nix, then run:

```sh
# Required once on a fresh checkout, or after changing DESCRIPTION:
nix run .#r-lock
nix develop
r-document
r-test
r-test-installed
r-lint
r-check
nix build .#site
nix flake check
```

`nix fmt` runs Air and the shared non-R formatters/checkers, including
workflow validation. `test-source-quality` retains secret scanning, duplicate
code detection, Markdown and YAML checks. `secret-history` additionally scans
the local Git history; it is separate because Nix check sandboxes have no Git
history. Installed-package tests retain `SHINYTEST=true`; R CMD check fails on
notes, and development tests still fail on warnings.

The replacement GitHub workflow is **manual-only**: commits and pull requests
never start it. It needs a `NULLKOMMA_INPUTS_READ_TOKEN` Actions secret with
read access to the pinned nullkomma and brand repositories. It checks, but
never deploys. Keep it undispatched until CI is explicitly wanted.

`DESCRIPTION` declares dependencies; commit `pkg.lock` after refreshing it.
`flake.lock` pins the R interpreter and Nixpkgs package recipes and versions.
The pak lockfile records dependency resolution, not the versions installed by
Nix. No project R startup files or mutable package library are required.

During this migration, `flake.nix` deliberately references the local nullkomma
R-support worktree and local brand repository, pinned to committed revisions.
Other machines must supply those repositories at the recorded paths or override
the inputs with Git URLs at the same revisions. This does not depend on a
FlakeHub release of nullkomma.

## Website and publishing

The website keeps the existing pkgdown reference groups. Its design and legal
footer come from the pinned [dataheld/brand](https://github.com/dataheld/brand)
input; shared privacy sections include the controller, rights and Cloudflare
hosting information. `nix build .#site` produces `result/`, while `r-pkgdown`
builds a preview in the Git-ignored `docs/` directory. The project-owned
`pkgdown/sidebar.html` retains source, issues, license, citation and author links
without pkgdown's network-dependent CRAN lookup.

Publishing uses nullkomma's Cloudflare **Workers static assets** integration,
not the former Pages project. The Worker is named `elf`. No deployment or
production cutover is part of this migration. Before publishing:

1. Supply `CLOUDFLARE_ACCOUNT_ID`, `CLOUDFLARE_STATE_BUCKET`,
   `CLOUDFLARE_API_TOKEN`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
   through your credentials manager, not tracked files. The AWS-named values
   authenticate to the Cloudflare R2 Terraform-state bucket.
1. Add `nullkomma.cloudflare.domains."elf.maxheld.de" = "<zone ID>";` to
   `flake.nix`, replacing the placeholder with the 32-character `maxheld.de`
   Cloudflare zone ID. Domains are deliberately unset until this cutover is
   explicitly approved; the Worker otherwise has no public route.
1. Remove the old Pages hostname association when ready, then run `terraform`
   in `nix develop` to inspect the plan. Only run `deploy` after approving the
   hostname/state changes. Neither command is run by the manual check workflow.
