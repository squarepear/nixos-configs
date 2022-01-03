{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = config.system.gui.enable;
    package = pkgs.vscode-fhs;

    userSettings = {
      "update.channel" = "none";

      "editor" = {
        "fontFamily" = "'CaskaydiaCove Nerd Font'";
        "fontLigatures" = true;
        "insertSpaces" = false;
      };

      "window.zoomLevel" = 2;
      "workbench.iconTheme" = "vscode-icons";

      "files.exclude" = {
        "**/*.meta" = true; # Unity meta files
      };

      "omnisharp.useGlobalMono" = "always";
    };

    extensions = with pkgs.vscode-extensions; [
      # TODO: Add VSCode Extensions
    ];
  };
}
