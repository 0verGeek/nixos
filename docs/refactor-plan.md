# NixOS 配置重构方案(按功能域分类)

> 状态:待审阅(2026-08-20 定稿 A 案,未执行)
> 目标读者:camuss / 后续维护者

---

## 1. 背景与目标

现状问题:

- `modules/nixos/`、`modules/home/`、`modules/features/` 三分,且分类依据不统一(侧别 vs 功能 vs 特性)
- 文件内容混装:一个文件塞多个无关功能(如 `network/base.nix` 混 hostname+NetworkManager+mtr,`packages.nix` 混 systemPackages+firefox,`libvirtd.nix` 混 libvirtd+virt-manager+kvm 内核参数,`shell/zsh.nix` 混 zsh+starship+zellij)
- 部分地方过度划分(为单文件开目录+聚合器)

目标:只保留**仓库根一级骨架**,根以下全部按**功能域**重新分类;消除历史分类包袱;不改变任何运行时行为。

## 2. 骨架约定

- **保持(仓库根一级)**:`flake.nix`、`hosts/`、`lib/`、`modules/`、`overlays/`、`pkgs/`、`secrets/`
- **可重构(其下全部内容,含文件内部)**:`modules/` 内部结构、`hosts/` 内部引用与编排、`flake.modules.*` 命名、各文件内容
- **分类原则**:按功能划分;目录 = 平级**可选**单元的存放处,不做固定组合(不使用 default.nix 聚合器)
- **可选项语义(OOP 类比)**:同一域内单元(如 desktop 的 kde / niri)互相独立、可分别取舍,由 hosts 表达选择

## 3. 全量盘点(食物清单)

| 组 | 配置项 | 现状位置 |
|---|---|---|
| 引导 | 引导器选择(systemd-boot/grub+EFI+osProber)、内核 linuxPackages_latest | `nixos/boot.nix` |
| 桌面-系统 | KDE(sddm+plasma6)、X11+xkb(cn)、xdg portal(gtk)、niri+菜单修复 | `nixos/desktop/*`、`features/niri/nixos.nix` |
| 桌面-用户 | niri 配套(fuzzel/swaylock/mako/swayidle/polkit-gnome/swaybg+kdl)、noctalia、gtk/qt/图标主题、rime 数据 | `features/niri/home.nix`、`home/desktop/*` |
| 输入法 | fcitx5(wayland+addons)、rime | `nixos/input-method/fcitx5.nix`、`home/desktop/rime.nix` |
| 硬件 | 图形/蓝牙、NVIDIA(modesetting/power/open)、libinput、微码/文件系统/swap/kvm 模块 | `nixos/hardware/*`、`hosts/*/hardware.nix` |
| 网络 | hostname、NetworkManager、dae 代理、clash-verge(休眠)、mtr | `nixos/network/*` |
| 本地化 | 时区、区域/语言 | `nixos/locale.nix` |
| Nix 自身 | settings(源/信任/实验特性/registry)、nix-ld、nh、overlays | `nixos/{nix,nix-ld,nh,overlays}.nix` |
| 应用 | firefox、chrome/folo、vim/nvim/vscode/zed/kate/obsidian、fd/rg/fastfetch 等、systemPackages(7)、appimage、virt-manager | `nixos/packages.nix`、`nixos/programs/*`、`nixos/services/libvirtd.nix`、`home/apps/*` |
| 开发 | 语言(rustup/uv/node/python)、LSP(7)、构建、git、direnv、lazygit、llm、dsh、hugo | `home/dev/*`、`home/git.nix` |
| 服务 | pipewire+rtkit、电源(ppd/upower)、打印、gnupg-agent、libvirtd/qemu、dae、dsh | `nixos/services/*`、`nixos/network/dae.nix`、`home/dev/dsh.nix` |
| 终端/shell | 系统 zsh、用户 zsh+starship+zellij、eza/zoxide/fzf/bat、wezterm | `nixos/programs/zsh.nix`、`home/shell/*`、`home/wezterm.nix` |
| 字体 | 4 款字体+fontconfig 默认 | `home/fonts.nix` |
| 用户/环境 | camuss 账户、sessionPath、home-manager 桥配置 | `nixos/users.nix`、`home/env.nix`、`hosts/*/home.nix` |
| 编排 | core 组合、neon/radon 模块清单 | `nixos/core.nix`、`hosts/*/default.nix` |

## 3.5 lib/ overlays/ pkgs/ 的职责与处置(查证结论)

