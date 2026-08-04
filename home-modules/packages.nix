{ pkgs, ... }: {
  home.packages = with pkgs; [
    hugo
    gearlever
    font-manager
    fd
    ripgrep
    tree-sitter
    adw-gtk3
    nwg-look
    glib
  ];
}
