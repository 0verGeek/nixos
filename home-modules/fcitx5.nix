{ pkgs, ... }: {
  # 直接把雾凇的数据整个链接到 rime 目录
  xdg.configFile."fcitx5/rime" = {
    source = "${pkgs.rime-ice}/share/rime-data";
    recursive = true;
    force = true; # 覆盖可能存在的旧配置
  };
}
