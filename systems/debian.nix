{ config, pkgs, ... }:
{
  # Enable Home Manager
  programs.home-manager.enable = true;

  # Allow unfree software to be installed
  nixpkgs.config.allowUnfree = true;

  # Specify the Nix package to use
  nix.package = pkgs.nix;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ruben";
  home.homeDirectory = "/home/ruben";

  home.packages = with pkgs; [
    coreutils
    curl
    delta # syntax highlighter for git pager
    fish
    fzf
    gcc
    git
    neofetch
    neovim
    ripgrep
    starship
    tldr
    unzip # needed for nvim mason to install stylua
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Enable flakes and nix-command on Debian
  nix.settings.experimental-features = "nix-command flakes";
}
