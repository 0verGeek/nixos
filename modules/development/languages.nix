{
  flake.modules.homeManager.languages = { pkgs, ... }: {
    home.packages = with pkgs; [
      rustup
      uv
      nodejs
      python3
      pnpm
    ];

    programs.uv.enable = true;
  };
}
