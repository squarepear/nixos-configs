{ config, inputs, pkgs, ... }:

{
  my = {
    imports = [
      inputs.nixos-vscode-server.nixosModules.home
    ];

    programs.vscode = {
      enable = config.system.gui.enable;
      package = pkgs.vscode-fhs;

      userSettings = {
        "update.mode" = "none";

        "editor" = {
          "fontFamily" = "'CaskaydiaCove Nerd Font'";
          "fontLigatures" = true;
          "insertSpaces" = true;
        };

        "workbench.iconTheme" = "vscode-icons";

        "files.exclude" = {
          "**/*.meta" = true; # Unity meta files
          "**/.direnv" = true; # direnv files
        };

        "search.exclude" = {
          "**/.direnv" = true;
        };

        "omnisharp.useGlobalMono" = "always";

        "editor.bracketPairColorization.enabled" = true;
        "editor.linkedEditing" = true;
        "diffEditor.codeLens" = true;
        "files.insertFinalNewline" = true;
        "files.simpleDialog.enable" = true;
        "workbench.editor.limit.enabled" = true;
        "terminal.external.linuxExec" = "kitty";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.enableShellIntegration" = true;
        "telemetry.telemetryLevel" = "off";
        "git.enableCommitSigning" = true;
        "window.zoomLevel" = 3;
        "editor.inlineSuggest.enabled" = true;
      };

      extensions = with pkgs.vscode-extensions; [
        # TODO: Add VSCode Extensions
      ];
    };

    services.vscode-server.enable = true;
  };
}
