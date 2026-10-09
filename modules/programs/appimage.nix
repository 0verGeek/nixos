{
  flake.modules.nixos.appimage = { pkgs, ... }: {
    programs.appimage = {
      enable = true;
      binfmt = true;
      # 部分 AppImage(例如用 Tauri 打包的应用)会在运行时 dlopen
      # libayatana-appindicator3.so.1 用于系统托盘;该库不会被 AppImage 打包,
      # 缺失时进程直接 panic 退出,故显式注入 FHS 环境。
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.libayatana-appindicator
          # 备用实现,libayatana-appindicator 加载失败时的回退
          pkgs.libappindicator-gtk3
        ];
      };
    };
  };
}
