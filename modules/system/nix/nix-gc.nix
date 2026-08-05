{
  flake.modules.nixos.nix-gc = {
    # 每周自动清理
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
