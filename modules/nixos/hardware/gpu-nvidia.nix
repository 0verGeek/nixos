{
  flake.modules.nixos.hardware-gpu-nvidia =
    { config, pkgs, ... }:

    {
      # 启用 NVIDIA 专有驱动
      services.xserver.videoDrivers = [ "nvidia" ];

      # 4060 属于较新的卡，通常不需要 legacy 包
      # 如需强制某个分支，可指定：
      # hardware.nvidia.package =
      #   config.boot.kernelPackages.nvidiaPackages.stable;

      # 可选：启用 CUDA / 让 32 位程序能用
      hardware.nvidia.modesetting.enable = true;
      hardware.nvidia.powerManagement.enable = true;
      hardware.graphics.enable = true;
      # 需要 32 位支持时
      hardware.graphics.enable32Bit = true;
      # 可选值：true（开源）/ false（专有）
      hardware.nvidia.open = false;
    };
}
