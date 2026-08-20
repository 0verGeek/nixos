# core:所有主机都启用的 Home Manager 共享组合。
# 主机差异由各主机 home 文件直接 import 表达。
{ self, ... }: {
  flake.modules.homeManager.core = {
    imports = with self.modules.homeManager; [
      apps-browsers
      apps-editors
      apps-utilities
      dev-build
      dev-languages
      dev-lazygit
      dev-llm
      dev-lsp
      dev-web
      fonts
      git
      shell-tools
      shell-zsh
      wezterm
    ];
  };
}
