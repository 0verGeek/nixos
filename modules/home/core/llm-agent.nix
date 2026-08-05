{
  flake.modules.homeManager.llm-agent = { inputs, pkgs, ... }: {
    home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      claude-code
      cc-switch-cli
      # ... other tools
    ];
  };
}
