{
  flake.modules.homeManager.dev-llm = { inputs, pkgs, codewhale, ... }: {
    home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      claude-code
      cc-switch-cli
      hermes-desktop

    ];
    environment.systemPackages = [ codewhale.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
