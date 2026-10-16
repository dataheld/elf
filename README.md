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
