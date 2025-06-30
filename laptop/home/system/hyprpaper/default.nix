# Hyprpaper is used to set the wallpaper on the system
{ lib, ... }: {
  # The wallpaper is set by stylix
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ "${../../../Wallpapers/black-oil-2_dark.png}" ];
      wallpaper = [
        ", ${../../../Wallpapers/black-oil-2_dark.png}"
      ];
    };
  };
  systemd.user.services.hyprpaper.Unit.After =
    lib.mkForce "graphical-session.target";
}
