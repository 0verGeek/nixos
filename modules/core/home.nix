# core:所有主机都启用的 Home Manager 共享组合。
# 主机差异由各主机 home 文件直接 import 表达。
# 命名:attr = 单元名(无域前缀),域的分类用下方注释分组表达。
{ self, ... }: {
  flake.modules.homeManager.core = {
    imports = with self.modules.homeManager; [
      # ── development ──
      build
      git
      languages
      lazygit
      llm
      lsp
      web
      # ── environment ──
      fonts
      # ── programs ──
      browsers
      editors
      utilities
      # ── shell ──
      starship
      tools
      wezterm
      zellij
      zsh
    ];
  };
}
