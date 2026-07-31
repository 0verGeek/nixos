{ config, pkgs, ... }:

{
  home.username = "camuss";
  home.homeDirectory = "/home/camuss";
  home.stateVersion = "26.05"
  imports = [
      ./home-modules    # 自动读 default.nix，一次性导入所有子模块
  ];
  programs.home-manager.enable = true;
}
