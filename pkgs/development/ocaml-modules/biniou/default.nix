{ stdenv, fetchFromGitHub, ocaml, findlib, easy-format, jbuilder }:
let
  pname = "biniou";
  version = "1.2.0";
  webpage = "http://mjambon.com/${pname}.html";
in

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.11";

stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = "biniou";
    rev = "v${version}";
    sha256 = "0mjpgwyfq2b2izjw0flmlpvdjgqpq8shs89hxj1np2r50csr8dcb";
  };

  buildInputs = [ ocaml findlib easy-format jbuilder ];

  inherit (jbuilder) installPhase;

  meta = with stdenv.lib; {
    description = "A binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve";
    homepage = "${webpage}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
