{ pkgs }: {
    deps = [
        pkgs.haskellPackages.cabal-install
        pkgs.haskellPackages.ghc
        pkgs.haskell-language-server
    ];
}