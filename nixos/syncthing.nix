{pkgs, config, ...}:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      gui = {
        user = "nixos-laptop";
        password = "708041";
      };
    };
  };
}
