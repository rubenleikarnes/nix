{
  description = "Multi-system Nix configuration with shared modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew }: 
  {
    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      modules = [
        ./systems/mbp.nix
        ./common/packages.nix
        ./common/homebrew.nix
        ./common/editor.nix
        ./common/shell.nix
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "ruben";
          };
        }
      ];
    };

    homeConfigurations."debian" = home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./systems/debian.nix
        ./common/packages.nix
        ./common/editor.nix
        ./common/shell.nix
      ];
    };
  };
}
