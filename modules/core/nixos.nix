# core:所有主机都启用的共享组合。
# 只含"全车队一致"的模块;主机差异(含 boot 引导器)由各主机文件直接 import 表达(import what you need)。
# 命名:attr = 单元名(无域前缀),域的分类用下方注释分组表达。
{ self, ... }: {
  flake.modules.nixos.core = {
    imports = with self.modules.nixos; [
      # ── desktop ──
      kde
      xdg
      # ── environment ──
      system-packages
      # ── hardware ──
      common
      input
      # ── input-method ──
      fcitx5
      # ── locale ──
      locale
      # ── network ──
      base
      dae
      mtr
      # ── nix ──
      settings
      nix-ld
      nh
      # ── programs ──
      browsers
      gnupg
      appimage
      # ── services ──
      pipewire
      power
      printing
      # ── shell ──
      zsh
      # ── users ──
      users
    ];
  };
}
