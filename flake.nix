{
  description = "Assorted R helpers, developed with nullkomma";

  inputs = {
    nullkomma.url = "git+file:///Users/max/GitHub/nullkomma/.worktrees/maxheld83-issue-113-adopt-configurable-flake-derivations-0a37c5?ref=maxheld83-nullkomma-composability-design-review&rev=f9cbc6f1dd8e49e32aa3438c67a3f586bf1b6d26";
    nixpkgs.follows = "nullkomma/nixpkgs";
    brand = {
      url = "git+file:///Users/max/GitHub/dataheld/brand?rev=a65dc58d240d0d97b4ff58fba36b0c288fabf00f";
      inputs.nullkomma.follows = "nullkomma";
    };
  };

  outputs =
    inputs:
    inputs.nullkomma.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.brand.flakeModules.privacy ];
      nullkomma.github.enable = false;
      nullkomma.gitignore = [ "/report/" ];
      nullkomma.r = {
        enable = true;
        pkgdown = {
          enable = true;
          config = {
            template.bslib.brand = inputs.brand.lib.brand;
            home.sidebar.html = "pkgdown/sidebar.html";
            footer = {
              structure.left = "brand";
              components.brand = builtins.replaceStrings [ "<footer " "</footer>" ] [ "<div " "</div>" ] (
                builtins.readFile inputs.brand.lib.footer
              );
            };
          };
          override = { };
        };
        check.errorOn = "note";
      };
      nullkomma.cloudflare = {
        enable = true;
        worker = "elf";
      };
      perSystem =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          nodeModules = pkgs.importNpmLock.buildNodeModules {
            npmRoot = ./.;
            nodejs = pkgs.nodejs;
          };
        in
        {
          treefmt.programs.actionlint.enable = true;
          checks.site-branding = pkgs.runCommand "elf-site-branding" { } ''
            site=${config.packages.site}
            grep -qF 'class="maxheld-footer"' "$site/index.html"
            grep -qF '🌲' "$site/index.html"
            grep -qF '·' "$site/index.html"
            grep -qF 'https://github.com/dataheld/elf/issues' "$site/index.html"
            grep -qF 'https://www.maxheld.de/imprint.html' "$site/index.html"
            grep -qF 'href="/privacy.html"' "$site/index.html"
            grep -qF '#453AA4' "$site"/deps/bootstrap-*/*.css
            grep -qF 'system-ui' "$site"/deps/bootstrap-*/*.css
            for section in controller your-rights verantwortlicher ihre-rechte; do
              grep -qF "id=\"$section\"" "$site/privacy.html"
            done
            grep -qF 'Cloudflare' "$site/privacy.html"
            for group in Dependencies Examples Options Tests; do
              grep -qF "$group" "$site/reference/index.html"
            done
            test -s "$site/reference/opt_set_local2.html"
            test -s "$site"/deps/headroom-*/headroom.min.js
            test -s "$site"/deps/bootstrap-*/bootstrap.bundle.min.js
            test -s "$site"/deps/bootstrap-*/bootstrap.bundle.min.js.map
            if grep -REoh '<script[^>]+src="https?://[^"]+"[^>]*>|<link[^>]+href="https?://[^"]+"[^>]*>' "$site" --include='*.html' |
              grep -vE 'rel="canonical"|https://elf\.maxheld\.de/'; then
              echo "Website resources must be same-origin" >&2
              exit 1
            fi
            touch "$out"
          '';
          nullkomma.tests = {
            r-testthat-installed.command = lib.mkBefore ''
              export SHINYTEST=true
            '';
            source-quality = {
              packages = [
                pkgs.gitleaks
                pkgs.nodejs
                pkgs.markdownlint-cli
                pkgs.yamllint
              ];
              command = ''
                gitleaks dir --no-banner --redact .
                node ${nodeModules}/node_modules/jscpd/bin/jscpd --silent --ignore '**/pkg.lock,**/flake.lock,**/package-lock.json' .
                markdownlint --dot --ignore 'tests/testthat/_snaps/**' .
                yamllint .
              '';
            };
          };
          nullkomma.tasks.secret-history = {
            description = "Scan Git history for secrets (local checkout only)";
            skip = true;
            packages = [ pkgs.gitleaks ];
            command = "gitleaks git --no-banner --redact .";
          };
        };
    };
}
