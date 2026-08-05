{
  flake.modules.nixos.fcitx5 = { pkgs, ... }: {
    #Config inputmethod
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        qt6Packages.fcitx5-configtool
        qt6Packages.fcitx5-chinese-addons
        (fcitx5-rime.override {
          rimeDataPkgs = [
            pkgs.rime-wanxiang
          ];
        }) # 注入词库
      ];
    };
  };
}
