{
  flake.modules.nixos.system-packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wget
      curl
      xwayland-satellite
      gcc
      clang
      dmg2img
      libinput
    ];
  };
}
