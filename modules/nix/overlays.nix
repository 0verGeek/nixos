{
  flake.modules.nixos.overlays = { inputs, ... }: {
    nixpkgs.overlays = [
      inputs.deepseek-harness.overlays.default
      # 临时:dsh-tui 第三方依赖被 kernel 旧版本覆盖,见 overlays/dsh-tui-fix.nix
      (import ../../overlays/dsh-tui-fix.nix)
    ];
  };
}
