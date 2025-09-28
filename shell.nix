{ pkgs ? import <nixpkgs> {} }: let
  hugo-theme = builtins.fetchTarball {
    name = "hugo-theme-m10c";
    url = "https://github.com/vaga/hugo-theme-m10c/archive/8295ee808a8166a7302b781895f018d9cba20157.tar.gz";
    sha256 = "12jvbikznzqjj9vjd1hiisb5lhw4hra6f0gkq1q84s0yq7axjgaw";
  };
in
  pkgs.mkShellNoCC {
    packages = [
      pkgs.git
      pkgs.hugo
      pkgs.just
    ];

    shellHook = ''
      mkdir -p themes
      ln -snf "${hugo-theme}" themes/m10c
    '';
  }
