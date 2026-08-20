{
  flake.modules.homeManager.dev-dsh =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.deepseek-harness.homeModules.default ];

      programs.dsh = {
        enable = true;

        # 配置 profile（以 tui 为例）
        profiles.tui = {
          bundles = [ pkgs.dsh.bundles.tui ];
          mode = "managed"; # 或 "mutable"
        };

        # 不设默认 profile:裸 dsh 走官方内置 profile(web/headless),
        # TUI 用 `dsh --profile nix-tui` 启动
        defaultProfile = null;
      };
      services.dsh.enable = true;
    };
}
