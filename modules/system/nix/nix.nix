{
  flake.modules.nixos.nix = {
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
    };
  };
}
