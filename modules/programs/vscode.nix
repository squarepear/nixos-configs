{
  config,
  lib,
  pearlib,
  pkgs,
  unstable,
  ...
}:

let
  cfg = config.pear.programs.vscode;
in
{
  options.pear.programs.vscode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.allProfilesEnabled [
        "development"
        "desktop"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    # Configure VSCode for all defined users
    home-manager.users = pearlib.perUser (name: {
      programs.vscode = {
        enable = true;
        package = unstable.vscode;

        profiles.default.userSettings = {
          "update.mode" = "none";

          "editor" = {
            "fontFamily" = "'CaskaydiaCove Nerd Font'";
            "fontLigatures" = true;
            "insertSpaces" = true;
          };

          "workbench.colorTheme" = "Dainty – Panda Theme (chroma 0, lightness 3)";
          "workbench.iconTheme" = "vscode-icons";

          "files.exclude" = {
            "**/.direnv" = true;
            "**/.devenv" = true;
            "**/node_modules" = true;
          };

          "search.exclude" = {
            "**/.direnv" = true;
            "**/.devenv" = true;
          };

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
          "chat.commandCenter.enabled" = false;
          "window.menuBarVisibility" = "toggle";
          "editor.inlineSuggest.enabled" = true;
          "platformio-ide.useBuiltinPIOCore" = false;

          "godotTools.editorPath.godot4" = "/etc/profiles/per-user/${name}/bin/godot4";
          "godotFormatter.useBuiltInBinary" = false;
          "[gdscript]" = {
            "editor.defaultFormatter" = "DoHe.godot-format";
          };

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
      };
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".config/Code"
        ".vscode"
      ];
    });
  };
}
