{ pkgs }:
{
  go = import ./go.nix { inherit pkgs; };
  nix = import ./nix.nix { inherit pkgs; };
}
