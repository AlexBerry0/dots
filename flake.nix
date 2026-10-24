{
  description = "Alex's Apple Silicon MacBook Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    darwin,
    home-manager,
    ...
  }: let
    settings = import ./settings.nix;
    macbook = darwin.lib.darwinSystem {
      system = settings.system;
      specialArgs = {inherit inputs settings;};
      modules = [
        ./hosts/macbook/default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs settings;};
            users.${settings.username} = import ./users/alexberry/home.nix;
          };
        }
      ];
    };
  in {
    darwinConfigurations.${settings.hostName} = macbook;
    checks.${settings.system}.configuration = import ./checks.nix {
      inherit settings;
      pkgs = macbook.pkgs;
      homeConfig = macbook.config.home-manager.users.${settings.username};
    };
    formatter.${settings.system} = macbook.pkgs.alejandra;
  };
}
