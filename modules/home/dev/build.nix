{
  flake.modules.homeManager.dev-build = { pkgs, ... }: {
    home.packages = with pkgs; [
      gnumake
      cmake
      unzip
    ];
  };
}
