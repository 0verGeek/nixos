{
  flake.modules.homeManager.utilities = { pkgs, ... }: {
    home.packages = with pkgs; [
      fd
      ripgrep
      fastfetch
      font-manager
      glib
      libsecret
    ];
  };
}
