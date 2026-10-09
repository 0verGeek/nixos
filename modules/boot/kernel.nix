{
  flake.modules.nixos.kernel = {
    boot.kernelParams = [
      "usbcore.quirks=057e:2009:ik"
      # 受控实验(2026-09-07):禁用 eDP PSR,规避 amdgpu 新 ISM 路径的
      # power_psr.c:236 WARN 导致 niri 会话启动即画面冻结的问题。
      # 验证:重启进 niri 后 `journalctl -b -k | grep -c mod_power_set_psr_event` 应为 0。
      # 若上游修复合入(amdgpu ISM bugfix),可移除本参数。
      "amdgpu.dcdebugmask=0x10"
    ];
  };
}
