{
  flake.modules.nixos.system-packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wget
      curl
      gcc
      clang
      dmg2img
      libinput
      wine
    ];
  };
}
