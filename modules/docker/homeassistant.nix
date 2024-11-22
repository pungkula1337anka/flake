# EMPTY NIX OS MODULE
# import into flake.
{ config, pkgs, ... }:

{
 virtualisation.oci-containers = {
     backend = "docker";
     containers = {
      # HOMEPAGE
      homepage = {
        image = "ghcr.io/gethomepage/homepage:latest";
        hostname = "homepage";  # Set container name
        ports = [ "3000:3000" ];  # Define ports
        volumes = [ "/home/pungkula/.config/docker/startsida/config:/app/config" ];  
        user = "1000";  
        extraOptions = ["--network=host"];
        environmentFiles = [ "/$HOME/docker/startsida/config/.env" "/$HOME/docker/startsida/config/.env.secret" ]        
       "/home/pungkula/docker/${toString config.virtualisation.docker.containers.homepage.hostname}/config/.env.secret" 
      };
    };
  };


}
