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


clean_na_data <- function(data, scenario_based_vars = NULL, missing_threshold = 60, full_names = FALSE, MCAR = FALSE, main_vars = NULL) {
  # Make a copy of original data for later comparison
  data_original <- data
  # Check if scenario_based_vars are provided
  if(!is.null(scenario_based_vars)){
    # If scenario_based_vars are column numbers
    if(is.numeric(scenario_based_vars[1])){
      data <- data[,-scenario_based_vars]
    } else {
      # If scenario_based_vars are base names
      if(!full_names){
        scenario_based_vars_full <- lapply(scenario_based_vars, function(x) grep(paste0("^", x), names(data), value = TRUE))
        scenario_based_vars_full <- unlist(scenario_based_vars_full)
        scenario_based_vars <- unique(c(scenario_based_vars, scenario_based_vars_full))
      }
      # Remove scenario based variables
      data <- data[, !(names(data) %in% scenario_based_vars)]
    }
  }
  # Visualize missing values
  print("Visualizing missing values in the dataset:")
  print(naniar::vis_miss(data))
  # Calculate amount of NA per observation
  missing <- is.na(data)
  Missing_count <- rowSums(missing)
  # Add missing count in the main dataset
  data$Missing_count <- Missing_count
  # Filter responses with more than 'missing_threshold' percent missing data
  data_filtered <- data %>% filter(Missing_count < ncol(data) * missing_threshold / 100)
  # Apply same filter to original data
  data_original <- data_original[row.names(data_original) %in% row.names(data_filtered), ]
  # Print initial and filtered number of observations
  cat("Initial number of observations (before cleaning): ", nrow(data), "\n")
  cat("Number of observations after filtering for missing data: ", nrow(data_original), "\n")
  # Print the number of excluded observations
  cat("Missing value Filter: ", nrow(data) - nrow(data_original), " observations were excluded due to exceeding the missing data threshold.\n")
  # Visualize missing values post filter
  print("Visualizing missing values after filtering:")
  print(naniar::vis_miss(data_filtered))

  if (MCAR) {
    # Prepare data for MCAR test
    if (!is.null(main_vars)) {
      # If main_vars are provided, keep only columns starting with these names
      main_vars_full <- lapply(main_vars, function(x) grep(paste0("^", x), names(data_filtered), value = TRUE))
      main_vars_full <- unlist(main_vars_full)
      main_vars <- unique(c(main_vars, main_vars_full))
      data <- data_filtered[, names(data_filtered) %in% main_vars]
    } else {
      # If main_vars are not provided, use all data_filtered
      data <- data_filtered
    }

    # Perform MCAR test
    print("Performing MCAR (Missing Completely at Random) test to determine randomness of missing data:")
    mcar_result <- naniar::mcar_test(data)
    print(mcar_result)
    cat("A low p-value in the MCAR test suggests that the missingness of data is not random. If p-value > 0.05, missingness can be assumed to be random.\n")
  }

  return(data_original)
}



