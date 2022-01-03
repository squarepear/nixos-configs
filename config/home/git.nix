{ ... }:

{
  programs.git = {
    enable = true;

    userName = "Jeffrey Harmon";
    userEmail = "16364318+SquarePear@users.noreply.github.com";

    signing = {
      signByDefault = true;
      key = "1A5CF61AC92D97AA";
    };

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };
}
