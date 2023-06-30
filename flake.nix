{
  description = "nix2cabal";

  outputs = { self }: {
    lib.nix2cabal.init = ./.;
  };
}
