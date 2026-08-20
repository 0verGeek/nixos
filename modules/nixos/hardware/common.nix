{
  flake.modules.nixos.hardware-common = {
    hardware.bluetooth.enable = true;
    hardware.graphics.enable = true;
  };
}
