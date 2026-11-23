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
    google-cloud-sdk

    typst
    typstyle
    tinymist

    nodejs_22
    uv
    alejandra

    age
    sops

    # Previously Homebrew-only CLI tools
    black
    gh
    poppler-utils
    yt-dlp
  ];
}
