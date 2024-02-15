#' @title Filter Dataset Based on Ending Status
#'
#' @description `clean_ending` function is designed to filter a dataset
#' based on the status of the "Ending" variable. It allows users to either
#' include or exclude observations where the Ending is NA or matches a specific
#' value, which by default is "Normal". This function provides a simple yet
#' effective method for focusing analyses on subsets of data that meet specific
#' criteria related to their conclusion status.
#'
#' @param data The dataset to be filtered.
#' @param ending_value The value of the "Ending" variable to filter the dataset by.
#' The default value is "Normal", indicating that by default, observations with
#' an Ending of "Normal" or NA (if keep_na is TRUE) are kept.
#' @param keep_na Logical value indicating whether to keep observations where
#' the Ending is NA alongside the specified `ending_value`. If TRUE, observations
#' where Ending is NA or matches the `ending_value` are kept. If FALSE, only
#' observations where Ending matches the `ending_value` are kept. The default is TRUE.
#'
#' @return A filtered dataset based on the specified criteria for the Ending status.
#' Additionally, it reports the number of observations before and after filtering,
#' as well as the number of observations filtered out based on the ending scenario filter.
#'
#' @references Add references here.
#' @export
#' @examples
#' \dontrun{
#' # Generate a dataset
#' df <- data.frame(ID = 1:5,
#'                  Score = c(100, 85, 90, NA, 95),
#'                  Ending = c("Normal", "Abnormal", NA, "Normal", "Critical"))
#'
#' # Filter the dataset to keep only "Normal" or NA endings
#' filtered_df <- clean_ending(df, keep_na = TRUE)
#'
#' # Filter the dataset to keep only "Normal" endings, excluding NAs
#' filtered_df_no_na <- clean_ending(df, keep_na = FALSE)
#'
#' # Filter the dataset for a different ending value, say "Critical", including NAs
#' filtered_df_critical <- clean_ending(df, ending_value = "Critical", keep_na = TRUE)
#'
#' # Filter the dataset for a different ending value, say "Abnormal", excluding NAs
#' filtered_df_abnormal <- clean_ending(df, ending_value = "Abnormal", keep_na = FALSE)
#' }

clean_ending <- function(data, ending_value = "Normal", keep_na = TRUE) {
  if (keep_na) {
    filtered_data <- data %>% filter(is.na(Ending) | Ending == ending_value)
  } else {
    filtered_data <- data %>% filter(Ending == ending_value)
  }
  n_before <- nrow(data)
  n_after <- nrow(filtered_data)
  n_filtered <- n_before - n_after
  cat("Number of observations before filtering:", n_before, "\n")
  cat("Number of observations after filtering:", n_after, "\n")
  cat("Number of observations filtered out based on the ending scenario filter:", n_filtered, "\n")
  return(filtered_data)
}

