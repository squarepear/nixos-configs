{ lib, ... }:

let
  profiles = [
    "minimal"
    "desktop"
    "server"
    "gaming"
    "development"
  ];

  profileDependencies = {
    desktop = [ "minimal" ];
    gaming = [
      "desktop"
      "minimal"
    ];
    server = [ "minimal" ];
    development = [ "minimal" ];
  };

  expandProfiles =
    chosen:
    let
      close =
        specs:
        let
          next = lib.unique (lib.concatMap (s: (profileDependencies.${s} or [ ]) ++ [ s ]) specs);
        in
        if next == specs then specs else close next;
    in
    close chosen;
in
{
  options = {
    pear.system.profiles = lib.mkOption {
      type = lib.types.listOf (lib.types.enum profiles);
      default = [ "minimal" ];
      apply = expandProfiles;
      description = ''
        A list of system profiles to apply.

        Certain modules and configurations will default to being enabled based
        on whether their profile is included in this list.
      '';
    };
  };
}
