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

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    nixarr.url = "github:rasmus-kirk/nixarr";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # vpnconfinement.url = "github:Maroka-chan/VPN-Confinement";
    # vpnconfinement.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    nixarr,
    # vpnconfinement,
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
          inherit spicetify-nix;
          machineName = "laptop";
        };

        modules = [
          ./hosts/laptop/configuration.nix
          ./modules/personal-computers/home-manager/spicetify.nix
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
          nixarr.nixosModules.default
          # vpnconfinement.nixosModules.default
        ];
      };
      desktop = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit spicetify-nix;
          machineName = "desktop";
        };

        modules = [
          ./hosts/desktop/configuration.nix
          ./modules/personal-computers/home-manager/spicetify.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
