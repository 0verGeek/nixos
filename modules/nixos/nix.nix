{
  flake.modules.nixos.nix = { inputs, ... }: {
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://deepseek-harness-nix.cachix.org"
      ];
      trusted-users = [
        "root"
        "camuss"
      ];
      trusted-public-keys = [
        "deepseek-harness-nix.cachix.org-1:5NrkwLN9veNMhiINtU5ZeV4isXFhFsOwn6Ms7J1M+TA="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = true;
      min-free = 500;
      max-free = 1000;
    };

    # 纯 flake 工作流不需要 channel
    nix.channel.enable = false;
    # 让 `nix run nixpkgs#<pkg>` 解析到本 flake 锁定的 nixpkgs
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
  };
}
