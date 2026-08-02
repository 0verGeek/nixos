{ pkgs, ... }: {
  home.packages = with pkgs; [
    hugo
    gearlever
    font-manager
    # kdePackages.dolphin
  ];
}
