#' @title Clean Speed Outliers in a Dataset
#'
#' @description The `clean_speed` function identifies and removes
#' speed outliers from a given dataset based on the Median Absolute Deviation
#' (MAD). The function can identify both "fast" and "slow" outliers, depending
#' on the parameter settings. It prints the number of identified outliers,
#' initial number of observations, final number of observations after
#' removing outliers, and the number of observations removed.
#'
#' @param data A dataset where speed outliers need to be identified and removed.
#' @param duration_var The variable in the dataset used to identify outliers.
#' @param remove_slow A logical value to decide if slow outliers should be
#' removed (default is FALSE).
#'
#' @return A dataset where speed outliers have been removed.
#' @references Remember to add reference here.
#' @export
#' @examples
#' \dontrun{
#' # Generate some data
#' df <- data.frame(
#'   duration = c(1, 2, 3, 4, 5, 6, 1000, 2000, 50000, -50, -200),
#'   other_var = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
#' )
#'
#' # Remove speed outliers from the data
#' clean_data <- clean_speed(df, duration_var = "duration", remove_slow = TRUE)
#' }



clean_speed <- function(data, duration_var, remove_slow = FALSE) {
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

