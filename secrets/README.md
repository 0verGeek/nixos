# secrets/

敏感配置存放目录,配合 sops-nix 使用。

社区惯例(sops-nix):
- 本目录存放 **age 公钥**(`*.pub` / `keys.yaml` 可提交)和 sops 加密文件(如 `secrets.yaml`)
- **age 私钥绝不提交**,放在机器本地(如 `/etc/sops-nix/keys.txt` 或用户 keyring)
- 使用方式参考 sops-nix 模块:
  ```nix
  sops.secrets."dsh-env" = { };
  services.dsh.environmentFile = "/run/secrets/dsh-env";
  ```

当前尚无敏感配置需要纳入(dae 的 /etc/dae/config.dae 仍在仓库外,建议后续纳入)。