社区主流树状结构中这三个根级目录的职责,与本次方案的处置:

| 目录 | 社区职责 | 现状 | 本方案处置 |
|---|---|---|---|
| `overlays/` | overlay 函数集合 | `dsh-tui-fix.nix` 已在正确位置,由 `modules/nixos/overlays.nix` 接线(`import ../../overlays/dsh-tui-fix.nix`) | **保持不变**;新结构 `modules/nix/overlays.nix` 继续引用 |
| `pkgs/` | 自定义包(callPackage 可用的 derivation) | 空(仅 README 占位) | **维持空占位**;当前无自定义包(系统包来自 nixpkgs,dsh 来自 deepseek-harness input+overlay);未来自研/打包放这里 |
| `lib/` | helper 函数 / 自定义 option 类型 | 空(仅 README 占位) | **维持空占位**;未来若实现"kde/niri 作为可选项"(如 `lib/mkDesktopOption` 工厂函数),这是自然落点 |

结论:本次重构**不向 lib/、pkgs/ 搬运任何内容**;骨架保留这两个目录(空占位正常)。

## 4. 目标架构(A 案:域内分侧)

- `modules/` 顶层 = 功能域(11 目录 + 2 平铺单文件域)
- 域内:
  - **成对单元**(系统侧+用户侧都有)→ 子目录,内含 `nixos.nix` / `home.nix`;系统侧负责经 home-manager 桥注入用户侧(单一入口,niri 模式推广)
  - **单侧单元** → 直接文件,由 hosts 在对应侧引用
- `flake.modules` 命名:`flake.modules.<nixos|homeManager>.<域>-<单元>`(侧别+域+单元;与文件物理位置解耦)
- 不引入任何 default.nix 聚合器;组合 = `core/` 显式共享清单 + hosts 差异

## 5. 目标树

```
modules/
├── core/
│   ├── nixos.nix                 # 系统侧共享组合(原 modules/nixos/core.nix)
│   └── home.nix                  # 用户侧共享组合(原 modules/home/core.nix)
├── boot/
│   ├── loader.nix                # 引导器选择(myNixos.boot 选项, systemd-boot/grub)
│   └── kernel.nix                # 内核(与引导器解耦;行为不变:仅 systemd-boot 分支用 latest)
├── desktop/
│   ├── kde/nixos.nix             # KDE: sddm + plasma6 + X11/xkb(合并 plasma.nix + x11.nix)
│   ├── niri/
│   │   ├── nixos.nix             # niri + dolphin 菜单修复 + home 桥
│   │   ├── home.nix              # fuzzel/swaylock/mako/swayidle/polkit-gnome/swaybg
│   │   └── config.kdl
│   ├── xdg.nix                   # xdg portal(系统侧,两个 WM 共享)
│   ├── theme.nix                 # gtk/qt/图标主题(用户侧)
│   └── noctalia.nix              # noctalia 美化(用户侧)
├── development/                  # 开发(全用户侧)
│   ├── languages.nix lsp.nix build.nix git.nix direnv.nix lazygit.nix llm.nix dsh.nix web.nix
├── environment/
│   ├── system-packages.nix       # environment.systemPackages(系统侧)
│   ├── fonts.nix                 # 字体 + fontconfig(用户侧)
│   └── session.nix               # sessionPath(用户侧,原 env.nix)
├── hardware/
│   ├── common.nix input.nix gpu-nvidia.nix
│   ├── neon.nix radon.nix        # 微码/文件系统/swap(从 hosts/*/hardware.nix 移入)
├── input-method/
│   ├── fcitx5.nix                # fcitx5 + addons(系统侧)
│   └── rime.nix                  # rime 词库配置(用户侧,原 desktop/rime.nix)
├── locale.nix                    # 单文件域,平铺
├── network/
│   ├── base.nix dae.nix(+dae-config.dae) clash-verge.nix(原样保留)
├── nix/
│   ├── settings.nix nix-ld.nix nh.nix overlays.nix
├── programs/                     # 应用(混两侧,attr 区分)
│   ├── browsers.nix editors.nix utilities.nix              # 用户侧
│   ├── firefox.nix appimage.nix mtr.nix virt-manager.nix   # 系统侧
├── services/
│   ├── pipewire.nix power.nix printing.nix gnupg.nix libvirtd.nix
├── shell/
│   ├── zsh/{nixos.nix, home.nix} # 系统默认 shell / 用户 zsh(antidote/别名/history)
│   ├── starship.nix zellij.nix tools.nix wezterm.nix       # 用户侧
└── users.nix                     # 单文件域,平铺
```

