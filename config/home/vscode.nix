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

      "workbench.iconTheme" = "vscode-icons";

      "files.exclude" = {
        "**/*.meta" = true; # Unity meta files
      };

      "omnisharp.useGlobalMono" = "always";

      "window.zoomLevel" = 1;
    };

    extensions = with pkgs.vscode-extensions; [
      # TODO: Add VSCode Extensions
    ];
  };
}
