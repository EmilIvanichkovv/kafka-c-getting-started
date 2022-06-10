{ pkgs ? import <nixpkgs> { } }: with pkgs;

let
  avro-c = callPackage nix/pkgs/avro-c/default.nix { };
in
mkShell {

  buildInputs = [
    nix-prefetch-git
    figlet
    nim
    gcc
    pkg-config
    rdkafka
    avro-c
    (libserdes.override { inherit avro-c; })
    glib
    lzma
    snappy.dev
  ];

  shellHook = ''
    figlet "Welcome to Kafka-Getting started"

  '';
}