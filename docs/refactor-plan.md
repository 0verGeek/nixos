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
  loader kernel
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
│   ├── loader.nix                # 引导器(myNixos.boot) → nixos.loader
│   └── kernel.nix                # 内核 → nixos.kernel
├── desktop/
│   ├── kde/nixos.nix             # KDE: sddm+plasma6+X11 → nixos.kde
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
│   ├── base.nix dae.nix(+dae-config.dae) clash-verge.nix(原样)
├── nix/
│   ├── settings.nix nix-ld.nix nh.nix overlays.nix
├── programs/
│   ├── browsers.nix editors.nix utilities.nix          # → homeManager.*
│   ├── firefox.nix appimage.nix mtr.nix virt-manager.nix  # → nixos.*
├── services/
│   ├── pipewire.nix power.nix printing.nix gnupg.nix libvirtd.nix
├── shell/
│   ├── zsh/{nixos.nix, home.nix} # → nixos.zsh / homeManager.zsh
│   ├── starship.nix zellij.nix tools.nix wezterm.nix
└── users.nix                     # → nixos.users
```

## 5. attr 命名映射(旧 → 新,均为单元名)

### 系统侧(nixos)

| 现 attr | 新 attr |
|---|---|
| `boot` | `loader` + `kernel`(新拆) |
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
| (新)firefox | `firefox` |
| `programs-appimage` | `appimage` |
| (新)mtr | `mtr` |
| (新)virt-manager | `virt-manager` |
| `programs-zsh` | `zsh` |
| `services-gnupg` | `gnupg` |
| `services-libvirtd` | `libvirtd`(virt-manager 拆出) |
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
      # boot
      loader kernel
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
      base dae
      # nix
      settings nix-ld nh overlays
      # programs
      firefox appimage mtr
      # services
      gnupg pipewire power printing
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
    # boot
    { myNixos.boot = { loader = "grub"; device = "/dev/sda"; }; }
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
    self.modules.nixos.virt-manager
    self.modules.nixos.hm-radon
    # boot
    { myNixos.boot.loader = "systemd-boot"; }
    inputs.home-manager.nixosModules.home-manager
  ];
  ```
  home:`core` + `direnv` + `dsh` + `session`
- niri 桥:`desktop/niri/nixos.nix` 内 `home-manager.users.camuss.imports = [ self.modules.homeManager.niri ]`

## 7. 内容级修正(行为不变)

1. **boot 拆分**:`loader.nix` = myNixos.boot 选项 + 引导器分支;`kernel.nix` = `lib.mkIf (config.myNixos.boot.loader == "systemd-boot")` 的 `linuxPackages_latest`(行为不变:radon 用 latest、neon 用默认内核)
2. **mtr 拆出** `network/base.nix` → `programs/mtr.nix`
3. **firefox 拆出** `packages.nix` → `programs/firefox.nix`;systemPackages → `environment/system-packages.nix`
4. **virt-manager 拆出** `services/libvirtd.nix` → `programs/virt-manager.nix`(radon 同时引用)
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
