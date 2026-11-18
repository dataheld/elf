{
  description = "elf: Assorted R helpers";

  inputs = {
    nullkomma.url = "https://flakehub.com/f/dataheld/nullkomma/*";
    nixpkgs.follows = "nullkomma/nixpkgs";
    maxheld = {
      url = "https://flakehub.com/f/dataheld/maxheld/*";
      inputs.nixpkgs.follows = "nixpkgs";
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
      nullkomma.brand = inputs.maxheld;
      nullkomma.cloudflareSite = {
        enable = true;
        domain = "maxheld.de";
        worker = "elf";
      };
    };
}
