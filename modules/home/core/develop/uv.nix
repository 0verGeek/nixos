{
  flake.modules.homeManager.uv = {
    programs.uv = {
      enable = true;
      python = {
        version = "3.14";
      };
    };
  };
}
