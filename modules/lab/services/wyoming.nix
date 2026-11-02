{
  config,
  lib,
  ...
}:

let
  cfg = config.pear.lab.service.wyoming;
in
{
  options.pear.lab.service.wyoming = {
    enable = lib.mkEnableOption "Wyoming speech-to-text, text-to-speech and wake word servers";
  };

  config = lib.mkIf cfg.enable {
    services.wyoming = {
      # Speech-to-text. small-int8 is a good speed/accuracy balance on a CPU-only
      # machine; switch to distil-small.en or base-int8 if latency is too high.
      faster-whisper.servers.main = {
        enable = true;
        uri = "tcp://0.0.0.0:10300";
        device = "cpu";
        model = "small-int8";
        language = "en";
      };

      # Text-to-speech. Voice models are downloaded on first start.
      piper.servers.main = {
        enable = true;
        uri = "tcp://0.0.0.0:10200";
        voice = "en_US-lessac-medium";
      };

      # Wake word detection for satellites that do not run it on-device.
      openwakeword = {
        enable = true;
        uri = "tcp://0.0.0.0:10400";
      };
    };

    # Home Assistant runs on another host and connects over the tailnet.
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
      10200 # Piper (TTS)
      10300 # faster-whisper (STT)
      10400 # openWakeWord
    ];
  };
}
