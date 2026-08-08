{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings.user = {
        name = "0verGeek";
        email = "3298866863@qq.com";
      };
      extraConfig = {
        credential = {
          helper = "libsecret";
        };
      };
    };
  };
}
