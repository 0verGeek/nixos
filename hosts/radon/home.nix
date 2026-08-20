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
          core
          # 本机差异 = 按需 import
          dev-direnv
          dev-dsh
          env
        ];
        programs.home-manager.enable = true;
      };
    };
  };
}
