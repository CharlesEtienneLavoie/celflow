#' @title Install and Load R Packages
#'
#' @description This function installs and loads R packages. It checks if the specified packages
#' are already installed. If a package is not installed, it is downloaded from CRAN,
#' installed, and then loaded into the R environment.
#'
#' @param packages A character vector of package names to be installed and loaded.
#'
#' @return No return value. Called for side effects.
#' @references Remember to add reference here.
#' @export
#' @examples
#' \dontrun{
#' get_packages(c("ggplot2", "dplyr"))
#' }



get_packages <- function(packages) {
  for (package in packages) {
    if (!require(package, character.only = TRUE)) {
      install.packages(package)
      library(package, character.only = TRUE)
    }
  }
}


