{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    ags.url = "github:Aylur/ags";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      laptop = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          machineName = "laptop";
        };
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      home-server = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          machineName = "home-server";
        };
        modules = [
          ./hosts/home-server/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
