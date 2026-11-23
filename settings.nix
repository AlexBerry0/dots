let
  username = "alexberry";
  homeDirectory = "/Users/${username}";
  documentsDirectory = "${homeDirectory}/Documents";
in {
  inherit username homeDirectory;
  hostName = "macbook";
  system = "aarch64-darwin";
  repoDir = "${documentsDirectory}/dots";
  notesDir = "${documentsDirectory}/UC/Notes";
  notesBranch = "main";
}
