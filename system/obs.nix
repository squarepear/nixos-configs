{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = config.pear.desktop.enable;
    enableVirtualCamera = true;

    package = pkgs.obs-studio.overrideAttrs (oldAttrs: {
      # Use the latest version of obs-studio
      version = "31.1.0-beta1";
      src = pkgs.fetchFromGitHub {
        owner = "obsproject";
        repo = "obs-studio";
        rev = "31.1.0-beta1";
        hash = "sha256-IjhHi+M2tsqOWuh8n7hoOcDSbi0rjp7YNNm/VEz45vQ=";
      };
      patches = builtins.filter
        (
          p: !(builtins.isPath p && builtins.baseNameOf p == "Enable-file-access-and-universal-access-for-file-URL.patch")
        )
        (oldAttrs.patches or [ ]);
      postPatch = (oldAttrs.postPatch or "") + ''
                # Replace the check_obs_browser macro with a no-op
                sed -i '/^macro(check_obs_browser)/,/^endmacro()/c\
        macro(check_obs_browser)\
        endmacro()' plugins/CMakeLists.txt
        
                # Replace the check_obs_websocket macro with a no-op
                sed -i '/^macro(check_obs_websocket)/,/^endmacro()/c\
        macro(check_obs_websocket)\
        endmacro()' plugins/CMakeLists.txt
      '';
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.extra-cmake-modules ];
      preFixup = builtins.replaceStrings
        [
          "rm $out/lib/obs-plugins/libcef.so"
          "rm $out/lib/obs-plugins/libEGL.so"
          "rm $out/lib/obs-plugins/libGLESv2.so"
          "rm $out/lib/obs-plugins/libvk_swiftshader.so"
          "rm $out/lib/obs-plugins/libvulkan.so.1"
          "rm $out/lib/obs-plugins/chrome-sandbox"
        ]
        [
          "rm -f $out/lib/obs-plugins/libcef.so || true"
          "rm -f $out/lib/obs-plugins/libEGL.so || true"
          "rm -f $out/lib/obs-plugins/libGLESv2.so || true"
          "rm -f $out/lib/obs-plugins/libvk_swiftshader.so || true"
          "rm -f $out/lib/obs-plugins/libvulkan.so.1 || true"
          "rm -f $out/lib/obs-plugins/chrome-sandbox || true"
        ]
        (oldAttrs.preFixup or "");
      postFixup = builtins.replaceStrings
        [ "ln -sf \${cef}/\${cef.buildType}/* $out/lib/obs-plugins/" ]
        [ "# Browser plugin disabled, skip cef linking" ]
        (oldAttrs.postFixup or "");
    });

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      droidcam-obs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
