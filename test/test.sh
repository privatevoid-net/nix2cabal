#!/usr/bin/env bash
set -efuxo pipefail

nix_build='nix-build --no-out-link'
PATH=$($nix_build '<nixpkgs>' --attr nix)/bin

find-bin() {
  attr=$1
  bin=$($nix_build '<nixpkgs>' --attr "$attr")/bin
  test -e "$bin"
  echo "$bin"
}

make-bin-path() {
  path=''
  for a in "$@"
  do
    path=$(find-bin $a):$path
  done
  echo "$path"
}

PATH=$(make-bin-path bash coreutils nix)
here=$(readlink --canonicalize "$(dirname "$0")")

$nix_build --expr "(import <nixpkgs> {}).callPackage $here {}"

# We are just abusing the shell hook to output the cabal file
(cd "$here" && nix-shell "$here" --run true)
