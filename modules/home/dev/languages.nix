{
  flake.modules.homeManager.dev-languages = { pkgs, ... }: {
    home.packages = with pkgs; [
      rustup
      uv
      nodejs
      python3
    ];

    programs.uv.enable = true;
  };
}
