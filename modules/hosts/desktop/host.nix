{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.neon = inputs.nixpkgs.lib.nixosSystem {
    # system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      disk = "/dev/sda";
      hostname = "neon";
    };
    modules = [
      self.modules.nixos.neon
      inputs.home-manager.nixosModules.home-manager
    ];
  };

  flake.modules.nixos.neon.imports = with self.modules.nixos; [
    hardware_desktop
    boot_grub
    kde
    niri
    X11
    xdg
    bluetooth
    graphics
    chinese
    fcitx5
    dae
    network
    nix-settings
    nix-ld
    nixpkgs
    nh
    packages
    appimages
    pipewire
    power
    print
    shell_zsh
    user_camuss
    home-manager
  ];
}
