{
  flake.modules.homeManager.editors = { pkgs, ... }: {
    home.packages = with pkgs; [
      vim
      neovim
      neovide
      vscode
      zed-editor
      kdePackages.kate
      obsidian
    ];
  };
}
