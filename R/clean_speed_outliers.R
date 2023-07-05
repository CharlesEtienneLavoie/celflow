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


clean_speed_outliers <- function(data, duration_var, remove_slow = FALSE) {
  # Ensure that the variable exists in the data
  if (!(duration_var %in% names(data))) {
    stop(paste0("Variable '", duration_var, "' not found in the data"))
  }

  # Compute the MAD
  mad_value <- mad(data[[duration_var]])
  median_value <- median(data[[duration_var]])

  # Identify outliers
  outliers_fast <- data[[duration_var]] < median_value - 3 * mad_value
  outliers_slow <- data[[duration_var]] > median_value + 3 * mad_value

  # Print the number of outliers
  num_fast_outliers <- sum(outliers_fast)
  num_slow_outliers <- sum(outliers_slow)

  cat(num_fast_outliers, "fast outlier(s) identified based on 3 median absolute deviations for variable: ", duration_var, "\n")
  if(remove_slow) {
    cat(num_slow_outliers, "slow outlier(s) identified based on 3 median absolute deviations for variable: ", duration_var, "\n")
  }

  # Save the initial number of observations
  num_initial_obs <- nrow(data)

  # Remove outliers
  if(remove_slow) {
    data <- data[!outliers_fast & !outliers_slow, ]
  } else {
    data <- data[!outliers_fast, ]
  }

  # Compute the number of observations after removing outliers
  num_after_obs <- nrow(data)

  # Print the number of observations removed
  cat("Initial number of observations: ", num_initial_obs, "\n")
  cat("Number of observations after removing outliers: ", num_after_obs, "\n")
  cat("Number of observations removed: ", num_initial_obs - num_after_obs, "\n")

  return(data)
}

