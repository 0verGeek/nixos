{
  flake.modules.nixos.clash-verge = {
    programs.clash-verge = {
      enable = true;
      serviceMode = true;
      tunMode = true;
      autoStart = true;
    };
  };
}
