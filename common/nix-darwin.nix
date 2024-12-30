{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.coreutils
    pkgs.curl
    pkgs.delta # syntax highlighter for git pager
    pkgs.fish
    pkgs.fzf
    pkgs.git
    pkgs.kubectl
    pkgs.neovim
    pkgs.nixd # Required for nix-darwin
    pkgs.ollama
    pkgs.openssl
    pkgs.ripgrep
    pkgs.starship
    pkgs.tldr
  ];
}
