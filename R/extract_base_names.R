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

extract_base_names <- function(dataset, underscore_count = 1, keep_qualtrics_vars = FALSE, other_vars_removal = NULL) {
  var_names <- names(dataset)

  # Exclude Qualtrics vars if keep_qualtrics_vars is FALSE
  if (!keep_qualtrics_vars) {
    qualtrics_vars <- c("IPAddress", "ResponseId", "RecipientLastName", 'RecipientFirstName', 'RecipientEmail', 'ExternalReference',
                        'LocationLatitude', 'LocationLongitude', 'UserLanguage', "StartDate" , "EndDate" , "Status" , "Progress" ,
                        "Duration..in.seconds.", "Finished" , "RecordedDate", "DistributionChannel")
    var_names <- var_names[!var_names %in% qualtrics_vars]
  }

  # Exclude other vars specified by the user
  if (!is.null(other_vars_removal)) {
    var_names <- var_names[!var_names %in% other_vars_removal]
  }

  # Build regular expression to match after underscore_count underscores
  underscore_regex <- paste0("^(.+?)(_.*?){", underscore_count, "}$")

  base_names <- gsub(underscore_regex, "\\1", var_names)
  unique_base_names <- unique(base_names)

  return(unique_base_names)
}



