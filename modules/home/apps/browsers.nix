{
  flake.modules.homeManager.apps-browsers = { pkgs, ... }: {
    home.packages = with pkgs; [
      google-chrome
      folo
    ];
  };
}
