{
  flake.modules.homeManager.llm = { inputs, pkgs, ... }: {
    home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      claude-code
      cc-switch-cli
      hermes-one
      hermes-agent
    ];
  };
}
