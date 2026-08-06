{
  flake.modules.homeManager.shell-tools = {
    programs.eza.enable = true;
    programs.zoxide.enable = true;
    programs.fzf.enable = true;
    programs.bat.enable = true;
  };
}
