{ config, pkgs, ... }:

{
  home.username = "camuss";
  home.homeDirectory = "/home/camuss";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # 在这里添加你的包、程序配置...
  home.packages = with pkgs; [ ];
}
