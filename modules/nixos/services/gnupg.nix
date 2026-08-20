{
  flake.modules.nixos.services-gnupg = {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
