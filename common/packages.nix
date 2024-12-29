{ config, pkgs, lib, ... }:

let
  commonPackages = [
    pkgs.coreutils
    pkgs.curl
    pkgs.delta # syntax highlighter for git pager
    pkgs.fish
    pkgs.fzf
    pkgs.gcc
    pkgs.git
    pkgs.neovim
    pkgs.openssl
    pkgs.ripgrep
    pkgs.starship
    pkgs.tldr
    pkgs.unzip # needed for nvim mason to install stylua
  ];
in
{
  # For Nix-Darwin (macOS), use environment.systemPackages
  # This will apply only to the macOS (nix-darwin) configuration
  # nix-darwin.systemPackages = lib.mkIf (config.system.isDarwin) commonPackages;

  # For Home Manager (Debian), use home.packages
  # This will apply only to the Debian configuration
  #  home.packages = lib.mkIf (config.system.isLinux) commonPackages;
  home.packages = commonPackages;

  # Make sure to set nix.package for both Nix-Darwin and Home Manager
  nix.package = pkgs.nix;
}
