{
  flake.modules.homeManager.dev-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      gnumake
      cmake
      rustup
      uv
      unzip
      nodejs
      lazygit
      python3
      # LSP
      nil
      nixd
      nixfmt
      statix
      pyright
      lua-language-server
    ];
  };
}
