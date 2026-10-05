{ pkgs, ... }: {
  home.packages = with pkgs; [
    bottom
    direnv
    fastfetch
    fzf
    pipes
    qpdf
    shellcheck
    zoxide
    ripgrep
    fd

    kubectl
    kubernetes-helm
    kubeseal

    typst
    typstyle
    tinymist

    nodejs_22
    uv
    alejandra
  ];
}