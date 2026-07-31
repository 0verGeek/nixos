{ pkgs, ... }: {
  programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # 用 Antidote 替代 oh-my-zsh
      antidote = {
        enable = true;
        plugins = [
          "zsh-users/zsh-autosuggestions"
          "zsh-users/zsh-syntax-highlighting"
          "ohmyzsh/ohmyzsh path:lib/git.zsh"
          "ohmyzsh/ohmyzsh path:plugins/docker"
          "ohmyzsh/ohmyzsh path:plugins/extract"
        ];
      };
      shellAliases = {
            ll = "ls -l";
            la = "ls -la";
            update = "sudo nixos-rebuild switch";
          };

          history.size = 10000;
          history.ignoreAllDups = true;
        initExtra = ''
              # Starship prompt
              eval "$(starship init zsh)"
            '';
      };
      programs.starship = {
          enable = true;
          settings = {
            add_newline = false;
            };
          };
        };

  # shell 工具可以直接在 programs 里声明式配置
  programs.eza.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
};
