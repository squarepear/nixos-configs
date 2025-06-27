{ ... }:

{
  services.open-webui = {
    enable = true;

    port = 14141;
    host = "0.0.0.0";
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://reshiram:11434/API";
      OLLAMA_BASE_URL = "http://reshiram:11434";
      WEBUI_AUTH = "False";
    };
  };
}
