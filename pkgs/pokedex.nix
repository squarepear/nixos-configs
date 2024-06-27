{ lib, pkgs, writeShellScriptBin, ... }:

with lib;

let
  pname = "pokedex";
in
writeShellScriptBin pname ''
  ID=''${1:-"643"}

  # If id is not a number, return
  if ! [[ $ID =~ ^[0-9]+$ ]]
  then
      echo "ID must be a number"
      exit
  fi

  ${getExe pkgs.curl} -s "https://pokeapi.co/api/v2/pokemon-species/$ID" | ${getExe pkgs.jq} ".flavor_text_entries | .[] | select(.language.name == \"en\") | .flavor_text" | sed -e 's/ \\n//g' -e 's/\\n/ /g' -e 's/\\f/ /g' -e 's/\"//g' | sort -u | uniq | shuf -n 1
''
