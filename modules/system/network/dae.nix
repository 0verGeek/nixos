{ inputs, ... }: {
  flake.modules.nixos.dae = { pkgs, ... }: {
    services.dae = {
      enable = true;
      package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.dae;
      configFile = "/etc/dae/config.dae";
    };
  };
}
