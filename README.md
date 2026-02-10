# My homelab

## Deploy

All nodes

```sh
nix run
```

Specific node

```sh
nix run . -- .#cm4-node-1
```

## Secrets

```sh
nix run .#sops -- secrets/file
```
