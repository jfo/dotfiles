let
  nixpkgs-src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/tarball/471869c9185fb610e67940a701eb13b1cfb335a4";
    sha256 = "1klbclz8n4b9k1kfwv806bqdavld1mg32l1vxsmnrqzr6zck1c54";
  };
  nixpkgs = import nixpkgs-src {};
in with nixpkgs; {
  tmpAoeu = stdenv.mkDerivation {
    name = "tmpAoeu";

    hardeningDisable = [ "all" ];
    buildInputs = [
      cmake
      llvmPackages_17.clang-unwrapped
      llvm_17
      lld_17
    ];
  };
}
