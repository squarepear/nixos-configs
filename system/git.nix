{ ... }:

{
  my.programs = {
    git = {
      enable = true;

      userName = "Jeffrey Harmon";
      userEmail = "contact@jeffreyharmon.dev";

      lfs.enable = true;

      signing = {
        signByDefault = true;
        key = "EC6381EC5C7904E8";
      };

      extraConfig = {
        init.defaultBranch = "main";
        http.postBuffer = "524288000";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
      };
    };
  };
}
