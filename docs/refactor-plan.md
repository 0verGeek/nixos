# NixOS 配置重构方案(按功能域分类)

> 状态:定稿(2026-08-20,执行中)
> 命名定案:无域命名 + hosts 注释分组

---

## 1. 背景与目标

现状问题:

- `modules/nixos/`、`modules/home/`、`modules/features/` 三分,分类依据不统一
- 文件内容混装(一个文件塞多个无关功能)、部分过度划分
- attr 命名带域前缀但不一致(`services-gnupg` vs `packages` vs `niri`)

目标:只保留**仓库根一级骨架**,根以下全部按**功能域目录**重新分类;消除历史包袱;不改变运行时行为。

## 2. 骨架约定

- **保持(仓库根一级)**:`flake.nix`、`hosts/`、`lib/`、`modules/`、`overlays/`、`pkgs/`、`secrets/`
- **可重构**:`modules/` 内部结构、`hosts/` 编排、`flake.modules.*` 命名、文件内容
- **分类原则**:按功能划分;**目录 = 分类载体**;attr 命名**无域前缀**(单元名),域的分类在 hosts/core 里用**注释**表达

## 3. 命名定案(最终)

- attr = `flake.modules.<侧别>.<单元>`,即**单元名,不带域前缀**:`nixos.niri`、`nixos.kde`、`homeManager.lsp`、`homeManager.browsers`
- 侧别(nixos / homeManager)是 flake.modules 的第一层 class,标准 flake-parts 机制,无任何自定义类型
- **域的分类表达**:
  1. 文件系统目录(modules/desktop/、modules/development/…)
  2. hosts / core 的 import 清单按域分组 + 注释

```nix
# modules/core/nixos.nix 中
imports = with self.modules.nixos; [
  # boot
  loader
  # desktop
  kde xdg
  ...
];
```

- 曾评估并放弃的方案:三层 attr 嵌套(替换 flake.modules 类型,官方无先例)、点号字符串、kebab 带域前缀、default.nix 聚合器

## 4. 目标树

```
modules/
├── core/
│   ├── nixos.nix                 # 系统侧共享组合 → nixos.core
│   └── home.nix                  # 用户侧共享组合 → homeManager.core
├── boot/
│   ├── systemd-boot.nix          # radon 用 → nixos.systemd-boot(含 latest 内核)
│   └── grub.nix                  # neon 用 → nixos.grub(设备由主机内联指定)
├── desktop/
│   ├── kde.nix                   # KDE: sddm+plasma6+X11 → nixos.kde(单侧单元,平铺)
│   ├── niri/
│   │   ├── nixos.nix             # → nixos.niri(含 home 桥)
│   │   ├── home.nix              # → homeManager.niri
│   │   └── config.kdl
│   ├── xdg.nix                   # → nixos.xdg
│   ├── theme.nix                 # → homeManager.theme
│   └── noctalia.nix              # → homeManager.noctalia
├── development/
│   ├── languages.nix lsp.nix build.nix git.nix direnv.nix lazygit.nix llm.nix dsh.nix web.nix
├── environment/
│   ├── system-packages.nix       # → nixos.system-packages
│   ├── fonts.nix                 # → homeManager.fonts
│   └── session.nix               # → homeManager.session
├── hardware/
│   ├── common.nix input.nix gpu-nvidia.nix
│   ├── neon.nix radon.nix        # 从 hosts/ 移入
├── input-method/
│   ├── fcitx5.nix                # → nixos.fcitx5
│   └── rime.nix                  # → homeManager.rime
├── locale.nix                    # → nixos.locale
├── network/
│   ├── base.nix dae.nix(+dae-config.dae) clash-verge.nix(原样) mtr.nix
├── nix/
│   ├── settings.nix nix-ld.nix nh.nix overlays.nix
├── programs/
│   ├── browsers/{nixos.nix, home.nix}  # 浏览器成对单元(firefox / chrome+folo)
│   ├── editors.nix utilities.nix gnupg.nix appimage.nix
├── services/
│   ├── pipewire.nix power.nix printing.nix libvirtd.nix(含 virt-manager)
├── shell/
│   ├── zsh/{nixos.nix, home.nix} # → nixos.zsh / homeManager.zsh
│   ├── starship.nix zellij.nix tools.nix wezterm.nix
└── users.nix                     # → nixos.users
```

