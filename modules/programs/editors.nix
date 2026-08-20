{
  flake.modules.homeManager.editors = { pkgs, ... }: {
    home.packages = with pkgs; [
      vim
      neovim
      vscode
      zed-editor
      kdePackages.kate
      obsidian
    ];
  };
}
