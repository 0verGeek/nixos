{
  flake.modules.homeManager.web = { pkgs, ... }: {
    home.packages = with pkgs; [
      hugo
    ];
  };
}
