#' @title Impute Data Using MissForest
#'
#' @description The `impute_data` function performs imputation on the numeric variables
#' in the given dataset using the MissForest algorithm. The function excludes
#' certain variables, termed "scenario-based" variables, from the imputation process.
#' These are variables that were presented to some participants under certain conditions
#' and might naturally contain NA values.
#'
#' @param data The dataset to be imputed.
#' @param scenario_based_vars A character or numeric vector representing variable names
#' or indices that should be excluded from the imputation process. These are the scenario-based
#' variables.
#' @param cores The number of CPU cores to be used for parallel processing. Default is 4.
#' @param seed The seed for reproducibility. Default is 100.
#'
#' @return The dataset with imputed values, maintaining the same column order as the original data.
#' @references Add any relevant references here.
#' @export
#' @examples
#' \dontrun{
#' # Use the function
#' imputed_data <- impute_data(DataM, scenario_based_vars = c("WFC.CHECKLIST_1:CopeClosure", "PROLIFIC_PID:correct_answer_total"))
#' }
#'
#' @importFrom dplyr select where
#' @importFrom doParallel
#' @importFrom registerDoParallel
#' @importFrom missForest missForest

impute_data <- function(data, scenario_based_vars, cores = 4, seed = 100) {
  # Select numeric variables for imputation
  numeric_vars_for_imputation <- data %>%
    select(where(is.numeric), -scenario_based_vars)

  # Select non-numeric and scenario-based variables
  non_imputed_vars <- data %>%
    select(where(~ !is.numeric(.x)), scenario_based_vars)

  # Set up parallel processing
  registerDoParallel(cores = cores)

  # Perform the imputation
  set.seed(seed)
  imputed_values <- missForest(numeric_vars_for_imputation, verbose = TRUE, parallelize = "variables")

  # Merge the imputed data with the non-imputed variables
  combined_data <- cbind(non_imputed_vars, imputed_values$ximp)

  # Order the columns of the combined_data to match the original data
  final_data <- combined_data[, names(data)]

  return(final_data)
}
