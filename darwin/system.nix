{ ... }:

{
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    dock = {
      autohide = true;
      show-recents = false;
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
