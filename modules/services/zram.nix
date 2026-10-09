# zram:把一部分内存做成压缩的 swap 设备。
# 动机(2026-09-12):radon 此前 swapDevices = [ ],完全无 swap。
# 玩 MC(PrismLauncher/JVM)时内存打满,内核没有任何回旋余地,只能直接
# OOM-kill 掉占用最大的进程。zram 让内核把"冷"的匿名页压缩后继续留在内存里,
# 用 CPU 时间换容量,把"进程被杀死"变成"略微变慢"。
#
# 取舍:zram 不是免费的内存扩容,别把它当堆内存用。
# 压缩/解压有延迟,如果 JVM 堆本身被压进 zram,GC 扫描时会明显卡顿。
# 真正降低 MC 内存占用的办法仍是给 JVM 合理的 -Xmx + Sodium 之类优化,
# zram 只负责兜底(避免被杀进程/整机僵死)。
#
# 参数说明:
#   algorithm     = zstd:压缩比与速度平衡最好(lz4 快但压得少,lzo 压得多但慢)。
#   memoryPercent = 50:zram 设备容量 = 一半物理内存(本机 14GiB → 7GiB)。
#                   这是"能存进去多少未压缩数据"的上限,不是实际占用的内存;
#                   按 zstd 对匿名页约 2~3:1 的压缩比,填满时实际约吃掉 3GiB 物理内存。
#                   想留更多余量可上调,但没有磁盘 swap 兜底时不宜调得过大
#                   (全部压进 zram 反而可能把物理内存耗尽,从"被杀进程"变成整机僵死)。
#   priority      = 默认 5:高于磁盘 swap(内核默认为负),保证先填 zram、再落盘。
{
  flake.modules.nixos.zram = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };
  };
}
