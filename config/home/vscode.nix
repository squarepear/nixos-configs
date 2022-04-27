{ config, pkgs, ... }:

{
  imports = [
    "${fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/bc28cc2a7d866b32a8358c6ad61bea68a618a3f5";
        sha256 = "00aqwrr6bgvkz9bminval7waxjamb792c0bz894ap8ciqawkdgxp";
      }}/modules/vscode-server/home.nix"
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
      "window.zoomLevel" = 2;
    };

    extensions = with pkgs.vscode-extensions; [
      # TODO: Add VSCode Extensions
    ];
  };

  services.vscode-server.enable = true;
}
