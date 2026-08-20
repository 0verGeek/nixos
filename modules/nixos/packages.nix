{
  flake.modules.nixos.packages = { pkgs, ... }: {
    programs.firefox.enable = true;

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
