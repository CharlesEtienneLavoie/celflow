#' @title Install and Load GitHub Packages
#'
#' @description This function installs and loads R packages from GitHub repositories.
#' It checks if the specified packages are already installed. If a package is not
#' installed, it is downloaded, installed, and then loaded into the R environment.
#'
#' @param git_packages A vector of GitHub repositories corresponding to the packages to be installed
#' and loaded. Each repository is specified as a string in the format "username/repository".
#'
#' @return No return value. Called for side effects.
#' @references Remember to add reference here.
#' @export
#' @examples
#' \dontrun{
#' get_git_packages(c("CharlesEtienneLavoie/CEL", 'rempsyc/rempsyc'))
#' }



get_git_packages <- function(git_packages) {
  for (repo in git_packages) {
    package <- unlist(strsplit(repo, "/"))[2]
    if (!require(package, character.only = TRUE)) {
      remotes::install_github(repo)
      library(package, character.only = TRUE)
    }
  }
}



