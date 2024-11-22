# EMPTY NIX OS MODULE
# import into flake.
{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      invokeai = {
        image = "invokeai-rocm";
        build = {
          context = ".";
          dockerfile = "/home/pungkula/docker/invokeai/docker/Dockerfile";
        };
        environment = {
          INVOKEAI_ROOT = "/invokeai"; # Replace with actual value or fetch from .env
          HF_HOME = "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";       # Replace with actual value or fetch from .env
       };
    #    environmentFiles = [
    #      "/home/pungkula/docker/invokeai/docker/.env"
     #   ];
        ports = [
          "9595:9090"
        ];
        volumes = [
          {
            type = "bind";
            source = "/home/pungkula/docker/invokeai:-~/invokeai}}";
            target = "/home/pungkula/docker/invokeai:-/invokeai}";
          }
          {
            type = "bind";
            source = "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:-~/.cache/huggingface}";
            target = "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:-/invokeai/.cache/huggingface}";
          }
        ];
        tty = true;
        stdin_open = true;
        extraOptions = [
          "--device=/dev/kfd:/dev/kfd"
          "--device=/dev/dri:/dev/dri"
          "--network=host"
        ];
       profiles = [
          "rocm"
        ];
      };
    };
}

