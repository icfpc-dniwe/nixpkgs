{ stdenv, fetchzip, ocaml, findlib, cppo, easy-format, biniou, jbuilder }:
let
  pname = "yojson";
  version = "1.4.0";
in
stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchzip {
    url = "https://github.com/mjambon/${pname}/archive/v${version}.tar.gz";
    sha256 = "0rzn4yihfi0psd2qmgrx5fvwpby87sqx4zws3ijf49f7wbpycccv";
  };

  buildInputs = [ ocaml findlib jbuilder ];

  propagatedBuildInputs = [ cppo easy-format biniou ];

  inherit (jbuilder) installPhase;

  meta = with stdenv.lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "http://mjambon.com/${pname}.html";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
