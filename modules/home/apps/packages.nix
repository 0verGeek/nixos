{
  flake.modules.homeManager.packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      hugo
      font-manager
      fd
      ripgrep
      tree-sitter
      adw-gtk3
      nwg-look
      glib
    ];
  };
}
