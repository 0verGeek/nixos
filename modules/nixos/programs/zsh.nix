{
  flake.modules.nixos.programs-zsh = {
    # 系统级 zsh(作为用户默认 shell 使用)
    programs.zsh.enable = true;
  };
}
