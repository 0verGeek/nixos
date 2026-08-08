{
  flake.modules.nixos.kde = {
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.displayManager.defaultSession = null;
    services.desktopManager.plasma6.enable = true;
  };
}
