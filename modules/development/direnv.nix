{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      # 提供 use flake / use nix 指令；direnv 会自动加载
      # ~/.config/direnv/lib/hm-nix-direnv.sh（即 nix-direnv 的 direnvrc）
      nix-direnv.enable = true;
    };
  };
}
