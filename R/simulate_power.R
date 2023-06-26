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


simulate_power <- function(model.population, model, ksim = 10, nobs = 100) {
  # Create dataframe to store results
  results <- NULL
  #Loop simulation
  for (i in 1:ksim) {
    myData <- lavaan::simulateData(model.population, sample.nobs=nobs)
    myData <- as.data.frame(myData)
    fit <- lavaan::sem(model, data=myData #, std.lv = stdlv()
    )
    # Store parameter row
    results <- rbind(results, lavaan::parameterEstimates(fit)
    )
  }
  # add parameter column in results for later identification
  results$Parameter <- paste(results$lhs, results$op,
                             results$rhs, sep = " ")
  attr(results, "ksim") <- ksim
  results
}


