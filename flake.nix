{
  description = "My NixOS system flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixarr = {
      url = "github:rasmus-kirk/nixarr";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    zen-browser.url = "github:youwen5/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    nixarr,
    catppuccin,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    packages.${system} = {
      #   beeper-beta = import ./pkgs/beeper-beta.nix {
      #     inherit lib;
      #     appimageTools = pkgs.appimageTools;
      #     fetchurl = pkgs.fetchurl;
      #     makeWrapper = pkgs.makeWrapper;
      #     libsecret = pkgs.libsecret;
      #   };
    };

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
          inputs.home-manager.nixosModules.default
          catppuccin.nixosModules.catppuccin
          # {environment.systemPackages = [self.packages.${system}.beeper-beta];}
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
          inputs.home-manager.nixosModules.default
          catppuccin.nixosModules.catppuccin
          # {environment.systemPackages = [self.packages.${system}.beeper-beta];}
        ];
      };
    };
  };
}
