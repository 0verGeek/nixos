{
  flake.modules.homeManager.dev-python = {
    programs.uv = {
      enable = true;
      python = {
        version = "3.14";
      };
    };
  };
}