## 5. attr 命名映射(旧 → 新,均为单元名)

### 系统侧(nixos)

| 现 attr | 新 attr |
|---|---|
| `boot` | `systemd-boot` / `grub`(无 option 机制,主机直接 import) |
| `desktop-plasma` + `desktop-x11` | `kde`(合并) |
| `desktop-xdg` | `xdg` |
| `niri` | `niri`(不变,移到 desktop/) |
| `hardware-common` | `common` |
| `hardware-gpu-nvidia` | `gpu-nvidia` |
| `hardware-input` | `input` |
| `hardware-neon` / `hardware-radon` | `neon` / `radon`(从 hosts/ 移入) |
| `input-method-fcitx5` | `fcitx5` |
| `locale` | `locale`(不变) |
| `network-base` | `base`(mtr 拆出) |
| `network-dae` | `dae` |
| `network-clash-verge` | `clash-verge`(原样) |
| `nix` | `settings` |
| `nix-ld` | `nix-ld`(不变) |
| `nh` | `nh`(不变) |
| `overlays` | `overlays`(不变) |
| `packages`(systemPackages) | `system-packages` |
| (新)firefox(并入 browsers 成对单元) | `browsers` |
| `programs-appimage` | `appimage` |
| (新)mtr(自 network-base 拆出,归 network/) | `mtr` |
| `programs-zsh` | `zsh` |
| `services-gnupg` | `gnupg`(归 programs/,内容是 programs.gnupg.agent) |
| `services-libvirtd` | `libvirtd`(含 virt-manager,虚拟化单元内聚) |
| `services-pipewire` | `pipewire` |
| `services-power` | `power` |
| `services-printing` | `printing` |
| `users` | `users`(不变) |
| `core` | `core`(不变) |
| `hm-neon` / `hm-radon` | 不变(主机胶水) |

### 用户侧(homeManager)

| 现 attr | 新 attr |
|---|---|
| `core` | `core`(不变) |
| `apps-browsers` | `browsers` |
| `apps-editors` | `editors` |
| `apps-utilities` | `utilities` |
| `niri` | `niri`(不变,移到 desktop/) |
| `desktop-noctalia` | `noctalia` |
| `desktop-theme` | `theme` |
| `desktop-rime` | `rime` |
| `dev-build` | `build` |
| `dev-direnv` | `direnv` |
| `dev-dsh` | `dsh` |
| `dev-languages` | `languages` |
| `dev-lazygit` | `lazygit` |
| `dev-llm` | `llm` |
| `dev-lsp` | `lsp` |
| `dev-web` | `web` |
| `env` | `session` |
| `fonts` | `fonts`(不变) |
| `git` | `git`(不变) |
| `shell-tools` | `tools` |
| `shell-zsh` | `zsh`(拆分 starship/zellij) |
| (新)starship | `starship` |
| (新)zellij | `zellij` |
| `wezterm` | `wezterm`(不变) |

> 冲突检查:nixos / homeManager 两个 namespace 内均无重名单元。

## 6. 组合策略(core 注释分组)

### `core/nixos.nix`(系统侧共享)

```nix
{ self, ... }: {
  flake.modules.nixos.core = {
    imports = with self.modules.nixos; [
      # desktop
      kde xdg
      # environment
      system-packages
      # hardware
      common input
      # input-method
      fcitx5
      # locale
      locale
      # network
      base dae mtr
      # nix
      settings nix-ld nh overlays
      # programs
      browsers gnupg appimage
      # services
      pipewire power printing
      # shell
      zsh
      # users
      users
    ];
  };
}
```

### `core/home.nix`(用户侧共享)

```nix
{ self, ... }: {
  flake.modules.homeManager.core = {
    imports = with self.modules.homeManager; [
      # development
      build git languages lazygit llm lsp web
      # environment
      fonts
      # programs
      browsers editors utilities
      # shell
      starship tools wezterm zellij zsh
    ];
  };
}
```

### 主机差异(import 清单注释分组)

