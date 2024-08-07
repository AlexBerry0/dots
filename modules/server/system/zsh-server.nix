{
  inputs,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls -h";
      update = "cd /etc/nixos && git pull && sudo nixos-rebuild switch --flake /etc/nixos/#home-server";
      actual-update = "cd /etc/nixos && sudo nix flake update";
      status = "sudo systemctl status";
      restart = "sudo systemctl restart";
    };
    history.size = 100000;
    history.path = "/home/user/zsh/history";
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
    };
    initExtra = ''
      [[ ! -f ${../../../configs/p10k.zsh} ]] || source ${../../../configs/p10k.zsh}
      nitch
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
}
