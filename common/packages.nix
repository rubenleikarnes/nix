{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    coreutils
    curl
    delta # syntax highlighter for git pager
    fish
    fzf
    gcc
    git
    neovim
    openssl
    ripgrep
    starship
    tldr
    unzip # needed for nvim mason to install stylua
  ];
}
