{
  flake.modules.nixos.dae = { pkgs, ... }: {
    services.dae = {
      enable = true;
      configFile = "/etc/dae/config.dae";
    };
  };
}
