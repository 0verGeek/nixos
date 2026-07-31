{ pkgs, ... }: {
  home.packages = with pkgs; [
    rust-analyzer
    nil
    nixd
    pyright
    clang-tools
  ];
}
