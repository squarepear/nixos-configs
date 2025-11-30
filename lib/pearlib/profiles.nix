{ config, lib, ... }:

let
  profilesCfg = config.pear.system.profiles;
in
rec {
  # usage: profileEnabled "desktop" -> bool (is "desktop" enabled?)
  profileEnabled = profile: lib.elem profile profilesCfg;

  # usage: allProfilesEnabled [ "desktop" "gaming" ] -> bool (are all enabled?)
  allProfilesEnabled = profiles: lib.all profileEnabled profiles;

  # usage: anyProfileEnabled [ "desktop" "gaming" ] -> bool (are any enabled?)
  anyProfileEnabled = profiles: lib.any profileEnabled profiles;
}
