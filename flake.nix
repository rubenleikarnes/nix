{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # Allow install of unfree packages
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.coreutils
          pkgs.curl
          pkgs.fish
          pkgs.fzf
          pkgs.git
          pkgs.kubectl
          pkgs.neovim
          pkgs.nixd # Required for nix-darwin
          pkgs.ollama
          pkgs.openssl
          pkgs.ripgrep # Required for nvim
          pkgs.starship
          pkgs.tldr
        ];

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

      # System settings
      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
            "/Applications/Zen Browser.app"
            "/Applications/Microsoft Outlook.app"
            "/System/Applications/Mail.app"
            "/Applications/Slack.app"
            "/Applications/BusyCal.app"
            "/Applications/1Password.app"
            "/Applications/Zed.app"
            "/Applications/iTerm.app"
            "/Applications/Remote Desktop Manager.app"
            "/Applications/Obsidian.app"
        ];
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
        universalaccess.closeViewScrollWheelToggle = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbp
    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      modules = [
      	configuration
        nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "ruben";
          };
       	}
      ];
    };
  };
}
