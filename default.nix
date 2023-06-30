{ haskellPackages
, lib
, runCommand
}:

{ preConfigure ? "true"
, spec
, source
}:

let

  inherit (spec) name;

  getVersion = name:
  let
    versionFromGhc = lib.removeSuffix "\n" (builtins.readFile (
      runCommand "${name}-version" {} ''
        ${haskellPackages.ghc}/bin/ghc-pkg field ${name} version --simple-output > $out
      ''));
  in haskellPackages.${name}.version or versionFromGhc;

  dependenciesWithVersions = map (p: "${p} == ${getVersion p}");
  hpackDependencies = {
    dependencies = dependenciesWithVersions spec.dependencies;
    tests = lib.mapAttrs (name: value: {
      dependencies = dependenciesWithVersions value.dependencies;
    }) spec.tests or {};
  };
  hpack = lib.recursiveUpdate spec hpackDependencies;
  hpackFile = builtins.toFile "package.yaml" (builtins.toJSON hpack);

  cabalFile = runCommand "${name}.cabal" {} ''

    # hpack needs the source to glob e.g. data-files
    cp --recursive --no-preserve=mode ${source} src

    cp ${hpackFile} src/package.yaml
    (cd src && ${haskellPackages.hpack}/bin/hpack)
    mv src/${name}.cabal $out
  '';

  # Symlinking won't work because GitLab CI doesn't resolve symlinks when
  # creating artifacts
  copyCabalFile = ''
    cp --force ${cabalFile} ${name}.cabal
  '';

  source = runCommand "${name}-src" {} ''
    cp --recursive --no-preserve=mode ${source} $out
    (cd $out && ${copyCabalFile} && ${preConfigure})
  '';

in {
  inherit cabalFile source;
}
