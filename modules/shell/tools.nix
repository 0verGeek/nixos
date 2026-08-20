{
  flake.modules.homeManager.tools = { pkgs, ... }: {
    programs.eza.enable = true;
    programs.zoxide.enable = true;
    programs.fzf.enable = true;
    programs.bat.enable = true;
    home.packages = with pkgs; [
      fd
      ripgrep
    ];
  };
}
