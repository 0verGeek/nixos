{
  flake.modules.homeManager.dev-lazygit = { pkgs, ... }: {
    home.packages = with pkgs; [
      lazygit
    ];
  };
}
