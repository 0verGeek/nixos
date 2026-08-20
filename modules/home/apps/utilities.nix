{
  flake.modules.homeManager.apps-utilities = { pkgs, ... }: {
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
