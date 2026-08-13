{
  flake.modules.nixos.services = { pkgs, ... }: {
    programs.zsh.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        hplip
      ];
    };
    services.libinput.enable = true;
  };
}
