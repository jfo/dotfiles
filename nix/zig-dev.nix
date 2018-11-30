with import <nixpkgs> {}; {
  tmpAoeu = stdenv.mkDerivation {
    name = "tmpAoeu";

    hardeningDisable = [ "all" ];
    buildInputs = [
      cmake
      llvmPackages_7.clang-unwrapped
      llvm_7
      lld_7
      zlib
      libxml2
    ];
  };
}
