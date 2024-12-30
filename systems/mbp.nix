{ config, pkgs, ... }:
{
  # Allow unfree software to be installed
  nixpkgs.config.allowUnfree = true;

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

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
