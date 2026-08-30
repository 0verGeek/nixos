{
  flake.modules.nixos.kernel = {
    boot.kernelParams = [
      "usbcore.quirks=057e:2009:ik"
    ];
  };
}
