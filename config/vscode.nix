{ config, inputs, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.platformio-core
    pkgs.avrdude
  ];

  services.udev.packages = [
    pkgs.platformio
    pkgs.openocd
  ];

  my = {
    imports = [
      inputs.nixos-vscode-server.nixosModules.home
    ];

    programs.vscode = {
      enable = config.system.gui.enable;

      userSettings = {
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
        "editor.inlineSuggest.enabled" = true;
        "platformio-ide.useBuiltinPIOCore" = false;
      };

      extensions = with pkgs.vscode-extensions; [
        # TODO: Add VSCode Extensions
      ];
    };

    services.vscode-server.enable = true;
  };
}
