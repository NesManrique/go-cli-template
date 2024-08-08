final: prev: rec {
  go = prev.go_1_22.overrideAttrs
    (finalAttrs: previousAttrs: rec {
      version = "1.22.6";

      src = final.fetchurl {
        url = "https://go.dev/dl/go${version}.src.tar.gz";
        sha256 = "sha256-nkjZnVGYgleZF9gYnBfpjDc84lq667mHcuKScIiZKlE=";
      };

    });

  buildGoTemplateModule = prev.buildGoModule.override { go = go; };

  golangci-lint = prev.golangci-lint.override rec {
    buildGoModule = args: prev.buildGoModule.override { go = go; } (args // rec {
      version = "1.59.1";
      src = prev.fetchFromGitHub {
        owner = "golangci";
        repo = "golangci-lint";
        rev = "v${version}";
        sha256 = "sha256-VFU/qGyKBMYr0wtHXyaMjS5fXKAHWe99wDZuSyH8opg=";
      };

      vendorHash = "sha256-yYwYISK1wM/mSlAcDSIwYRo8sRWgw2u+SsvgjH+Z/7M=";

      ldflags = [
        "-s"
        "-w"
        "-X main.version=${version}"
        "-X main.commit=v${version}"
        "-X main.date=19700101-00:00:00"
      ];
    });
  };

  mockgen = prev.mockgen.override rec {
    buildGoModule = args: final.buildGoModule (args // rec {
      version = "0.4.0";
      src = final.fetchFromGitHub {
        owner = "uber-go";
        repo = "mock";
        rev = "v${version}";
        sha256 = "sha256-3nt70xrZisK5vgQa+STZPiY4F9ITKw8PbBWcKoBn4Vc=";
      };
      vendorHash = "sha256-mcNVud2jzvlPPQEaar/eYZkP71V2Civz+R5v10+tewA=";
    });
  };

  golines = final.buildGoModule rec {
    name = "golines";
    version = "0.12.2";
    src = final.fetchFromGitHub {
      owner = "segmentio";
      repo = "golines";
      rev = "v${version}";
      sha256 = "sha256-D0gI9BA0vgM1DBqwolNTfPsTCWuOGrcu5gAVFEdyVGg=";
              
    };
    vendorHash = "sha256-jI3/m1UdZMKrS3H9jPhcVAUCjc1G/ejzHi9SCTy24ak=";

    meta = with final.lib; {
      description = "A golang formatter that fixes long lines";
      homepage = "https://github.com/segmentio/golines";
      maintainers = [ "nesmanrique" ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  govulncheck = final.buildGoModule rec {
    name = "govulncheck";
    version = "v1.1.3";
    src = final.fetchFromGitHub {
      owner = "golang";
      repo = "vuln";
      rev = "${version}";
      sha256 = "sha256-ydJ8AeoCnLls6dXxjI05+THEqPPdJqtAsKTriTIK9Uc=";
    };
    vendorHash = "sha256-jESQV4Na4Hooxxd0RL96GHkA7Exddco5izjnhfH6xTg=";

    doCheck = false;

    meta = with final.lib; {
      description = "the database client and tools for the Go vulnerability database";
      homepage = "https://github.com/golang/vuln";
      maintainers = [ "nesmanrique" ];
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

}
