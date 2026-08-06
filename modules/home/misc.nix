{
  flake.modules.homeManager.misc = { pkgs, ... }: {
    home.packages = with pkgs; [
      hugo
      font-manager
      fd
      ripgrep
      tree-sitter
      glib
    ];
  };
}
