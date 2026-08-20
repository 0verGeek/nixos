{
  flake.modules.homeManager.shell-zsh = {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = false;

        antidote = {
          enable = true;
          plugins = [
            "jeffreytse/zsh-vi-mode"
            "romkatv/zsh-bench kind:path"
            "mattmc3/ez-compinit"
            "zsh-users/zsh-completions kind:fpath path:src"
            "Aloxaf/fzf-tab"
            "zsh-users/zsh-history-substring-search"
            "zsh-users/zsh-autosuggestions"
            "zsh-users/zsh-syntax-highlighting"
          ];
        };
        shellAliases = {
          ll = "ls -l";
          la = "ls -la";
          update = "sudo nixos-rebuild switch";
        };

        history.size = 1000;
        history.ignoreAllDups = true;
      };
      starship = {
        enable = true;
        settings = {
          add_newline = false;
        };
      };
      zellij = {
        enable = true;
        enableZshIntegration = true;
        # attachExistingSession = true;
        exitShellOnExit = true;
        settings = {
          theme = "catppuccin-mocha";
        };
      };
    };
  };
}
