# [Stack 2 Download] - (Transmission, Radarr, Sonarr etc)

{ config, pkgs, ... }:
{    
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
    
# --- >> NAVIDROME << --- #
      navidrome = {
        image = "deluan/navidrome:latest";
        hostname = "navidrome";
        #dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/navidrome/config:/data"
          "/srv/mergerfs/Pool/Music:/music:ro"     
        ];
        ports = [ 
          "4533:4533"
        ];
        environmentFiles = [
          /docker/env/navidrome/.env
          /docker/env/navidrome/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };   
    };
  };
}
