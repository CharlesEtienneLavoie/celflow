#' @title Filter Dataset Based on Ending Status
#'
#' @description `clean_ending` function is designed to filter a dataset
#' based on the status of the "Ending" variable. It allows users to either
#' include or exclude observations where the Ending is NA or explicitly marked
#' as "Normal". This function provides a simple yet effective method for focusing
#' analyses on subsets of data that meet specific criteria related to their
#' conclusion status.
#'
#' @param data The dataset to be filtered.
#' @param keep_na Logical value indicating whether to keep observations where
#' the Ending is NA. If TRUE, observations where Ending is NA or "Normal" are kept.
#' If FALSE, only observations where Ending is "Normal" are kept (default is TRUE).
#'
#' @return A filtered dataset based on the specified criteria for the Ending status.
#' Additionally, it reports the number of observations before and after filtering,
#' as well as the number of observations filtered out.
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
#' }

clean_ending <- function(data, keep_na = TRUE) {
  if (keep_na) {
    # Filter to keep rows where Ending is NA or "Normal"
    filtered_data <- data %>%
      filter(is.na(Ending) | Ending == "Normal")
  } else {
    # Filter to keep rows where Ending is "Normal", excluding NAs
    filtered_data <- data %>%
      filter(Ending == "Normal")
  }

  # Report the number of observations filtered
  n_before <- nrow(data)
  n_after <- nrow(filtered_data)
  n_filtered <- n_before - n_after

  cat("Number of observations before filtering:", n_before, "\n")
  cat("Number of observations after filtering:", n_after, "\n")
  cat("Number of observations filtered out based on the ending scenario filter:", n_filtered, "\n")

  return(filtered_data)
}
