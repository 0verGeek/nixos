# 引导器:互斥选项(enum),由主机通过 `myNixos.boot.loader` 选择
{
  flake.modules.nixos.boot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.myNixos.boot = {
        loader = lib.mkOption {
          type = lib.types.enum [
            "systemd-boot"
            "grub"
          ];
          default = "systemd-boot";
          description = "引导器";
        };
        device = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "grub 安装目标设备(仅 loader = grub 时需要)";
        };
      };

      config = lib.mkMerge [
        (lib.mkIf (config.myNixos.boot.loader == "systemd-boot") {
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.loader.systemd-boot.configurationLimit = 10;

          # Use latest kernel.
          boot.kernelPackages = pkgs.linuxPackages_latest;
        })
        (lib.mkIf (config.myNixos.boot.loader == "grub") {
          boot.loader.grub.enable = true;
          boot.loader.grub.device = config.myNixos.boot.device;
          boot.loader.grub.useOSProber = true;
        })
      ];
    };
}
