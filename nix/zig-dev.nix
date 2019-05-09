with import <nixpkgs> {}; {
  tmpAoeu = stdenv.mkDerivation {
    name = "tmpAoeu";

    hardeningDisable = [ "all" ];
    buildInputs = [
      cmake
      llvmPackages_8.clang-unwrapped
      llvm_8
      lld_8
    ];
  };
}