## 6. 命名映射(旧 → 新)

### 系统侧(nixos)

| 现文件 | 现 attr | 新文件 | 新 attr |
|---|---|---|---|
| `nixos/boot.nix` | `boot` | `boot/loader.nix` | `boot-loader` |
| — | — | `boot/kernel.nix` | `boot-kernel` |
| `nixos/desktop/plasma.nix` + `x11.nix` | `desktop-plasma`/`desktop-x11` | `desktop/kde/nixos.nix` | `desktop-kde` |
| `nixos/desktop/xdg.nix` | `desktop-xdg` | `desktop/xdg.nix` | `desktop-xdg` |
| `features/niri/nixos.nix` | `niri` | `desktop/niri/nixos.nix` | `desktop-niri` |
| `nixos/hardware/common.nix` | `hardware-common` | `hardware/common.nix` | 不变 |
| `nixos/hardware/gpu-nvidia.nix` | `hardware-gpu-nvidia` | `hardware/gpu-nvidia.nix` | 不变 |
| `nixos/hardware/input.nix` | `hardware-input` | `hardware/input.nix` | 不变 |
| `hosts/neon/hardware.nix` | `hardware-neon` | `hardware/neon.nix` | 不变 |
| `hosts/radon/hardware.nix` | `hardware-radon` | `hardware/radon.nix` | 不变 |
| `nixos/input-method/fcitx5.nix` | `input-method-fcitx5` | `input-method/fcitx5.nix` | 不变 |
| `nixos/locale.nix` | `locale` | `locale.nix` | 不变 |
| `nixos/network/base.nix` | `network-base` | `network/base.nix`(mtr 拆出) | 不变 |
| `nixos/network/dae.nix` | `network-dae` | `network/dae.nix` | 不变 |
| `nixos/network/clash-verge.nix` | `network-clash-verge` | `network/clash-verge.nix` | 不变(休眠,不接入) |
| `nixos/nix.nix` | `nix` | `nix/settings.nix` | `nix-settings` |
| `nixos/nix-ld.nix` | `nix-ld` | `nix/nix-ld.nix` | `nix-ld` |
| `nixos/nh.nix` | `nh` | `nix/nh.nix` | `nix-nh` |
| `nixos/overlays.nix` | `overlays` | `nix/overlays.nix` | `nix-overlays` |
| `nixos/packages.nix`(firefox) | — | `programs/firefox.nix` | `programs-firefox`(新) |
| `nixos/packages.nix`(systemPackages) | `packages` | `environment/system-packages.nix` | `environment-system-packages` |
| `nixos/network/base.nix`(mtr) | — | `programs/mtr.nix` | `programs-mtr`(新) |
| `nixos/services/libvirtd.nix`(virt-manager) | — | `programs/virt-manager.nix` | `programs-virt-manager`(新) |
| `nixos/programs/appimage.nix` | `programs-appimage` | `programs/appimage.nix` | 不变 |
| `nixos/programs/zsh.nix` | `programs-zsh` | `shell/zsh/nixos.nix` | `shell-zsh` |
| `nixos/services/gnupg.nix` | `services-gnupg` | `services/gnupg.nix` | 不变 |
| `nixos/services/libvirtd.nix` | `services-libvirtd` | `services/libvirtd.nix` | 不变 |
| `nixos/services/pipewire.nix` | `services-pipewire` | `services/pipewire.nix` | 不变 |
| `nixos/services/power.nix` | `services-power` | `services/power.nix` | 不变 |
| `nixos/services/printing.nix` | `services-printing` | `services/printing.nix` | 不变 |
| `nixos/users.nix` | `users` | `users.nix` | 不变 |
| `nixos/core.nix` | `core` | `core/nixos.nix` | `core` |
| `hosts/neon/home.nix` | `hm-neon` | 不动 | 不变 |
| `hosts/radon/home.nix` | `hm-radon` | 不动 | 不变 |

### 用户侧(homeManager)

