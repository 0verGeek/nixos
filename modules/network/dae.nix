{
  flake.modules.nixos.dae = { pkgs, ... }: {
    services.dae = {
      enable = true;
      # 声明式管理:配置随 flake 进 store(经 LoadCredential 提供给服务)
      configFile = ./dae-config.dae;
    };
  };
}
