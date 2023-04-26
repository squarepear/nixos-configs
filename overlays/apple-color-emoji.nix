{ runCommand, fetchurl, lib }:
let
  pname = "apple-color-emoji";
  version = "15.4";
in
runCommand pname
{
  src = fetchurl {
    name = "${pname}-${version}";
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/ios-${version}/AppleColorEmoji.ttf";
    # sha256 = lib.fakeSha256;
    sha256 = "sha256:0v4avyk76pw3bsi9p2hcg5qd5kdyvp5a0hy0r2cx1jp55hnasf88";
  };
}
  ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf
  ''
