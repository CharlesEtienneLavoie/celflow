#' @title Apply a Function to Subset of Variables in a Dataset Based on Root Names
#'
#' @description The `root_apply` function takes a dataset and a vector of root names
#' and applies a specified function to the subset of variables that match each root name
#' and have a number at the end of their name. It returns a list of the results
#' for each root name. If the function fails for a particular root name,
#' it returns NA for that root name and prints a message with the error.
#'
#' @param dataset A dataset where the function needs to be applied.
#' @param root_names A character vector of root names.
#' @param fun The function to apply to the subset of variables for each root name.
#' @param ... Additional arguments to the function.
#'
#' @return A list where each element is the result of applying `fun` to the subset
#' of variables that match a root name and have a number at the end of their name.
#' Each element in the list is named after the root name.
#'
#' @examples
#' \dontrun{
#' # Generate some data
#' df <- data.frame(
#'   daily_sat_aut_1 = rnorm(100),
#'   daily_sat_aut_2 = rnorm(100),
#'   daily_fru_aut_1 = rnorm(100),
#'   daily_fru_aut_2 = rnorm(100),
#'   daily_sat_rel_1 = rnorm(100),
#'   daily_sat_rel_2 = rnorm(100),
#'   daily_fru_rel_1 = rnorm(100),
#'   daily_fru_rel_2 = rnorm(100)
#' )
#'
#' # Apply the mean function to the subsets of variables
#' results <- root_apply(df,
#'                       root_names = c("daily_sat_aut", "daily_fru_aut", "daily_sat_rel"),
#'                       fun = mean)
#' }
#'
#' @export


root_apply <- function(dataset, root_names, fun, ...) {
  results <- list()

  for (root in root_names) {
    pattern <- paste0("^", root, "_\\d+$")
    matching_names <- grep(pattern, names(dataset), value = TRUE)

    if (length(matching_names) > 0) {
      subset_df <- dataset[, matching_names]

      if (is.matrix(subset_df) | is.data.frame(subset_df)) {
        # Try to convert to data.frame if it is not
        subset_df <- as.data.frame(subset_df)
      }

      # use tryCatch to handle potential errors in the function call
      result <- tryCatch(
        fun(subset_df, ...),
        error = function(e) {
          message(paste("Failed:", e))
          return(NA)
        }
      )
      results[[root]] <- result
    }
  }

  return(results)
}
