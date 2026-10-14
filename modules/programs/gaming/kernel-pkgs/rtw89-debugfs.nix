{
  pkgs,
  lib,
  kernel,
}:

pkgs.callPackage ./mk-kernel-module.nix {
  inherit kernel;

  pname = "rtw89-debugfs";
  modulePath = "drivers/net/wireless/realtek/rtw89";

  # Upstream Steam Frame fixes (https://github.com/Davenport-Physics/rtw89-steam-frame):
  # add the `disable_2ghz` and `reg6_pwr_override` module parameters. The patches
  # are relative to the rtw89 directory, hence -d below.
  postPatch = (kernel.postPatch or "") + ''
    patch -p1 -d drivers/net/wireless/realtek/rtw89 \
      < ${
        pkgs.fetchpatch {
          name = "0001-reg6-pwr-override.patch";
          url = "https://github.com/Davenport-Physics/rtw89-steam-frame/raw/1afaff45e7d35bd2024de9afde14a343a167e5ee/patches/0001-reg6-pwr-override.patch";
          hash = "sha256-ouRjB4/AvCdZQOBVdcNHsZ70TCkR7QqvhcbRnmomEng=";
        }
      }
    patch -p1 -d drivers/net/wireless/realtek/rtw89 \
      < ${
        pkgs.fetchpatch {
          name = "0002-disable-2ghz.patch";
          url = "https://github.com/Davenport-Physics/rtw89-steam-frame/raw/1afaff45e7d35bd2024de9afde14a343a167e5ee/patches/0002-disable-2ghz.patch";
          hash = "sha256-uM1q38huz+CBEbhqQ2/aZBcLgoMlKXF4nL8FQ/qIEHc=";
        }
      }
  '';

  # CONFIG_RTW89_DEBUG (make var) pulls debug.o into rtw89_core.ko. The -D
  # defines make the #ifdef CONFIG_RTW89_DEBUGFS code compile.
  extraMakeFlags = ''CONFIG_RTW89_DEBUG=y KCFLAGS="-DCONFIG_RTW89_DEBUG -DCONFIG_RTW89_DEBUGFS"'';

  meta = {
    description = "rtw89 driver rebuilt with CONFIG_RTW89_DEBUGFS and Steam Frame patches";
    license = lib.licenses.gpl2Only;
  };
}
