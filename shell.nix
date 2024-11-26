with (import <nixpkgs> {}); let
  env = bundlerEnv {
    name = "YourJekyllSite";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  stdenv.mkDerivation {
    name = "YourJekyllSite";
    buildInputs = [
      env
      ruby_3_3
      rubyPackages_3_3.ffi
      libffi
    ];

    shellHook = ''
      export PKG_CONFIG_PATH="${pkgs.libffi}/lib/pkgconfig:$PKG_CONFIG_PATH"
      export LIBFFI_CFLAGS="-I${pkgs.libffi}/include"
      export LIBFFI_LIBS="-L${pkgs.libffi}/lib -lffi"

      exec ${env}/bin/jekyll serve --watch
    '';
  }
