{lib, pkgs, config, ...}:
{
  # Example: Enabling Intel graphics and Quick Sync Video
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

# Add the Intel media driver
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
  ];

# Example: Enabling Quick Sync Video
  services.xserver.videoDrivers = ["intel"];
    environment.systemPackages = with pkgs; [
      intel-media-sdk
      onevpl-intel-gpu
  ];

  # Add user to necessary groups
  users.users."nixos".extraGroups = [ "render" "video" ];

}
