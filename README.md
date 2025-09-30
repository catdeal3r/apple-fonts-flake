# apple-fonts-flake
A flake providing different apple fonts.

Provides:
```
sf-pro
sf-compact
sf-mono
sf-arabic
ny
```

Usage:

1. Add to flake.nix
```nix
apple-fonts.url = "github:catdeal3r/apple-fonts-flake";
```

2. Use in other modules
```nix
inputs.apple-fonts.packages.${pkgs.system}.FONTNAME_HERE
```

E.g.
```nix
fonts.packages = with pkgs; [
  inputs.apple-fonts.packages.${pkgs.system}.sf-compact
];
```

