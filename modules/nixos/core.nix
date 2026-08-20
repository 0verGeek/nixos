# core:所有主机都启用的共享组合。
# 只含"全车队一致"的模块;主机差异由各主机文件直接 import 表达(import what you need)。
# 唯一的例外:boot(引导器)是共享导入但各主机选择不同,由 `myNixos.boot.loader` 表达。
{ self, ... }: {
  flake.modules.nixos.core = {
    imports = with self.modules.nixos; [
      boot
      desktop-plasma
      desktop-x11
      desktop-xdg
      hardware-common
      hardware-input
      input-method-fcitx5
      locale
      network-base
      network-dae
      nix
      nix-ld
      nh
      overlays
      packages
      programs-appimage
      programs-zsh
      services-gnupg
      services-pipewire
      services-power
      services-printing
      users
    ];
  };
}
