{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      # 不配置 credential.helper:nixpkgs 的 git 不提供 git-credential-libsecret
      # 可执行文件(仅 contrib 源码),配了反而每次 https 操作都报错。
      # GitHub 认证统一走 SSH,见各仓库 remote url。
      settings = {
        user = {
          name = "0verGeek";
          email = "3298866863@qq.com";
        };
      };
    };
  };
}
