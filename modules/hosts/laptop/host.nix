{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.radon = inputs.nixpkgs.lib.nixosSystem {
    # system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      hostname = "radon";
    };
    modules = [
      self.modules.nixos.radon
      inputs.home-manager.nixosModules.home-manager
    ];
  };

  flake.modules.nixos.radon.imports = with self.modules.nixos; [
    hardware_laptop
    boot_sys
    kde
    X11
    xdg
    hardware
    nvdia
    vm
    chinese
    fcitx5
    dae
    network
    nix
    nix-ld
    nh
    packages
    appimages
    pipewire
    services
    user_camuss
    hm_radon
  ];
}
