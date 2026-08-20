{ self, ... }: {
  flake.modules.nixos.hm-radon = { inputs, ... }: {
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
          # core:共享组合
          core
          # ── development ──
          direnv
          # ── environment ──
          session
        ];
        programs.home-manager.enable = true;
      };
    };
  };
}
