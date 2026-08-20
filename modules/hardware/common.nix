{
  flake.modules.nixos.common = {
    hardware.bluetooth.enable = true;
    hardware.graphics.enable = true;
  };
}
