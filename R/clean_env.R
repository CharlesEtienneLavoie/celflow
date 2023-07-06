#' @title Clean Global Environment with Exceptions
#'
#' @description The `clean_env` function is designed to clean the global
#' environment of all objects except those specified by type or by name.
#'
#' @details This function gets all objects in the global environment, and
#' then removes objects based on the `keep_types` and `keep_objects` parameters.
#' Any remaining objects are removed from the global environment.
#'
#' @param keep_types A vector of classes. Objects in the global environment
#' of these classes will not be removed. Default is NULL.
#' @param keep_objects A vector of character strings. Objects in the global
#' environment with these names will not be removed. Default is NULL.
#'
#' @return NULL. This function is called for its side effect of cleaning
#' the global environment.
#' @references Add any relevant references here.
#' @export
#' @examples
#' \dontrun{
#' # Generate some objects
#' a <- 1
#' b <- "hello"
#' c <- list(1, 2, 3)
#'
#' # Clean the environment but keep lists and the object named 'a'
#' clean_env(keep_types = "list", keep_objects = "a")
#' }



clean_env <- function(keep_types = NULL, keep_objects = NULL) {
  all_objects <- ls(envir = .GlobalEnv)
  if (!is.null(keep_types)) {
    for (obj_name in all_objects) {
      obj_class <- class(get(obj_name))
      if (any(obj_class %in% keep_types)) {
        all_objects <- all_objects[all_objects != obj_name]
      }
    }
  }
  if (!is.null(keep_objects)) {
    all_objects <- setdiff(all_objects, keep_objects)
  }
  # Exclude function arguments from the list
  all_objects <- setdiff(all_objects, c("keep_objects", "keep_types"))
  # print remaining objects
  rm(list = all_objects, envir = .GlobalEnv)
}