| 现文件 | 现 attr | 新文件 | 新 attr |
|---|---|---|---|
| `home/core.nix` | `core` | `core/home.nix` | `core` |
| `home/apps/browsers.nix` | `apps-browsers` | `programs/browsers.nix` | `programs-browsers` |
| `home/apps/editors.nix` | `apps-editors` | `programs/editors.nix` | `programs-editors` |
| `home/apps/utilities.nix` | `apps-utilities` | `programs/utilities.nix` | `programs-utilities` |
| `features/niri/home.nix` | `niri` | `desktop/niri/home.nix` | `desktop-niri` |
| `home/desktop/noctalia.nix` | `desktop-noctalia` | `desktop/noctalia.nix` | 不变 |
| `home/desktop/theme.nix` | `desktop-theme` | `desktop/theme.nix` | 不变 |
| `home/desktop/rime.nix` | `desktop-rime` | `input-method/rime.nix` | `input-method-rime` |
| `home/dev/build.nix` | `dev-build` | `development/build.nix` | `development-build` |
| `home/dev/direnv.nix` | `dev-direnv` | `development/direnv.nix` | `development-direnv` |
| `home/dev/dsh.nix` | `dev-dsh` | `development/dsh.nix` | `development-dsh` |
| `home/dev/languages.nix` | `dev-languages` | `development/languages.nix` | `development-languages` |
| `home/dev/lazygit.nix` | `dev-lazygit` | `development/lazygit.nix` | `development-lazygit` |
| `home/dev/llm.nix` | `dev-llm` | `development/llm.nix` | `development-llm` |
| `home/dev/lsp.nix` | `dev-lsp` | `development/lsp.nix` | `development-lsp` |
| `home/dev/web.nix` | `dev-web` | `development/web.nix` | `development-web` |
| `home/env.nix` | `env` | `environment/session.nix` | `environment-session` |
| `home/fonts.nix` | `fonts` | `environment/fonts.nix` | `environment-fonts` |
| `home/git.nix` | `git` | `development/git.nix` | `development-git` |
| `home/shell/tools.nix` | `shell-tools` | `shell/tools.nix` | 不变 |
| `home/shell/zsh.nix` | `shell-zsh` | `shell/zsh/home.nix` | `shell-zsh` |
| —(zsh.nix 内 starship) | — | `shell/starship.nix` | `shell-starship`(新) |
| —(zsh.nix 内 zellij) | — | `shell/zellij.nix` | `shell-zellij`(新) |
| `home/wezterm.nix` | `wezterm` | `shell/wezterm.nix` | `shell-wezterm` |

> 同名不冲突:`nixos.shell-zsh` ≠ `homeManager.shell-zsh`;`nixos.core` ≠ `homeManager.core`(namespace 不同)。

### 6.1 命名空间限制与方案(待定 ⏳)

**为什么 `<域>.<单元>` 真实嵌套不行**:`flake.modules` 的选项类型为 `types.lazyAttrsOf (types.lazyAttrsOf types.deferredModule)`,恰好**两层**:

- 第一层 = class(模块类别:`nixos` / `homeManager` / `generic`)—— 本仓库已用作侧别,**且必须保留**:模块最终 import 进 `nixosSystem`(class=nixos)与 home-manager(class=homeManager),模块系统按 `_class` 校验,把域放这一层会在 import 时报 class 不匹配
- 第二层 = name —— 单层扁平键,无第三层位置

实测 `nix eval .#modules.nixos --apply builtins.attrNames` = 31 个扁平名字,证实只有一层。故 `flake.modules.nixos.desktop.niri`(真实三层)不可行。

**可行方案(二选一,待用户定)**:

- **A. 点号字符串名**:`flake.modules.nixos."desktop.niri" = ...`,引用 `self.modules.nixos."desktop.niri"`。观感 = OOP 命名空间。注意:`imports` 里裸字符串会被当作**路径**,因此不能 `with self.modules.nixos; [ "desktop.niri" ]`,必须写全限定名(`let m = self.modules.nixos; in [ m."desktop.niri" ... ]`)。
- **B. kebab 平铺**:`flake.modules.nixos.desktop-niri`。`with` 简写可用、grep 友好;域的视觉分组由文件树(`modules/desktop/`)承担。

> 本文件 §6 两张映射表暂按 B(kebab)书写;若选 A,仅需把 attr 名中的 `-` 换成 `."…."` 形式,结构不变。

## 7. 组合策略

### `core/nixos.nix`(系统侧共享,24 项,按域注释)

```nix
imports = with self.modules.nixos; [
  # boot
  boot-loader boot-kernel
  # desktop
  desktop-kde desktop-xdg
  # environment
  environment-system-packages
  # hardware
  hardware-common hardware-input
  # input-method
  input-method-fcitx5
  # locale
  locale
  # network
  network-base network-dae
  # nix
  nix-settings nix-ld nix-nh nix-overlays
  # programs
  programs-firefox programs-appimage programs-mtr
  # services
  services-gnupg services-pipewire services-power services-printing
  # shell
  shell-zsh
  # users
  users
];
```

