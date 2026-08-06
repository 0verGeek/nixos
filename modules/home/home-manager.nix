{ self, ... }: {
  flake.modules.nixos.home-manager = { inputs, ... }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "%Y%m%d-%H%M%S.bak";
      extraSpecialArgs = { inherit inputs; }; # If you want access to inputs in your home.nix
      users.camuss = {
        home.username = "camuss";
        home.homeDirectory = "/home/camuss";
        home.stateVersion = "26.05";
        imports = with self.modules.homeManager; [
          dev-tools
          dev-llm
          dev-python
          fonts
          git
          rime
          zsh
          shell-tools
          wezterm
          theme
          niri
          noctalia
          editors
          misc
        ];
        programs.home-manager.enable = true;
      };
    };
  };
}
