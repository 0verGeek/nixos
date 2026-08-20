{
  description = "NixOS configurations for radon (laptop) and neon (desktop)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.url = "github:Qumulo/llm-agents";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";
    deepseek-harness.url = "github:moraxyc/deepseek-harness.nix";
    deepseek-harness.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
        (inputs.import-tree ./hosts)
      ];
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        {
          # `nix fmt` 格式化(nixfmt-tree 支持目录遍历)
          formatter = pkgs.nixfmt-tree;
        };
    };
}
