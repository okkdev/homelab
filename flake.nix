{
  description = "my homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    deploy-rs.url = "github:serokell/deploy-rs";
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
      ...
    }:
    {
      nixosConfigurations = {
        cm4-node-1 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./hosts/cm4-node-1.nix
          ];
        };
        cm4-node-2 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./hosts/cm4-node-2.nix
          ];
        };
        rk1-node-1 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            turing-rk1.nixosModules.turing-rk1
            ./hosts/rk1-node-1.nix
          ];
        };
        rk1-node-2 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            turing-rk1.nixosModules.turing-rk1
            ./hosts/rk1-node-2.nix
          ];
        };
      };

      deploy.nodes = {
        cm4-node-1 = {
          hostname = "10.0.0.11";
          profiles.system = {
            sshUser = "root";
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.cm4-node-1;
          };
        };
        cm4-node-2 = {
          hostname = "10.0.0.12";
          profiles.system = {
            sshUser = "root";
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.cm4-node-2;
          };
        };
        rk1-node-1 = {
          hostname = "10.0.0.13";
          profiles.system = {
            sshUser = "root";
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rk1-node-1;
          };
        };
        rk1-node-2 = {
          hostname = "10.0.0.14";
          profiles.system = {
            sshUser = "root";
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rk1-node-2;
          };
        };
      };

      packages.x86_64-linux = {
        deploy-rs = deploy-rs.packages.x86_64-linux.deploy-rs;
        default = self.packages.x86_64-linux.deploy-rs;
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
