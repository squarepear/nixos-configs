{ config, pkgs, ... }:

{
  imports = [
    "${fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/867d5691871acc039fb47d45018c69e9ac751d95";
        sha256 = "1dr3v3mlf61nrs3f3d9qx74y8v5jihkk8wd1li4sglx22aqh4xf6";
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
