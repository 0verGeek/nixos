{
  flake.modules.nixos.hardware-input = {
    services.libinput.enable = true;
  };
}
