#' @title Remove Specific Objects from Global Environment
#'
#' @description This function removes specified objects from the global
#' environment in R.
#'
#' @param remove_objects A character vector specifying the names of objects to
#' be removed. If NULL (default), no objects are removed.
#'
#' @return This function does not return anything. It removes the specified
#' objects from the global environment.
#' @references Remember to add reference here
#' @export
#' @examples
#' \dontrun{
#' # create some objects
#' x <- 1:10
#' y <- letters
#' z <- rnorm(100)
#'
#' # remove 'x' and 'y'
#' remove_env_objects(c("x", "y"))
#' }



remove_env_objects <- function(remove_objects = NULL) {
  # get all objects in environment
  all_objects <- ls(envir = .GlobalEnv)

  if (!is.null(remove_objects)) {
    # find objects that exist in the environment and in 'remove_objects'
    remove_objects <- intersect(remove_objects, all_objects)
    # remove objects
    rm(list = remove_objects, envir = .GlobalEnv)
  }
}




