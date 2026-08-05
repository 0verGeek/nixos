{
  flake.modules.homeManager.wezterm = { pkgs, inputs, ... }: {
    programs.wezterm = {
      enable = true;
      package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.wezterm;
      enableBashIntegration = true; # 自动集成 shell
      enableZshIntegration = true;

      settings = {
        color_scheme = "Catppuccin Mocha";
        font_size = 15.0;
        window_background_opacity = 0.9; # types.attrsOf 里的 number
        text_background_opacity = 0.9;
        window_close_confirmation = "NeverPrompt"; # 字符串枚举值，写错 typo 会报错
        hide_tab_bar_if_only_one_tab = true;

      };
    };
  };
}
