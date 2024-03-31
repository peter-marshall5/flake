{ config, lib, pkgs, ... }: {

  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-surface-pro-9-dsp.conf" ''
      node.software-dsp.rules = [
        {
          matches = [
            { "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo" }
          ]

          actions = {
            create-filter = {
              filter-graph = {
                node.description = "Surface Pro 9 Speaker"
                filter.graph = {
                  nodes = [{
                    type = "builtin"
                    label = "convolver"
                    config = {
                      filename = "/etc/surface-audio/sp9/impulse.wav"
                    }
                  }]
                }
                capture.props = {
                  node.name = "audio_effect.sp9-convolver"
                  media.class = "Audio/Sink"
                  node.virtual = false
                  priority.session = 10000
                  device.api = "dsp"
                  audio.channels = 2
                  audio.position = ["FL", "FR"]
                  state.default-channel-volume = 0.343
                }
                playback.props = {
                  node.name = "effect_output.sp9-convolver"
                  target.object = "alsa_output.pci-0000_00_1f.3.analog-stereo"
                  node.passive = true
                  audio.channels = 2
                  audio.position = ["FL", "FR"]
                }
              }
              hide-parent = "true"
            }
          }
        }
      ]

      wireplumber.profiles = {
        main = {
          node.software-dsp = required
        }
      }
    '')
  ];

  environment.etc."surface-audio/sp9/impulse.wav".source = pkgs.fetchurl {
    url = "https://github.com/peter-marshall5/surface-audio/raw/main/devices/sp9/impulse.wav";
    hash = "sha256-I/3FIqM4F6Yth6cfy8poUBRyW1nEkGKJBxBQsPcNaWo=";
  };

  # HACK: Not merged into unstable yet
  nixpkgs.overlays = [ (self: super: {
    wireplumber = super.wireplumber.overrideAttrs rec {
      version = "0.5.1";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "pipewire";
        repo = "wireplumber";
        rev = version;
        hash = "sha256-l5s7GTKpqGvRs1o14QNXq3kyQsoPwwUmd0TKlBKTAKE=";
      };
    };
  }) ];

}
