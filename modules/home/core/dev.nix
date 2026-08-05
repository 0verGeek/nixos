{
  flake.modules.homeManager.dev = { pkgs, ... }: {
    home.packages = with pkgs; [
      gnumake
      cmake
      rustup
      uv
      unzip
      # LSP
      nil
      nixd
      pyright
      lua-language-server
    ];
  };
}
