self: super:

super.freecad.overrideAttrs ( old: rec {
  name = "freecad-git";
  version = "2024-06-17";
  src = super.fetchFromGitHub {
    owner = "FreeCAD";
    repo = "FreeCAD";
    rev = "2ca9b6ef8036d5fd808f01205b66eb0424059e21";
    hash = "sha256-nTYWXH5JsVVWwf2gJzx+SxsB7MCsuvcAJCB6cWu0Jjw=";
  };
})
