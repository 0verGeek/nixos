# lib/

纯 Nix 工具函数(不依赖 pkgs、不产生配置副作用)。

社区惯例(参考 Foundry 等配置):把可复用的纯函数放在这里,
例如主题色计算、路径工具、模块辅助函数等,供 modules/ 与 hosts/ 引用。

当前暂无内容,需要时在 `lib/default.nix` 中导出函数。
