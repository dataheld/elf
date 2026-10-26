{
  description = "elf: Assorted R helpers";

  inputs = {
    nullkomma.url = "https://flakehub.com/f/dataheld/nullkomma/*";
    nixpkgs.follows = "nullkomma/nixpkgs";
    brand = {
      url = "https://flakehub.com/f/dataheld/brand/*";
      # The brand flake's own CI config still uses nullkomma.github.ci.inputs.
    };
  };

  outputs =
    inputs:
    inputs.nullkomma.lib.mkFlake { inherit inputs; } {
      nullkomma.r = {
        enable = true;
        nonNix.enable = true;
        pkgdown.brand.enable = true;
      };
      nullkomma.brand = inputs.brand;
      nullkomma.cloudflare = {
        enable = true;
        domain = "maxheld.de";
        worker = "elf";
      };
    };
}
