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
      self.modules.nixos.virt-manager
      # ── host glue ──
      self.modules.nixos.hm-radon
      # ── boot:core 共享导入,这里只选择引导器(Conditional aspect)──
      { myNixos.boot.loader = "systemd-boot"; }
      inputs.home-manager.nixosModules.home-manager
    ];
  };

  # 构建检查:让 `nix flake check` 验证本机配置可构建
  flake.checks.x86_64-linux.radon-system =
    self.nixosConfigurations.radon.config.system.build.toplevel;
}
