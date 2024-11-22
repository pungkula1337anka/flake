{ config, pkgs, lib, ... }:

{    
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      traefik = {
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

###################
version: "3"

services:
  traefik:
    image: traefik:v2.9.6
    container_name: traefik
    restart: always
    command:
      # Debug Properties
      #- "--log.level=DEBUG"
      #- "--api.insecure=true"
      # Common Properties
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:1336"
      - "--entrypoints.web.http.redirections.entryPoint.to=websecure"
      - "--entrypoints.web.http.redirections.entryPoint.scheme=https"
      # SSL/TLS Properties
      - "--entrypoints.websecure.http.tls.certResolver=myresolver"
      - "--entrypoints.websecure.http.tls.domains[0].main=${DOMAIN}"
      - "--entrypoints.websecure.http.tls.domains[0].sans=*.${DOMAIN}"
      - "--certificatesresolvers.myresolver.acme.email=${ACME_EMAIL}"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
      - "--certificatesresolvers.myresolver.acme.dnschallenge.provider=${ACME_PROVIDER}"
    ports:
      - "80:80"
      - "1336:443"
      - "8080:8080"
    environment:
      - DUCKDNS_TOKEN=${DUCKDNS_TOKEN}
    labels:
      - "traefik.enable=true"
      - "traefik.backend=dashboard"
      - "traefik.frontend.rule=Host:dashboard.${DOMAIN}"
    volumes:
      - "./letsencrypt:/letsencrypt"
      - "/var/run/docker.sock:/var/run/docker.sock:ro"

  whoami:
    image: traefik/whoami:v1.8
    container_name: whoami
    restart: always
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.tls=${TLS_ENABLED}"
      - "traefik.http.routers.whoami.rule=Host(`whoami.${DOMAIN}`)"
      - "traefik.http.routers.whoami.entrypoints=${WEB_ENTRYPOINT}"
