#' @title Extract the Most Processed Variables from a List
#'
#' @description The `get_processed_list` function takes a character vector of variable
#' names and selects the most processed version of each base variable name.
#' The most processed version of a variable is considered to be the one with
#' the most suffixes (segments separated by ".")
#'
#' @details This function can be useful in situations where you have multiple
#' versions of each variable in your dataset, and you want to work with
#' only the most processed version of each variable. The output order is preserved
#' based on the order of base variable names in the input list.
#'
#' @param var_list A character vector of variable names, where the base variable name
#' and its processing stages are separated by dots.
#'
#' @return A character vector containing the most processed version of each base
#' variable name from the input list.
#'
#' @examples
#' \dontrun{
#' # Variable list with different processing stages
#' var_list <- c("var1", "var1.a", "var1.a.b", "var2", "var2.a")
#'
#' # Get the most processed version of each variable
#' processed_list <- get_processed_list(var_list)
#' }
#'
#' @export
#'
get_processed_list <- function(var_list) {
  # Create a dataframe to map each base variable name to its most processed version
  var_list_map <- data.frame(
    base = sub("\\..*", "", var_list),  # remove suffixes to get base variable names
    var = var_list,  # full variable names
    stringsAsFactors = FALSE
  )

  # For each base variable, select the one with the most suffixes (i.e., the most processed)
  var_list_processed <- var_list_map %>%
    group_by(base) %>%
    summarise(var = var[which.max(stringr::str_count(var, "\\."))])

  # Extract the column as a vector and keep the order of the base names in the original list
  base_order <- unique(var_list_map$base)
  var_list_processed <- var_list_processed[match(base_order, var_list_processed$base), ]
  var_list_processed$var
}

