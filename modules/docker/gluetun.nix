
{ config, pkgs, lib, ... }:

{    
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      gluetun = {
        image = "qmcgaw/gluetun";
        ports = ["8888:8888" "8388:8388" "8001:8000" "9091:9091" "51413:51413" "8191:8191" "9696:9696" "8686:8686" "8989:8989" "7878:7878" "4545:4545" "8080:8080" "8787:8787" "6767:6767" "5055:5055"];
        volumes = ["/docker/gluetun/config:/gluetun" "/docker/gluetun/forwardedports.txt:/tmp/gluetun/forwardedport.txt"];
        environmentFiles = [
          /docker/env/gluetun/.env
          /docker/env/gluetun/.env.secret     
        ];
        hostname = "gluetun";
        cmd = ["--cap-add=NET_ADMIN --device=/dev/net/tun:/dev/net/tun"];
      };
    };
  };
}
