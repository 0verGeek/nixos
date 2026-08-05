{
  flake.modules.nixos.xdg = { pkgs, ... }: {
    xdg.portal = {
      enable = true;
      wlr.enable = false; # niri 不用 wlr 那套
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };
  };
}
