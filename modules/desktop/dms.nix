{
  flake.modules.nixos.dms = { inputs, ... }: {
    imports = [ inputs.dms-plugin-registry.nixosModules.default ];

    programs.dms-shell = {
      enable = true;
      # package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)

      plugins = {
        wallpaperCarousel.enable = true;
        bongoCat.enable = true;
        screenkey.enable = true;
        # Simply enable plugins by their ID (from the registry)
      };
    };
  };
}
