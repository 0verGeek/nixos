{
  flake.modules.homeManager.session =
    { pkgs, ... }:
    {
      home.sessionPath = [ "$HOME/.local/bin" ];
      # 或
      # home.sessionVariables = { PATH = "$HOME/.local/bin:$PATH"; };
    };
}
