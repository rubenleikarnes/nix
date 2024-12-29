{ pkgs, ... }:
{
  # Homebrew
  homebrew = {
    enable = true;
    brews = [
      "mas" # Mac App Store CLI
      "fisher" # Fish plugin manager
      "rafi/tap/kubectl-config-import" # Tool for importing kubectl config files
      "rbenv" # Required for asdf to work with ruby
      "ruby-build" # Required for rbenv install to work
    ];
    casks = [
      "1password"
      "alfred"
      "brave-browser"
      "appgate-sdp-client"
      "busycal"
      "colorsnapper"
      "figma"
      "font-ibm-plex-mono"
      "font-inter"
      "font-jetbrains-mono-nerd-font"
      "font-sf-pro"
      "github"
      "google-chrome"
      "handbrake"
      "istat-menus"
      "iterm2"
      "microsoft-office-businesspro"
      "netnewswire"
      "obsidian"
      "ollama"
      "rectangle"
      "remote-desktop-manager"
      "slack"
      "spotify"
      "sync"
      "switchresx"
      "tailscale"
      "the-unarchiver"
      "vlc"
      "whatsapp"
      "zed"
      "zen-browser"
    ];
    taps = [
      "rafi/tap"
    ];
    masApps = {
      Ivory = 6444602274;
      Things3 = 904280696;
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
