{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pear.development.vscode;
  usersCfg = config.pear.users;
in
{
  options.pear.development.vscode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.pear.development.enable && config.pear.desktop.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    # Configure VSCode for all defined users
    home-manager.users = lib.genAttrs (lib.attrNames usersCfg.users) (name: {
      programs.vscode = {
        enable = true;

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
          "window.menuBarVisibility" = "toggle";
          "window.titleBarStyle" = "native";
          "window.customTitleBarVisibility" = "never";
          "editor.inlineSuggest.enabled" = true;
          "platformio-ide.useBuiltinPIOCore" = false;

          "godotTools.editorPath.godot4" = "/etc/profiles/per-user/${name}/bin/godot4";

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
    });
  };
}
