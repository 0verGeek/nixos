{
  flake.modules.homeManager.utilities = { pkgs, ... }: {
    home.packages = with pkgs; [
      fastfetch
      font-manager
      glib
      unzip
      prismlauncher
      blockbench
      usbutils
    ];
  };
}
