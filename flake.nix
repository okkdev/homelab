{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations = {
      nix-node-1 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./machines/nix-node-1.nix ];
      };
      nix-node-2 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./machines/nix-node-2.nix ];
      };
    };

    deploy.nodes = {
      nix-node-1 = {
        hostname = "10.0.0.11";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos
            self.nixosConfigurations.nix-node-1;
        };
      };
      nix-node-2 = {
        hostname = "10.0.0.12";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos
            self.nixosConfigurations.nix-node-2;
        };
      };

    };

  };
}
