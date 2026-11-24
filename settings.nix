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
  mailSortDir = "${documentsDirectory}/Coding/AI/mail-sort";
  mailSortRepo = "git@github.com:AlexBerry0/mail-sort.git";
  libraryDir = "${documentsDirectory}/Coding/personal-library";
  notesBranch = "main";
}
