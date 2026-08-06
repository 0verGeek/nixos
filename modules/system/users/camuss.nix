{
  flake.modules.nixos.user_camuss = { pkgs, ... }: {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."camuss" = {
      isNormalUser = true;
      description = "Camuss";
      extraGroups = [
        "networkmanager"
        "wheel"
        "inputs"
      ];
      shell = pkgs.zsh;
    };
    system.stateVersion = "26.05";
  };
}
