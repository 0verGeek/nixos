{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.radon = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      hostname = "radon";
    };
    modules = [
      # core:所有主机共享的组合
      self.modules.nixos.core
      # 本机差异 = 按需 import
      self.modules.nixos.hardware-radon
      self.modules.nixos.hardware-gpu-nvidia
      self.modules.nixos.services-libvirtd
      self.modules.nixos.hm-radon
      # boot 在 core 中,这里只选择引导器(Conditional aspect)
      { myNixos.boot.loader = "systemd-boot"; }
      inputs.home-manager.nixosModules.home-manager
    ];
  };

  # 构建检查:让 `nix flake check` 验证本机配置可构建
  flake.checks.x86_64-linux.radon-system =
    self.nixosConfigurations.radon.config.system.build.toplevel;
}
