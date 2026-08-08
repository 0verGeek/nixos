{
  flake.modules.nixos.nix-ld = { pkgs, ... }: {
    # Enable nix-ld
    programs.nix-ld = {
      enable = true;
      # 基础库，Zed 的 LSP 常用
      libraries = with pkgs; [
        libsecret
        libX11
        libsoup_3
        # glib-networking
        gsettings-desktop-schemas
        libglibutil
        librsvg
        libappindicator-gtk3
        libnotify
        # dbus-glib
        atk
        at-spi2-atk
        pcre
        libxkbcommon
        gtk3
        pango
        cairo
        gdk-pixbuf
        libXcursor
        fuse
        zlib
        freetype
        libxcb
        expat
        harfbuzz
        libgpg-error
        libGL
        gnutls
        zstd
        stdenv.cc.cc
        fontconfig
        alsa-lib
        curl
        openssl
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd
        fontconfig
      ];
    };
  };
}
