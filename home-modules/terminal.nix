{ pkgs, pkgsUnstable, ... }: {
  programs.wezterm = {
    enable = true;
    package = pkgsUnstable.wezterm;
    enableBashIntegration = true;  # 自动集成 shell
    enableZshIntegration = true;

    settings = {
      color_scheme = "Catppuccin Mocha";
      font_size = 16.0;
      window_background_opacity = 0.9;          # types.attrsOf 里的 number
      window_close_confirmation = "NeverPrompt"; # 字符串枚举值，写错 typo 会报错
    };
  }
}
