{ config, lib, ... }:

let
  labCfg = config.pear.lab;
in
rec {
  # usage: hostForService "reverse-proxy" -> "uxie"
  hostForService =
    svcName:
    lib.findFirst (
      hostName: lib.elem svcName (labCfg.services.${hostName} or [ ])
    ) (throw "pear.lab: no host defined for service '${svcName}'") (lib.attrNames labCfg.services);

  # usage: ipForService "reverse-proxy" -> "100.78.45.59"
  ipForService = svcName: labCfg.hosts.${hostForService svcName};
}
