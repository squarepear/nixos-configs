{ pkgs, ... }:

{
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    dock = {
      autohide = true;
      show-recents = false;
      persistent-apps = [
        "/Applications/Safari.app"
        "/System/Applications/Launchpad.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Mail.app"
        "${pkgs.discord-canary}/Applications/Discord Canary.app"
        "${pkgs.slack}/Applications/Slack.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Music.app"
        "/System/Applications/System Settings.app"
        "${pkgs.iterm2}/Applications/iTerm2.app"
        "${pkgs.vscode}/Applications/Visual Studio Code.app"
        "/Applications/Obsidian.app"
      ];
    };
    finder.CreateDesktop = false;
    loginwindow.GuestEnabled = false;
    menuExtraClock = {
      ShowAMPM = true;
      ShowDate = 1; # Always
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
    };
    # screencapture.location = "$HOME/Downloads";
  };
}
