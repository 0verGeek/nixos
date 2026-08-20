{ self, ... }: {
  flake.modules.nixos.hm-neon = { inputs, ... }: {
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
          # ── desktop ──
          noctalia
          theme
          # ── input-method ──
          rime
          # (niri 已由系统侧特性模块经桥注入,不在此重复)
        ];
        programs.home-manager.enable = true;
      };
    };
  };
}
