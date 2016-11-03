# nix2cabal

nix2cabal is the opposite of [cabal2nix](https://github.com/NixOS/cabal2nix).
It lets you define a Haskell package in Nix and generate a Cabal file using
that definition. This eliminates the need to keep a Cabal file in Git, but
still lets you access a Cabal file when you happen to need one.

Shout-out to [hpack](https://github.com/sol/hpack/), without which this would
not have been so simple.

## Examples

| Nix definition                                                                     | Generated Cabal file                                                                                        |
| ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| [default.nix](https://gitlab.com/phunehehe/nix2cabal/blob/master/test/default.nix) | [nix2cabal-test.cabal](https://gitlab.com/phunehehe/nix2cabal/builds/artifacts/master/browse/test?job=test) |
| [default.nix](https://gitlab.com/phunehehe/foomail/blob/master/default.nix)        | [foomail.cabal](https://gitlab.com/phunehehe/foomail/builds/artifacts/master/browse?job=cabal)              |
