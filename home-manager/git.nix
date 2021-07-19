{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Jeffrey Harmon";
    userEmail = "16364318+SquarePear@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };
}
