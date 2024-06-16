{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # jetbrains.idea-ultimate
    android-studio
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot"])
  ];
}
