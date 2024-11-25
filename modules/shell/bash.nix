# EMPTY NIX OS MODULE
# import into flake.
{ config, pkgs, ... }:

{
  programs.bash = {
    shellInit = ''
      echo "🦆🦆🦆🦆🦆🦆🦆"
      echo "😻😻😻😻😻😻😻"
      echo "🦆🦆🦆🦆🦆🦆🦆"
      echo "-----> hejsan från Bash <-----"
    '';
    
    shellAliases = {
      # NIX OS
      switch = "cd && cd flake && sudo nixos-rebuild switch --flake .#desktop --show-trace ";
      clean = "nix-collect-garbage";
      cleanold = "nix-collect-garbage -d";
      # DUCK DUCK GO
      snas = "ssh pungis@nasty";
      chat = "sh ddgo-chat.sh";
      music = "ssh pungis@nasty && media 192.168.1.223 un on && media 192.168.1.223 0 jukebox";
      # LOGS
      # MISC
      scpd = "sh /home/pungkula/duckOS/flake/bin/scpd";
      secr = "nix run github:ryantm/agenix -- --help";
      tts = "sh tts.sh";
      con = "sh con.sh";
      yt = "sh yt.sh";
      clr = "clear";
      # DEV
      dev-py = "cd && cd duckOS/dev/python && nix develop";
      dev-js = "cd && cd duckOS/dev/nodejs && nix develop";
      # Python virtual environment
      #venv-mk = "python -m venv venv";
      #venv-up = "source venv/bin/activate ";
     # venv-down = "source venv/bin/deactivate ";
      #venv-rm = "rm -rf ven";
      # WEB SERVER
      py-web = "python -m http.server 7777";
      # DOCKER
      dps = "docker ps";
      dcu = "docker compose up";
      dcd = "docker compose down";
      drm = "docker rm $(docker ps -a -q)";  # Remove all stopped containers
      drmi = "docker rmi $(docker images -q)";  # Remove all images
      # MISC
      dconf-dump = "dconf dump / | dconf2nix > dconf.nix"; # DCONF2NIX DUMP    
      psg = "ps aux | grep "; # list processes

      # Listing shortcuts
#      ll = "ls -lah";
#      la = "ls -A";
#      l = "ls -CF";
  
      # Git shortcuts
  #    gst = "git status";
  #    gco = "git checkout";
  #    gcm = "git commit";
   #   gp = "git pull";
    #  gpu = "git push";
  

  

 
      # NPM/Yarn shortcuts
#      nis = "npm install";
#      nisg = "npm install -g";
 #     yis = "yarn install";
  #    yisg = "yarn global add";
  
  
    };
    interactiveShellInit = ''
      eval "$(direnv hook bash)"
      
      # Customize the prompt
      PS1="\[\e[32m\]\u@\h:\w\[\e[m\] \$ "
      export PYTHONSTARTUP="/home/pungkula/flake/home/.pythonrc"
      export PATH="/home/pungkula/flake/home/bin:$PATH"      
      # Enable command auto-completion
      shopt -s histappend
      shopt -s autocd  # auto-cd to directories
      shopt -s cdspell  # autocorrect spelling errors in cd
      shopt -s checkwinsize  # update terminal size after each command

      # Enable history search with up and down arrows
      bind '"\e[A":history-search-backward'
      bind '"\e[B":history-search-forward'

      # Enable auto-suggestions (using zsh-like autocompletion)
      #source /usr/share/bash-completion/completions/git

      # Enable colorful `ls` output
      export LS_COLORS="di=1;34:ln=1;36:so=1;32:pi=1;33:ex=1;31"
    '';
  };
  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
  
}

