{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  # FIXME: Waiting on https://github.com/NixOS/nixpkgs/pull/429157
  # environment.systemPackages = [
  #   pkgs.platformio
  #   pkgs.avrdude
  # ];

  # services.udev.packages = [
  #   pkgs.platformio-core
  #   pkgs.openocd
  # ];

  my = {
    imports = [
      inputs.nixos-vscode-server.nixosModules.home
    ];

    programs.vscode = {
      enable = config.pear.desktop.enable;

      profiles.default.userSettings = {
        "update.mode" = "none";

        "editor" = {
          "fontFamily" = "'CaskaydiaCove Nerd Font'";
          "fontLigatures" = true;
          "insertSpaces" = true;
        };

        "workbench.colorTheme" = "Dainty – Panda Theme";
        "workbench.iconTheme" = "vscode-icons";

        "files.exclude" = {
          "**/*.meta" = true; # Unity meta files
          "**/.direnv" = true; # direnv files
          "**/.devenv" = true; # devenv files
          "**/node_modules" = true; # node modules
        };

        "search.exclude" = {
          "**/.direnv" = true;
          "**/.devenv" = true;
        };

        "omnisharp.useGlobalMono" = "always";

        "editor.bracketPairColorization.enabled" = true;
        "editor.linkedEditing" = true;
        "diffEditor.codeLens" = true;
        "files.insertFinalNewline" = true;
        "files.simpleDialog.enable" = true;
        "workbench.editor.limit.enabled" = true;
        "terminal.external.linuxExec" = "kitty";
        "terminal.integrated.shell.linux" = "zsh";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.enableShellIntegration" = false;
        "terminal.integrated.inheritEnv" = false;
        "telemetry.telemetryLevel" = "off";
        "git.enableCommitSigning" = true;
        "window.zoomLevel" = 4;
        "window.menuBarVisibility" = "toggle";
        "window.titleBarStyle" = "native";
        "window.customTitleBarVisibility" = "never";
        "editor.inlineSuggest.enabled" = true;
        "platformio-ide.useBuiltinPIOCore" = false;

        "godotTools.editorPath.godot4" = "/etc/profiles/per-user/${config.pear.user.name}/bin/godot4";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${lib.getExe pkgs.nil}";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = [ "${lib.getExe pkgs.nixfmt}" ];
            };
          };
        };
        "editor.formatOnSave" = true;
      };

      # extensions = with pkgs.vscode-extensions; [
      # TODO: Add VSCode Extensions
      # ];
    };

    services.vscode-server.enable = true;
  };
}
