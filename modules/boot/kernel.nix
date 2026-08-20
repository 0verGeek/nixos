# 内核选择:仅 systemd-boot 分支使用最新内核(保持重构前行为:radon 用 latest,neon/grub 用默认)。
# 与引导器(loader.nix)解耦,如需按主机指定内核,可改为 myNixos.boot.kernel 选项。
{
  flake.modules.nixos.kernel =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf (config.myNixos.boot.loader == "systemd-boot") {
      # Use latest kernel.
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
