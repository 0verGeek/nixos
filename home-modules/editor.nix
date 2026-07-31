{ pkgs, ... }: {
  home.packages = with pkgs; [
    # 从 systemPackages 移过来的用户工具
    vim
    neovim
    vscode
    zed-editor
    kdePackages.kate
  ];
}
