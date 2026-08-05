{
  flake.modules.nixos.boot_grub = { disk, ... }: {
    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = disk;
    boot.loader.grub.useOSProber = true;
    boot.loader.systemd-boot.configurationLimit = 10;
  };
}
