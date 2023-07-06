#' @title Clean Dataset Based on Missing Data Threshold and MCAR Test
#'
#' @description `clean_na_data` function is designed to handle missing data
#' in a given dataset by excluding variables and observations based on the
#' provided parameters. It provides a flexible and comprehensive approach to
#' handling missing data by allowing to exclude variables based on patterns
#' in their names and filter observations that have a percentage of missing
#' data above a specified threshold. Additionally, it can perform a MCAR (Missing
#' Completely At Random) test if requested.
#'
#' @param data The dataset to be cleaned.
#' @param scenario_based_vars Character vector with base names or full names
#' of variables to exclude from the dataset. Can also be a numeric vector with
#' column indices to be removed.
#' @param missing_threshold Percentage threshold for missing data per observation
#' (defaults to 60 percent).
#' @param full_names Logical value indicating whether `scenario_based_vars`
#' are full names of the variables (default is FALSE).
#' @param MCAR Logical value indicating whether to perform a MCAR test
#' (defaults to FALSE).
#' @param main_vars Character vector with base names of variables to include
#' in the MCAR test. If NULL, all variables are included (default is NULL).
#'
#' @return A dataset with cleaned missing data.
#' @references Remember to add reference here.
#' @export
#' @examples
#' \dontrun{
#' # Generate some objects
#' df <- data.frame(a = c(1, 2, NA, 4, 5),
#'                  b = c("one", "two", "three", NA, "five"),
#'                  c = c(NA, NA, 3, 4, 5))
#'
#' # Clean the environment but keep lists and the object named 'a'
#' clean_na_data(df, missing_threshold = 50, MCAR = TRUE)
#' }



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
  data_original$Missing_count <- Missing_count
  data$Missing_count <- Missing_count
  # Filter responses with more than 'missing_threshold' percent missing data
  data_filtered <- data %>% filter(Missing_count < ncol(data) * missing_threshold / 100)
  # Apply same filter to original data
  data_original <- data_original %>% filter(Missing_count < ncol(data) * missing_threshold / 100)
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


