{
  description = "elf: Assorted R helpers";

  inputs = {
    nullkomma.url = "git+file:///Users/max/GitHub/nullkomma/.worktrees/maxheld83-issue-113-adopt-configurable-flake-derivations-0a37c5?ref=maxheld83-nullkomma-composability-design-review&rev=1673ff14b7f17c33a8ddaca5aadaa8b5e5f01878";
    nixpkgs.follows = "nullkomma/nixpkgs";
    brand = {
      url = "https://flakehub.com/f/dataheld/brand/0.1.2.tar.gz";
      inputs.nullkomma.follows = "nullkomma";
    };
  };

  outputs =
    inputs:
    inputs.nullkomma.lib.mkFlake { inherit inputs; } {
      nullkomma.github.enable = false;
      nullkomma.gitignore = [ "/report/" ];
      nullkomma.r = {
        enable = true;
        lintr.enable = true;
        pkgdown = {
          enable = true;
          brand = inputs.brand;
        };
        check.errorOn = "note";
      };
      nullkomma.cloudflare = {
        enable = true;
        worker = "elf";
      };
      perSystem =
        {
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
          treefmt.programs.markdownlint-cli2.excludes = [ "tests/testthat/_snaps/**" ];
          nullkomma.tests = {
            r-testthat-installed.command = lib.mkBefore ''
              export SHINYTEST=true
            '';
            source-quality = {
              packages = [ pkgs.nodejs ];
              command = ''
                node ${nodeModules}/node_modules/jscpd/bin/jscpd --silent --ignore '**/pkg.lock,**/flake.lock,**/package-lock.json' .
              '';
            };
          };
        };
    };
}
