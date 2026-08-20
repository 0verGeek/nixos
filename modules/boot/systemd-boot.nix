# systemd-boot 引导器(radon 使用)。
# 无 option 机制:主机直接 import 本单元选择引导器(与其余分类一致,注释分组)。
{
  flake.modules.nixos.systemd-boot = { pkgs, ... }: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = 10;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
