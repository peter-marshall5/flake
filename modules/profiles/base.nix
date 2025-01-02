{ config, lib, modulesPath, ... }: {

  boot.initrd.systemd.enable = true;

  documentation.enable = false;

  networking.useNetworkd = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  services.resolved = {
    dnsovertls = "true";
    dnssec = "true";
  };

  # We don't need to support legacy BIOS systems by default
  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.rebootForBitlocker = true;

  security.tpm2.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
