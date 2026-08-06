{
  flake.modules.nixos.network = { hostname, ... }: {
    networking.hostName = hostname;
    networking.networkmanager.enable = true;
    programs.mtr.enable = true;
  };
}
