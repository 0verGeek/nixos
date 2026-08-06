{
  flake.modules.homeManager.wezterm = { pkgs, inputs, ... }: {
    programs.wezterm = {
      enable = true;
      package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.wezterm;
      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = {
        color_scheme = "Catppuccin Mocha";
        font_size = 15.0;
        window_background_opacity = 0.9;
        text_background_opacity = 0.9;
        window_close_confirmation = "NeverPrompt";
        hide_tab_bar_if_only_one_tab = true;
      };
    };
  };
}
