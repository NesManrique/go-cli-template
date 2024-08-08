{
  description = "Go cli project template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (import ./overlays/default.nix)
        ];

        pkgs = import nixpkgs {
          inherit system overlays;
        };

        name = "go-cli-template";

        description = "Template to create go cli projects";

        version = pkgs.lib.fileContents ./VERSION;

        module = "github.com/NesManrique/go-cli-template";

        submodule = ".";

        tags = [ ];

        ldflags = [
          "-X main.Version=${version}"
        ];

        nix-src = nix-filter.lib.filter {
          root = ./.;
          include = [
            (nix-filter.lib.matchExt "nix")
          ];
        };

        src = nix-filter.lib.filter {
          root = ./.;
          include = with nix-filter.lib;[
            "./go.mod"
            "./go.sum"
            (inDirectory "vendor")
            isDirectory
            (nix-filter.lib.matchExt "go")
          ];
        };

        checkDeps = with pkgs; [
        ];

        buildInputs = with pkgs; [
        ];

        nativeBuildInputs = with pkgs; [
        ];

        nix-lib = import ./nix/lib.nix { inherit pkgs; };

      in
      {
        checks = flake-utils.lib.flattenTree rec {
          nixpkgs-fmt = nix-lib.nix.check { src = nix-src; };

          go-checks = nix-lib.go.check {
            inherit src submodule ldflags tags buildInputs nativeBuildInputs checkDeps;
          };
        };

        devShells = flake-utils.lib.flattenTree rec {
          default = nix-lib.go.devShell {
            buildInputs = with pkgs; [
              go
              golangci-lint
              mockgen
              golines
              govulncheck
            ];
          };
        };

        packages = flake-utils.lib.flattenTree rec {
          go-cli-template = nix-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
          };

          go-cli-template-arm64-darwin = (nix-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "darwin"; GOARCH = "arm64"; });

          go-cli-template-amd64-darwin = (nix-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "darwin"; GOARCH = "amd64"; });

          go-cli-template-arm64-linux = (nix-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "linux"; GOARCH = "arm64"; });

          go-cli-template-amd64-linux = (nix-lib.go.package {
            inherit name src version ldflags buildInputs nativeBuildInputs;
            cgoEnabled = 0;
          }).overrideAttrs (old: old // { GOOS = "linux"; GOARCH = "amd64"; });

          docker-image = nix-lib.go.docker-image {
            inherit name version buildInputs;

            package = go-cli-template;
          };

          default = go-cli-template;
        };

      });
}
