{
  description = "elf: Assorted R helpers";

  inputs = {
    nullkomma.url = "git+file:///Users/max/GitHub/nullkomma/.worktrees/maxheld83-issue-113-adopt-configurable-flake-derivations-0a37c5?ref=maxheld83-nullkomma-composability-design-review&rev=f40cb223558882777ac83c0c0d232801e4752be1";
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
      nullkomma.r-non-nix.enable = true;
      nullkomma.brand = inputs.brand;
      nullkomma.cloudflare = {
        enable = true;
        worker = "elf";
      };
    };
}
