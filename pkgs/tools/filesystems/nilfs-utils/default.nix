{ stdenv, fetchurl, libuuid, libselinux }:
let 
  sourceInfo = rec {
    version = "2.2.6";
    url = "http://nilfs.sourceforge.net/download/nilfs-utils-${version}.tar.bz2";
    sha256 = "1rjj6pv7yx5wm7b3w6hv88v6r53jqaam5nrnkw2and4ifhsprf3y";
    baseName = "nilfs-utils";
    name = "${baseName}-${version}";
  };
in
stdenv.mkDerivation rec {
  src = fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
  };

  inherit (sourceInfo) name version;
  buildInputs = [libuuid libselinux];

  preConfigure = ''
    sed -e '/sysconfdir=\/etc/d; ' -i configure
    sed -e "s@sbindir=/sbin@sbindir=$out/sbin@" -i configure
    sed -e 's@/sbin/@'"$out"'/sbin/@' -i ./lib/cleaner*.c
  '';

  # FIXME: Remove after https://github.com/NixOS/patchelf/pull/98 is in
  dontPatchELF = true;

  meta = {
    description = "NILFS utilities";
    maintainers = with stdenv.lib.maintainers;
    [
      raskin
    ];
    platforms = with stdenv.lib.platforms;
      linux;
    downloadPage = "http://nilfs.sourceforge.net/en/download.html";
    updateWalker = true;
  };
}
