{
  flake.modules.homeManager.e-book = { pkgs, ... }: {
    home.packages = with pkgs; [
      calibre
      koodo-reader
    ];
  };
}
