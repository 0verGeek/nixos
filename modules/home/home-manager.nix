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
          dev
          fonts
          git
          llm-agent
          rime
          shell
          wezterm
          theme
          niri
          noctalia
          editor
          packages
        ];
        programs.home-manager.enable = true;
      };
    };
  };
}
