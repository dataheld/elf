{
  description = "elf: Assorted R helpers";

  inputs = {
    nullkomma.url = "https://flakehub.com/f/dataheld/nullkomma/*";
    nixpkgs.follows = "nullkomma/nixpkgs";
    brand = {
      url = "https://flakehub.com/f/dataheld/brand/*";
      inputs.nullkomma.follows = "nullkomma";
    };
  };

  outputs =
    inputs:
    inputs.nullkomma.lib.mkFlake { inherit inputs; } {
      nullkomma.r-non-nix.enable = true;
      nullkomma.brand = inputs.brand;
      nullkomma.cloudflare = {
        enable = true;
        domain = "maxheld.de";
        worker = "elf";
      };
    };
}
