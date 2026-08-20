{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.neon = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      hostname = "neon";
    };
    modules = [
      # ── core:所有主机共享的组合 ──
      self.modules.nixos.core
      # ── hardware ──
      self.modules.nixos.neon
      # ── desktop(niri 是跨系统/home 的特性单元)──
      self.modules.nixos.niri
      # ── host glue ──
      self.modules.nixos.hm-neon
      # ── boot:主机直接选择引导器 ──
      self.modules.nixos.grub
      { boot.loader.grub.device = "/dev/sda"; }
      inputs.home-manager.nixosModules.home-manager
    ];
  };

  # 构建检查:让 `nix flake check` 验证本机配置可构建
  flake.checks.x86_64-linux.neon-system = self.nixosConfigurations.neon.config.system.build.toplevel;
}
