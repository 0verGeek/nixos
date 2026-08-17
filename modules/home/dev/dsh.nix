{
  flake.modules.homeManager.dsh =
    {
      inputs,
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.deepseek-harness.homeModules.default ];

      programs.dsh = {
        enable = true;

        # 配置 profile（以 tui 为例）
        profiles.tui = {
          bundles = [ pkgs.dsh.bundles.tui ];
          mode = "managed"; # 或 "mutable"
        };

        # 设置默认 profile
        defaultProfile = "nix-tui";
      };
      # services.dsh.enable = true;
    };
}
