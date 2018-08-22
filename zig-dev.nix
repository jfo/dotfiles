with import <nixpkgs> {}; {
  tmpAoeu = stdenv.mkDerivation {
    name = "tmpAoeu";

    hardeningDisable = [ "all" ];
    buildInputs = [
      cmake
      llvmPackages_6.clang-unwrapped
      llvm_6
      lld_6
      zlib
      libxml2
      kcov
    ];
  };
}

