{
  flake.modules.nixos.packages = { pkgs, ... }: {
    programs.firefox.enable = true;
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      neovim
      wget
      curl
      xwayland-satellite
      hicolor-icon-theme
      gcc
      clang
    ];
  };
}
