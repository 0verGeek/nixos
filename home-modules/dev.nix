{ pkgs, ... }: {
  home.packages = with pkgs; [

    cmake
    rustup
    uv

    # LSP
    nil
    nixd
    pyright
  ];
}
