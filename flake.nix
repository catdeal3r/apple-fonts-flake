{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    sf-pro-source = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      flake = false;
    };

    sf-compact-source = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
      flake = false;
    };

    sf-mono-source = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
      flake = false;
    };

    sf-arabic-source = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg";
      flake = false;
    };

    ny-source = {
      url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
      flake = false;
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShellNoCC { packages = [ pkgs.alejandra ]; };

          packages =
            let
              makeAppleFont =
                name: pkgName: src:
                pkgs.stdenv.mkDerivation {
                  inherit name src;

                  version = "0.3.0";

                  unpackPhase = ''
                    undmg $src
                    7z x '${pkgName}'
                    7z x 'Payload~'
                  '';

                  buildInputs = [
                    pkgs.undmg
                    pkgs.p7zip
                  ];
                  setSourceRoot = "sourceRoot=`pwd`";

                  installPhase = ''
                    mkdir -p $out/share/fonts
                    mkdir -p $out/share/fonts/opentype
                    mkdir -p $out/share/fonts/truetype
                    find -name \*.otf -exec mv {} $out/share/fonts/opentype/ \;
                    find -name \*.ttf -exec mv {} $out/share/fonts/truetype/ \;
                  '';
                };

              sources = import ./sources.nix;
            in
            {
              sf-pro = makeAppleFont "sf-pro" "SF Pro Fonts.pkg" (inputs.sf-pro-source);
              sf-compact = makeAppleFont "sf-compact" "SF Compact Fonts.pkg" (inputs.sf-compact-source);
              sf-mono = makeAppleFont "sf-mono" "SF Mono Fonts.pkg" (inputs.sf-mono-source);
              sf-arabic = makeAppleFont "sf-arabic" "SF Arabic Fonts.pkg" (inputs.sf-arabic-source);
              ny = makeAppleFont "ny" "NY Fonts.pkg" (inputs.ny-source);
            };
        };
    };
}

