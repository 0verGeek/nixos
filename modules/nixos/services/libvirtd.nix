{
  flake.modules.nixos.services-libvirtd = { pkgs, ... }: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu;
        runAsRoot = true;
      };
    };
    programs.virt-manager.enable = true;

    boot.kernelModules = [ "kvm-amd" ];

    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options kvm_amd emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };
}
