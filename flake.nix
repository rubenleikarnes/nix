{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # unstable channel for latest pkgs
    nix-darwin.url = "github:LnL7/nix-darwin"; # nix-darwin module system
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs"; # follow nixpkgs version
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; # nix-homebrew integration
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true; # allow installation of unfree packages

      environment.systemPackages =  # global installes from nix packages
        [
          pkgs.bat # modern cat alternative
          pkgs.caddy # web server / reverse proxy
          pkgs.coreutils # GNU core utilities
          pkgs.curl # http tool
          pkgs.eza # modern alternative for ls
          pkgs.fd # fast alternative to find
          pkgs.ffmpeg # video toolkit
          pkgs.fish # current shell favorite
          pkgs.fzf # fuzzy finder
          pkgs.delta # better git diff viewer
          pkgs.git # version control
          pkgs.gitu # git tui
          pkgs.helix # nvim alternative
          pkgs.inetutils # telnet, ftp, etc (from apple)
          pkgs.kubectl # k8s cli
          pkgs.neovim # vim alternative
          pkgs.nixd # nix language server (required by nix)
          pkgs.nmap # network scanner
          pkgs.ollama # local llm runner
          pkgs.openssl # tls/ssl toolkit
          pkgs.ripgrep # fast grep (required by nvim)
          pkgs.sshpass # non-interactive ssh password (required for AT300 config push)
          pkgs.starship # shell prompt
          pkgs.stern # tail logs from k8s pods
          pkgs.tmux # terminal multiplexer
          pkgs.tldr # simplified man pages
          pkgs.wget # cli downloader
          pkgs.yt-dlp # youTube downloader
          pkgs.zoxide # smarter cd replacement
        ];

      homebrew = { # manage homebrew packages/casks/apps
        enable = true;
        brews = [
            "mas" # Mac App Store cli
            "fisher" # fish plugin manager
            "rafi/tap/kubectl-config-import" # tool for importing kubectl config files
        ];
        casks = [
          "1password" # password manager
          "alfred" # spotlight alternative
          "arc" # chrome alternative
          "balenaetcher" # bootable usb creator
          "brave-browser" # another chrome alternative
          "appgate-sdp-client" # work vpn
          "base" # sqlite editor
          "busycal" # calendar app
          "chatgpt" # openai desktop client
          "claude" # anthropic desktop client
          "colorsnapper" # color picker tool
          "discord" # chat
          "docker-desktop" # container platform
          "figma" # photoshop alternative
          "firefox" # browser
          "font-ibm-plex-mono" # dev font
          "font-inter" # ui font
          "font-jetbrains-mono-nerd-font" # dev font
          "font-sf-pro" # apple system font
          "forklift" # ftp client
          "github" # github Desktop
          "ghostty" # terminal emulator
          "google-chrome" # browser
          "handbrake-app" # ffmpeg gui
          "imageoptim" # image optimizer
          "istat-menus" # menu bar system monitor
          "iterm2" # terminal emulator
          "microsoft-auto-update" # updater for ms apps
          "microsoft-office-businesspro" # ms office
          "netnewswire" # rss reader
          "obs" # streaming
          "obsidian" # markdown notes
          "ollama-app" # openai app
          "postman" # api tool
          "rapidapi" # alternative to postman, native macos app
          "rectangle" # window manager
          "remote-desktop-manager" # rdp client
          "slack" # work chat
          "spotify" # music
          "sync" # file sync
          "switchresx" # display control
          "tailscale-app" # vpn
          "tunnelblick" # openvpn client
          "teamviewer" # remote desktop
          "thebrowsercompany-dia" # ai browser from arc creators
          "the-unarchiver" # archive extractor
          "utm" # virtual machine app
          "vlc" # media player
          "waterfox-classic" # legacy browser
          "whatsapp" # messaging
          "wireshark-app" # network packet analyzer
          "zed" # code editor
          "zen" # firefox alternative
        ];
        taps = [
          "rafi/tap" # kubectl-config-import tap https://github.com/rafi/kubectl-config-import
        ];
        masApps = {
          Ivory = 6444602274; # mastodon client
          Hyperspace = 6739505345; # disk space reclaimer
          Things3 = 904280696; # task manager
        };
        onActivation.cleanup = "zap"; # removes old versions, caches etc
        onActivation.autoUpdate = true; # updates before install
        onActivation.upgrade = true; # auto upgrade
      };

      system.primaryUser = "ruben";

      # System settings
      system.defaults = {
        dock.autohide = true; # hide dock
        dock.persistent-apps = [ # pinned apps
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
            "/Applications/Claude.app"
        ];
        loginwindow.GuestEnabled = false; # disable guest login
        NSGlobalDomain.AppleICUForce24HourTime = true; # 24h clock
        NSGlobalDomain.AppleInterfaceStyle = "Dark"; # dark mode
        NSGlobalDomain.KeyRepeat = 2; # fast key repeat
        # universalaccess.closeViewScrollWheelToggle = true; # zoom toggle
      };

      nix.settings.experimental-features = "nix-command flakes"; # enable flakes & nix-command
      programs.fish.enable = true; # enable Fish shell in nix-darwin
      system.configurationRevision = self.rev or self.dirtyRev or null; # track flake git revision

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      nixpkgs.hostPlatform = "aarch64-darwin"; # target platform (Apple Silicon)
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
            enable = true; # enable nix-homebrew
            enableRosetta = true; # allow x86_64 apps on arm64
            user = "ruben"; # link Homebrew to user account
          };
       	}
      ];
    };
  };
}
