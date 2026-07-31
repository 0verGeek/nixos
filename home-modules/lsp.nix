# home-modules/lsp.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    rust-analyzer
    nil
    pyright
    clang-tools
  ];
}
