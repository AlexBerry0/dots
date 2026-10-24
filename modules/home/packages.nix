{pkgs, ...}: {
  home.packages = with pkgs; [
    bottom
    fastfetch
    fzf
    pipes
    qpdf
    shellcheck
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

    age
    sops
  ];
}
