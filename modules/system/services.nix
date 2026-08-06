{
  flake.modules.nixos.services = {
    programs.zsh.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.printing.enable = true;
    services.xserver.libinput.enable = true;
  };
}
