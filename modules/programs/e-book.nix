{
  flake.modules.homeManager.e-book = { pkgs, ... }: {
    home.packages = with pkgs; [
      calibre
      readest
      koodo-reader
      koreader
    ];
  };
}
