{ pkgs ? import <nixpkgs> {} }:

let drv = pkgs.callPackage ../. {
  spec = {
    name = "nix2cabal-test";
    executables.nix2cabal-test.main = "Main.hs";
    dependencies = ["base"];
  };
  source = ./.;
};

in if pkgs.lib.inNixShell then drv.env else drv
