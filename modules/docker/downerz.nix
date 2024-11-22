# [Stack 2 Download] - (Transmission, Radarr, Sonarr etc)

{ config, pkgs, ... }:
{    
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
    
# --- >> TRANSMISSION << --- #
      transmission = {
        image = "lscr.io/linuxserver/transmission:latest";
        hostname = "transmission";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/transmission/config:/config"
          "/srv/mergerfs/Pool/Downloads:/downloads"
          "/srv/mergerfs/Pool/Watch:/watch"
        ];
        environmentFiles = [
          /docker/env/transmission/.env
          /docker/env/transmission/.env.secret   
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> PROWLARR << --- #
      prowlarr = {
        image = "lscr.io/linuxserver/prowlarr:latest";
        hostname = "prowlarr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/prowlarr/config:/config"
        ];
        environmentFiles = [
          /docker/env/prowlarr/.env
          /docker/env/prowlarr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> RADARR << --- #
      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
        hostname = "radarr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/radarr/config:/config"
          "/srv/mergerfs/Pool/Movies:/movies" #optional
          "/srv/mergerfs/Pool/Downloads:/downloads" #optional
        ];
        environmentFiles = [
          /docker/env/radarr/.env
          /docker/env/radarr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> LIDARR << --- #
      lidarr = {
        image = "lscr.io/linuxserver/lidarr:latest";
        hostname = "lidarr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/lidarr/config:/config"
          "/srv/mergerfs/Pool/Music:/music" #optional
          "/srv/mergerfs/Pool/Downloads:/downloads" #optional
        ];
        environmentFiles = [
          /docker/env/lidarr/.env
          /docker/env/lidarr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> SONARR << --- #
      sonarr = {
        image = "lscr.io/linuxserver/sonarr:latest";
        hostname = "sonarr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/sonarr/config:/config"
          "/srv/mergerfs/Pool/TV:/tv" #optional
          "/srv/mergerfs/Pool/Downloads:/downloads" #optional
        ];
        environmentFiles = [
          /docker/env/sonarr/.env
          /docker/env/sonarr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> READARR << --- #
      readarr = {
        image = "lscr.io/linuxserver/readarr:develop";
        hostname = "readarr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/readarr/config:/config"
          "/srv/mergerfs/Pool/Books:/books" #optional
          "/srv/mergerfs/Pool/Downloads:/downloads" #optional
        ];
        environmentFiles = [
          /docker/env/readarr/.env
          /docker/env/readarr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> REQUESTRR << --- #
      requestrr = {
        image = "thomst08/requestrr:latest";
        hostname = "requestrr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/requestrr/config:/root/config"
        ];
        environmentFiles = [
          /docker/env/requestrr/.env
          /docker/env/requestrr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> FLARESOLVERR << --- #
      flaresolverr = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        hostname = "flaresolverr";
        dependsOn = [ "gluetun" ];
        environmentFiles = [
          /docker/env/flaresolverr/.env
          /docker/env/flaresolverr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };    
      
# --- >> PODGRAB << --- #
      podgrab = {
        image = "akhilrex/podgrab";
        hostname = "podgrab";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/podgrab/config:/config"
          "/srv/mergerfs/Pool/Podcasts:/assets"
        ];
        environmentFiles = [
          /docker/env/podgrab/.env
          /docker/env/podgrab/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> BAZARR << --- #
      bazarr = {
        image = "lscr.io/linuxserver/bazarr:latest";
        hostname = "bazarr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/bazarr/config:/config"
          "/srv/mergerfs/Pool/Movies:/movies" #optional
          "/srv/mergerfs/Pool/TV:/tv" #optional
        ];
        environmentFiles = [
          /docker/env/bazarr/.env
          /docker/env/bazarr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
      
# --- >> JELLYSEERR << --- #
      jellyseerr = {
        image = "";
        hostname = "jellyseerr";
        dependsOn = [ "gluetun" ];
        volumes = [
          "/docker/jellyserr/config:/app/config"
        ];
        environmentFiles = [
          /docker/env/jellyseerr/.env
          /docker/env/jellyseerr/.env.secret     
        ];
        autoStart = true;
        #cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      }; 
    };
  };
}
