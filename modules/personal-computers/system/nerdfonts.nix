{pkgs, ...}: {
  fonts = {
    fontconfig.enable = true;
    packages = [
      pkgs.nerd-fonts.hack
    ];
  };
  environment.systemPackages = with pkgs; [
    nerd-fonts.hack
  ];
}