### `core/home.nix`(用户侧共享,16 项)

```nix
imports = with self.modules.homeManager; [
  # development
  development-build development-git development-languages development-lazygit development-llm development-lsp development-web
  # environment
  environment-fonts
  # programs
  programs-browsers programs-editors programs-utilities
  # shell
  shell-starship shell-tools shell-wezterm shell-zellij shell-zsh
];
```

### 主机差异(不变)

- **neon**:nixos core + `hardware-neon` + `desktop-niri` + `{ myNixos.boot.loader = "grub"; device = "/dev/sda"; }`;home core + `desktop-noctalia` + `desktop-theme` + `input-method-rime`
- **radon**:nixos core + `hardware-radon` + `hardware-gpu-nvidia` + `services-libvirtd` + `programs-virt-manager` + `{ myNixos.boot.loader = "systemd-boot"; }`;home core + `development-direnv` + `development-dsh` + `environment-session`
- `hosts/*/home.nix` 的 home-manager 桥配置(useGlobalPkgs/useUserPackages/backupFileExtension/extraSpecialArgs)不动

## 8. 内容级修正(行为不变)

1. **boot 拆分**:`loader.nix` 保留 `myNixos.boot` 选项 + 两个 loader 分支;`kernel.nix` 用 `lib.mkIf (config.myNixos.boot.loader == "systemd-boot")` 保留 `linuxPackages_latest`(radon 用 latest、neon 用默认内核,现状不变)
2. **mtr 拆出** `network/base.nix` → `programs/mtr.nix`
3. **firefox 拆出** `packages.nix` → `programs/firefox.nix`;systemPackages → `environment/system-packages.nix`
4. **virt-manager 拆出** `services/libvirtd.nix` → `programs/virt-manager.nix`(radon 需同时引用两个)
5. **shell 拆分**:`shell/zsh.nix` → `shell/zsh/home.nix`(zsh 本体)+ `shell/starship.nix` + `shell/zellij.nix`
6. **niri 迁移**:`features/niri/` → `desktop/niri/`,attr `niri` → `desktop-niri`,桥引用改 `homeManager.desktop-niri`,config.kdl 随目录走
7. **删除** `modules/{nixos,home,features}/` 三个旧目录
8. **clash-verge** 原样保留,不接入

## 9. 执行步骤

1. `git add -A && git commit` —— 固化当前暂存的重构(hosts/ 拆分等),避免新旧混淆
2. 建目标目录,`git mv` 迁移文件(保留 git 历史)
3. 拆分/合并文件内容,逐文件改 `flake.modules.*` 声明
4. 重建 `modules/core/{nixos,home}.nix`
5. 更新 `hosts/neon/default.nix`、`hosts/radon/default.nix`、`hosts/*/home.nix` 引用
6. 删除旧三个目录;`grep -rn "modules\.nixos\|modules\.homeManager" hosts modules` 确认无残留引用
7. `nix flake check` 验证(构建 neon-system / radon-system 两个 toplevel)
8. 提交

## 10. 验证

- `nix flake check`(必须通过;fail 则检查引用与 attr 名)
- 可选:`nixos-rebuild build --flake .#neon` / `.#radon` 实构建
- 行为等价性:对比重构前后 `config.system.build.toplevel` 内容量级(依赖图应基本一致)

## 11. 决策记录

| 决策点 | 结论 |
|---|---|
| 骨架定义 | 仓库根一级目录保持,其下全部可重构(含文件内容) |
| 分类原则 | 按功能域划分;目录 = 平级可选单元;不用 default.nix 聚合器 |
| 架构 | A 案:域内分侧(nixos.nix / home.nix),成对单元单一入口+home 桥 |
| niri | 折入 desktop/(不保留 features/ 目录) |
| 主机硬件 | 移入 hardware/{neon,radon}.nix |
| clash-verge | 原样保留,不接入 |
| 命名 | `flake.modules.<侧别>.<域>-<单元>`,尽量少改(硬件/网络/服务类 attr 基本不变);⏳ 待定:点号字符串 A / kebab 平铺 B(见 §6.1) |
| 组合 | core = 显式共享清单(系统/用户各一),主机差异 = 按需 import |
