{
  description = "Assorted R helpers, developed with nullkomma";

  inputs = {
    nullkomma.url = "git+file:///Users/max/GitHub/nullkomma/.worktrees/maxheld83-issue-113-adopt-configurable-flake-derivations-0a37c5?ref=maxheld83-nullkomma-composability-design-review&rev=beb33b0e3b7fbc3f7219b7f83cdaf4ae8e6652a5";
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
      nullkomma.r = {
        enable = true;
        pkgdown.enable = true;
        check.errorOn = "note";
      };
      nullkomma.cloudflare = {
        enable = true;
        worker = "elf";
      };
    };
}
