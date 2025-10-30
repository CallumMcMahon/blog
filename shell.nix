{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShellNoCC {
    packages = [
      pkgs.git
      pkgs.hugo
      pkgs.just
    ];

  }
