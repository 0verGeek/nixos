{ ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = false;

    antidote = {
      enable = true;
      plugins = [
        "jeffreytse/zsh-vi-mode"
        ""
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        # "ohmyzsh/ohmyzsh path:lib/git.zsh"
        # "ohmyzsh/ohmyzsh path:plugins/extract"
      ];
    };
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      update = "sudo nixos-rebuild switch";
    };

    history.size = 1000;
    history.ignoreAllDups = true;

    # initExtraFirst = ''
    #   zmodload zsh/zprof
    # '';
    # initExtra = ''
    #   zprof
    # '';
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  # shell 工具可以直接在 programs 里声明式配置
  programs.eza.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
}
