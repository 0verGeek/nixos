{
  flake.modules.homeManager.wezterm = { pkgs, ... }: {
    programs.wezterm = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = {
        color_scheme = "Catppuccin Mocha";
        font_size = 15.0;
        window_background_opacity = 0.3;
        text_background_opacity = 0.5;
        window_close_confirmation = "NeverPrompt";
        hide_tab_bar_if_only_one_tab = true;
      };
    };
  };
}
