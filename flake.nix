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
          pkgs.bat # modern cat alternative
          pkgs.caddy
          pkgs.coreutils
          pkgs.curl
          pkgs.fd
          pkgs.ffmpeg
          pkgs.fish
          pkgs.fzf
          pkgs.delta
          pkgs.git
          pkgs.gitu # git tui inspired by magit
          pkgs.helix
          pkgs.inetutils # telnet etc, from apple
          pkgs.kubectl
          pkgs.neovim
          pkgs.nixd # Required for nix-darwin
          pkgs.nmap
          pkgs.ollama
          pkgs.openssl
          pkgs.ripgrep # Required for nvim
          pkgs.sshpass # Required for AT300 config push
          pkgs.starship
          pkgs.stern
          pkgs.tmux
          pkgs.tldr
          pkgs.wget
          pkgs.yt-dlp
          pkgs.zoxide
        ];

      # Homebrew
      homebrew = {
        enable = true;
        brews = [
            "mas" # Mac App Store CLI
            "fisher" # Fish plugin manager
            "rafi/tap/kubectl-config-import" # Tool for importing kubectl config files
        ];
        casks = [
            "1password"
            "alfred"
            "arc"
            "balenaetcher"
            "brave-browser"
            "appgate-sdp-client"
            "base" # sqlite editor
            "busycal"
            "chatgpt"
            "claude" # ai
            "colorsnapper"
            "discord"
            "docker-desktop"
            "figma"
            "firefox"
            "font-ibm-plex-mono"
            "font-inter"
            "font-jetbrains-mono-nerd-font"
            "font-sf-pro"
            "forklift"
            "github"
            "ghostty"
            "google-chrome"
            "handbrake-app"
            "imageoptim"
            "istat-menus"
            "iterm2"
            "microsoft-auto-update"
            "microsoft-office-businesspro"
            "netnewswire"
            "obsidian"
            "ollama-app"
            "postman"
            "rectangle"
            "remote-desktop-manager"
            "slack"
            "spotify"
            "sync"
            "switchresx"
            "tailscale-app"
            "tunnelblick"
            "teamviewer"
            "the-unarchiver"
            "utm"
            "vlc"
            "waterfox-classic"
            "whatsapp"
            "wireshark-app"
            "zed"
            "zen"
        ];
        taps = [
          "rafi/tap" # https://github.com/rafi/kubectl-config-import
        ];
        masApps = {
          Ivory = 6444602274;
          Hyperspace = 6739505345;
          Things3 = 904280696;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      system.primaryUser = "ruben";

      # System settings
      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
            "/Applications/Zen.app"
            "/Applications/Microsoft Outlook.app"
            "/System/Applications/Mail.app"
            "/Applications/Slack.app"
            "/Applications/BusyCal.app"
            "/Applications/Things3.app"
            "/Applications/1Password.app"
            "/Applications/Zed.app"
            "/Applications/Ghostty.app"
            "/Applications/Github Desktop.app"
            "/Applications/Remote Desktop Manager.app"
            "/Applications/Obsidian.app"
            "/Applications/ChatGPT.app"
        ];
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
          # universalaccess.closeViewScrollWheelToggle = true;
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
