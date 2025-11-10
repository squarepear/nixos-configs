{ ... }:

{
  my.programs = {
    git = {
      enable = true;
      lfs.enable = true;

      signing = {
        signByDefault = true;
        key = "EC6381EC5C7904E8";
      };

      settings = {
        user = {
          name = "Jeffrey Harmon";
          email = "contact@jeffreyharmon.dev";
        };

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
