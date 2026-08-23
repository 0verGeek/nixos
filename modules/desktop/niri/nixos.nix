# 特性:niri(单一入口)。
# 主机只需 import 本模块(`self.modules.nixos.niri`),用户侧经
# home-manager NixOS 桥(`home-manager.users.camuss.imports`)自动注入,
# 不需要在 home 侧再引用一次。
{ self, ... }: {
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      # ── 系统侧 ──
      programs.niri.enable = true;
      # Fix dolphin menu
      environment.etc."xdg/menus/applications.menu".source =
        "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];
      # ── 用户侧(经桥注入 home.nix)──
      home-manager.users.camuss.imports = [ self.modules.homeManager.niri ];
    };
}
