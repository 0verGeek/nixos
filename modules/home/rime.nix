{
  flake.modules.homeManager.rime = {
    xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
      patch:
        __include: rime_ice_suggestion:/
    '';
  };
}
