{
  flake.modules.homeManager.zellij = {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      # attachExistingSession = true;
      exitShellOnExit = true;
      settings = {
        theme = "catppuccin-mocha";
      };
    };
  };
}
