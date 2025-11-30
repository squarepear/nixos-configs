{ lib, ... }@attrs:

lib.foldl' lib.recursiveUpdate { } [
  (import ./profiles.nix attrs)
  (import ./users.nix attrs)
]
