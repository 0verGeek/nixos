{
  flake.modules.homeManager.utilities = { pkgs, ... }: {
    home.packages = with pkgs; [
      fastfetch
      font-manager
      glib
      libsecret
      unzip
    ];
  };
}
