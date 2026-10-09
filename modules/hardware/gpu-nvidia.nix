{
  flake.modules.nixos.gpu-nvidia =
    { config, pkgs, ... }:

    {
      # 启用 NVIDIA 专有驱动
      services.xserver.videoDrivers = [ "nvidia" ];

      # 4060 属于较新的卡，通常不需要 legacy 包
      # 如需强制某个分支，可指定：
      # hardware.nvidia.package =
      #   config.boot.kernelPackages.nvidiaPackages.stable;

      hardware.graphics.enable = true;
      hardware.graphics.extraPackages = with pkgs; [
        mesa.drivers
        # 以及你的 NVIDIA 驱动包
      ];
      # 需要 32 位支持时
      hardware.graphics.enable32Bit = true;
      # 可选值：true（开源）/ false（专有）
      hardware.nvidia = {
        open = true;
        modesetting.enable = true;
        powerManagement.enable = true;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          amdgpuBusId = "PCI:65:0:0"; # 替换为实际值
          nvidiaBusId = "PCI:1:0:0"; # 替换为实际值
        };
      };
    };
}
