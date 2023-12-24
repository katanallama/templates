{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:
buildPythonPackage rec {
  pname = "-${version}";
  version = "";

  src = fetchFromGitHub {
    owner = "";
    repo = "";
    rev = "v${version}";
    sha256 = "";
  };

  buildInputs = [];

  meta = with lib; {
    changelog = "https://github.com/${owner}/${pname}/releases/tag/${version}";
    description = " ";
    homepage = "https://github.com/${owner}/${pname}";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
