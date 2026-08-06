{
  flake.modules.nixos.nix = {
    nixpkgs.config.allowUnfree = true;
    nix.settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
