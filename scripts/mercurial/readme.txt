Adds a mercurial username to a repository.
Since Mercurial config only allows multiple credentials and not usernames, this
script makes it easy to add the username to the hgrc file after a clone.

Parameters:
-RepositoryPath
The path of the repository to set the username for. Assumes current if not specified.
-Username
Username to set for the repository. Checks _hg-user.cfg if none specified.