{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # jetbrains.idea-ultimate
    android-studio
    ((jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
        "github-copilot"
        "ide-features-trainer"
        "nixidea"
        "darcula-pitch-black"
      ])
      .overrideAttrs {
        # copying intellij back and forth from the build server is useless and slow
        preferLocalBuild = true;
      })
  ];
}
