{
  flake.modules.homeManager.theme = { pkgs, ... }: {
    home.packages = with pkgs; [
      papirus-icon-theme
      hicolor-icon-theme
      qt6Packages.qt6ct
    ];

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.adwaita-icon-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };
  };
}
