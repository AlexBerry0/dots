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
      ll = "ls -l";
      kssh = "kitty +kitten ssh";
      update = "cd /etc/nixos && sudo nix flake update && cd";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/#desktop";
    };
    history.size = 100000;
    history.path = "/home/alexb/zsh/history";
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      # theme = "robbyrussell";
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
