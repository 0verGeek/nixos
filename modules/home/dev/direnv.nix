{
  flake.modules.homeManager.direnv = { pkgs, ... }: {
    programs = {
      direnv = {
        enable = true;
        # 提供 use flake / use nix 指令；direnv 会自动加载
        # ~/.config/direnv/lib/hm-nix-direnv.sh（即 nix-direnv 的 direnvrc）
        nix-direnv.enable = true;
      };
      # 本机 HM 的 home.packages 不在 PATH 上，用 alias 让 direnv 命令可用
      zsh.shellAliases.direnv = "${pkgs.direnv}/bin/direnv";
    };
  };
}
