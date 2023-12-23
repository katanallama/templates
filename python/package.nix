{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  name = "-${version}";
  version = "";

  src = fetchFromGitHub {
    owner = "";
    repo = "";
    rev = "v${version}";
    sha256 = "";
  };

  buildInputs = [];

  meta = {
    description = "";
    homepage = "https://github.com//";

    # license = lib.licenses.;
    # maintainers = [ lib.maintainers. ];
    # platforms = lib.platforms.;
  };
}
