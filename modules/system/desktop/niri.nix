{
  flake.modules.nixos.niri = { pkgs, ... }: {
    # Enable niri
    programs.niri.enable = true;
    # Fix dolphin menu
    environment.etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  };
}
