{
  description = "my homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    turing-rk1 = {
      url = "github:GiyoMoon/nixos-turing-rk1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      nixos-hardware,
      turing-rk1,
      sops-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      hosts = {
        cm4-node-1 = {
          ip = "10.0.0.11";
          hardware = nixos-hardware.nixosModules.raspberry-pi-4;
        };
        cm4-node-2 = {
          ip = "10.0.0.12";
          hardware = nixos-hardware.nixosModules.raspberry-pi-4;
        };
        rk1-node-1 = {
          ip = "10.0.0.13";
          hardware = turing-rk1.nixosModules.turing-rk1;
        };
        rk1-node-2 = {
          ip = "10.0.0.14";
          hardware = turing-rk1.nixosModules.turing-rk1;
        };
      };

      mkSystem =
        name: host:
        lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit host hosts name;
          };
          modules = [
            host.hardware
            sops-nix.nixosModules.sops
            ./hosts/${name}.nix
          ];
        };

      mkDeploy = name: host: {
        hostname = host.ip;
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.${name};
        };
      };
    in
    {
      nixosConfigurations = lib.mapAttrs mkSystem hosts;

      deploy.nodes = lib.mapAttrs mkDeploy hosts;

      packages.x86_64-linux = {
        default = deploy-rs.packages.x86_64-linux.deploy-rs;
        sops = nixpkgs.legacyPackages.x86_64-linux.sops;
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