- **neon**:
  ```nix
  modules = [
    self.modules.nixos.core
    # hardware
    self.modules.nixos.neon
    # desktop
    self.modules.nixos.niri
    self.modules.nixos.hm-neon
    # boot(主机直接选择引导器)
    self.modules.nixos.grub
    { boot.loader.grub.device = "/dev/sda"; }
    inputs.home-manager.nixosModules.home-manager
  ];
  ```
  home:`core` + `noctalia` + `theme` + `rime`
- **radon**:
  ```nix
  modules = [
    self.modules.nixos.core
    # hardware
    self.modules.nixos.radon
    self.modules.nixos.gpu-nvidia
    # services / virtualisation
    self.modules.nixos.libvirtd
    self.modules.nixos.hm-radon
    # boot(主机直接选择引导器)
    self.modules.nixos.systemd-boot
    inputs.home-manager.nixosModules.home-manager
  ];
  ```
  home:`core` + `direnv` + `dsh` + `session`
- niri 桥:`desktop/niri/nixos.nix` 内 `home-manager.users.camuss.imports = [ self.modules.homeManager.niri ]`

## 7. 内容级修正(行为不变)

1. **boot 拆为两单元、移除 option 机制**:`systemd-boot.nix`(radon,含 latest 内核)+ `grub.nix`(neon,设备由主机内联);主机直接 import,与其余分类统一(无域命名 + 注释分组)
2. **mtr 拆出** `network/base.nix` → `network/mtr.nix`(与 dae/clash-verge 同域)
3. **systemPackages 拆出** → `environment/system-packages.nix`;firefox 并入 `programs/browsers/` 成对单元(系统侧)
4. **virt-manager 保留在 libvirtd.nix**(虚拟化单元内聚;审阅后撤销拆分,radon 只引用 libvirtd)
5. **shell 拆分**:`shell/zsh.nix` → `shell/zsh/home.nix` + `shell/starship.nix` + `shell/zellij.nix`
6. **niri 迁移**:`features/niri/` → `desktop/niri/`
7. **删除** `modules/{nixos,home,features}/`
8. **clash-verge** 原样保留,不接入

## 8. lib/ overlays/ pkgs/

| 目录 | 处置 |
|---|---|
| `overlays/` | 保持不变(`dsh-tui-fix.nix` 已在位,`nix/overlays.nix` 继续引用) |
| `pkgs/` | 维持空占位 |
| `lib/` | 维持空占位(README);未来"desktop 可选项"(myNixos.desktop option)落点 |

## 9. 执行步骤

1. ✅ 固化现状(git commit)
2. 建目录,`git mv` 迁移文件
3. 逐文件改 attr 声明为无域单元名 + 内容拆分
4. 重建 `core/{nixos,home}.nix`,更新 hosts 引用(注释分组)
5. 删除旧目录,检查残留引用
6. `nix flake check` 验证
7. 提交

## 10. 验证

- `nix flake check`(构建 neon-system / radon-system)
- 可选:`nixos-rebuild build --flake .#neon` / `.#radon`

## 11. 决策记录

| 决策点 | 结论 |
|---|---|
| 骨架 | 仓库根一级保持,其下全部可重构 |
| 架构 | A 案:域内分侧(目录 = 分类) |
| **命名** | **无域命名**:attr = 单元名(`nixos.niri` / `homeManager.lsp`);域分类 = 目录 + hosts 注释;标准 flake-parts,零自定义机制 |
| 组合 | core 显式清单 + 注释分组;不用 default.nix 聚合器 |
| niri | 折入 desktop/,桥引用 `homeManager.niri` |
| 主机硬件 | 移入 hardware/{neon,radon}.nix |
| clash-verge | 原样保留 |
| lib/pkgs | 空占位(未来可选项实现落点 lib/) |
| 审阅修正(2026-08-20) | mtr→network/;gnupg→programs/;virt-manager 并回 libvirtd;firefox 并入 browsers 成对单元;kernel 并回 loader;fd/rg→shell/tools;unzip→programs/utilities;session 保持 |
| boot option 移除(2026-08-20) | 删除 myNixos.boot 选项机制;boot 拆为 systemd-boot/grub 两单元,主机直接 import(无域命名 + 注释统一) |
