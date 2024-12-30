{ pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils
    curl
    delta # syntax highlighter for git pager
    fastfetch
    fish
    fzf
    gcc
    git
    neovim
    ripgrep
    starship
    tldr
    unzip # needed for nvim mason to install stylua
  ];
}
