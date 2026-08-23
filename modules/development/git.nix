{
  flake.modules.homeManager.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "0verGeek";
          email = "3298866863@qq.com";
        };
        credential = {
          helper = "libsecret";
        };
      };
    };
    home.packages = with pkgs; [ libsecret ];
  };
}
