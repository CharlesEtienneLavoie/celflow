#' @title Compute Power Analysis For SEM Model Using Monte Carlo Simulation
#'
#' @description Compute Power Analysis For SEM Model Using Monte Carlo
#' Simulation
#'
#' @details The function uses the simulate_data function from the lavaan
#' package to perform a monte carlo simulation. The mean, std error, z value,
#' p value and confidence intervals are then computed and reported in a table
#' for each parameter.
#'
#' @param model.population The lavaan model with population estimate values
#' specified.
#' @param model The lavaan model that will be tested in each simulation
#' @param ksim  How many simulations the function should perform
#' @param nobs  How many observations to generate in each simulation

#' @return A table.
#' @references Remember to add reference here
#' @export
#' @examples
#' library(lavaan)
#' modpop <- '
#' M ~ 0.40*X
#' Y ~ 0.30*M
#' '
#' mod <- '
#' M ~ X
#' Y ~ M
#' '
#'
#' simulate_power(modpop, mod)


clean_env_test <- function(keep_types = NULL, keep_objects = NULL) {
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




