{
  flake.modules.homeManager.utilities = { pkgs, ... }: {
    home.packages = with pkgs; [
      fastfetch
      font-manager
      glib
      unzip
      unrar
      p7zip
      hmcl
      prismlauncher
      blockbench
      usbutils
      motrix
      libreoffice
      supergfxctl
      qq
    ];
  };
}
