{
  flake.modules.homeManager.dev-web = { pkgs, ... }: {
    home.packages = with pkgs; [
      hugo
    ];
  };
}
