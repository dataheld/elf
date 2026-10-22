{
  description = "elf: Assorted R helpers";

  inputs = {
    nullkomma.url = "https://flakehub.com/f/dataheld/nullkomma/0.1.405.tar.gz";
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
