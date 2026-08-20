{
  flake.modules.homeManager.lazygit = { pkgs, ... }: {
    home.packages = with pkgs; [
      lazygit
    ];
  };
}
