{
  flake.modules.homeManager.lsp = { pkgs, ... }: {
    home.packages = with pkgs; [
      # LSP / 语言分析工具
      nil
      nixd
      nixfmt
      statix
      pyright
      lua-language-server
      tree-sitter
    ];
  };
}
