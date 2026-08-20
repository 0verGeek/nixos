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
      # ── core:所有主机共享的组合 ──
      self.modules.nixos.core
      # ── hardware ──
      self.modules.nixos.radon
      self.modules.nixos.gpu-nvidia
      # ── services / virtualisation ──
      self.modules.nixos.libvirtd
      # ── host glue ──
      self.modules.nixos.hm-radon
      # ── boot:主机直接选择引导器 ──
      self.modules.nixos.systemd-boot
      inputs.home-manager.nixosModules.home-manager
    ];
  };

  # 构建检查:让 `nix flake check` 验证本机配置可构建
  flake.checks.x86_64-linux.radon-system =
    self.nixosConfigurations.radon.config.system.build.toplevel;
}
