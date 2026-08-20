# pkgs/

自定义包(不在 nixpkgs 中的软件,或 nixpkgs 版本需要覆盖的软件)。

社区惯例:每个包一个目录,`default.nix` 用 `callPackage` 风格编写,
通过 overlay(见 overlays/)注入 `pkgs` 供全配置使用。

当前暂无自定义包。
