# GRUB 引导器(neon 使用)。
# 无 option 机制:主机直接 import 本单元,并按需内联指定 boot.loader.grub.device。
{
  flake.modules.nixos.grub = {
    boot.loader.grub.enable = true;
    boot.loader.grub.useOSProber = true;
  };
}
