{ config, inputs, pkgs, ... }: {
  imports = [
    # Mostly system related configuration
    ../../nixos/intel.nix
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/sddm.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/tailscale.nix
    ../../nixos/hyprland.nix
    ../../nixos/syncthing.nix
    # You should let those lines as is
    ./hardware-configuration.nix
    ./variables.nix
  ];

  environment.systemPackages = [
    #inputs.swww.packages.${pkgs.system}.swww
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
        gui.user = "nixos-laptop";
        gui.password = "708041";
    };
  };

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
