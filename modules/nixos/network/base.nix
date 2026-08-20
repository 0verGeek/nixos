{
  flake.modules.nixos.network-base = { hostname, ... }: {
    networking.hostName = hostname;
    networking.networkmanager.enable = true;
    programs.mtr.enable = true;
  };
}
