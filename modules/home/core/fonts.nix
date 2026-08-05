{
  flake.modules.homeManager.fonts = { pkgs, ... }: {
    # 用户级字体配置
    home.packages = with pkgs; [
      sarasa-gothic
      lxgw-wenkai-screen
      maple-mono.NF-CN
      nerd-fonts.jetbrains-mono
    ];
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Sarasa Fixed SC"
          "Noto Serif"
        ];
        sansSerif = [
          "Sarasa Fixed SC"
          "Noto Sans"
        ];
        monospace = [
          "Maple Mono NF CN"
          "JetBrainsMono Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
