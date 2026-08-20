# 临时修复:上游 linkKernelNodeModules 会把 bundle 中所有与 kernel 重名的
# 包替换成 kernel 版本,但 dsh-tui 是外部仓库的 bundle,其第三方依赖有自己的
# 版本要求(kernel 是 react 18.3.1 / scheduler 0.23.2 / 旧版 ansi-styles,
# 而 dsh-cc-tui 是 React Compiler 产物,需要 react >= 19.1,reconciler 0.33
# 需要 scheduler ^0.27,ansi-tokenize 需要 ansi-styles 4.x API)。
# 这里重写 postInstall:只对 @deepseek-ai/* 单仓包做 kernel 锁定(保持上游
# 原意的 lockstep),第三方依赖保留 bundle 自己的版本。
# 上游修复后应删除本文件及 packages.nix 中的引用。
final: prev:
let
  inherit (final.lib) getExe;
in
{
  dsh = prev.dsh.overrideScope (
    self: super: {
      bundles = super.bundles // {
        tui = super.bundles.tui.overrideAttrs (old: {
          postInstall = ''
            bundleRoot="$out/lib/node_modules"
            kernelNM="${super.dsh-kernel}/lib/deepseek-harness/node_modules"

            # 仅对 kernel 持有的 @deepseek-ai/* 包做版本锁定,第三方依赖不动
            for entry in "$kernelNM"/@deepseek-ai/*; do
              [ -d "$entry" ] || continue
              pkg="@deepseek-ai/$(basename "$entry")"

              rm -rf "$bundleRoot/$pkg"
              find "$bundleRoot" -depth \( -type d -o -type l \) \
                -path "*/node_modules/$pkg" -exec rm -rf {} + 2>/dev/null || true

              mkdir -p "$bundleRoot/@deepseek-ai"
              ln -s "$kernelNM/$pkg" "$bundleRoot/$pkg"
            done

            # 清理悬空软链(如 .bin 中的失效项)
            find "$bundleRoot" -depth -type l ! -exec test -e {} \; -delete 2>/dev/null || true

            # 重新生成 bundle manifest(替代上游的 validateInstalledBundle)
            mkdir -p "$out/nix-support"
            ${getExe super.buildDshBundle.dshBundleResolver} manifest \
              "$out/nix-support/dsh-bundles.json" \
              "$bundleRoot"
          '';
        });
      };
    }
  );
}
