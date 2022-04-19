{ pkgs ? import <nixpkgs> { } }: with pkgs;

# let
#   myglib = callPackage nix/pkgs/glib/default.nix { util-linuxMinimal = glib; };
# in
mkShell {

  buildInputs = [
    nix-prefetch-git
    figlet
    nim
    gcc
    pkg-config
    rdkafka
    glib
  ];

  shellHook = ''
    figlet "Welcome to Kafka C - Getting Started"
    echo $LIBCLANG_PATH

  '';
}