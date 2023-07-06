#' @title Extract Base Names from Dataset Variable Names
#'
#' @description This function extracts the base names from variable names in a dataset.
#'
#' @details The function takes a dataset as input and extracts the base names from the variable names. It allows for flexibility in handling variable names with underscores by specifying the number of underscores to consider. By default, the function removes Qualtrics variables commonly found in survey data, but this behavior can be modified with the \code{keep_qualtrics_vars} argument. Additional variables specified by the user can also be excluded. The function can also append numbers to base names if \code{use_numbers} is set to \code{TRUE}.
#'
#' @param dataset The dataset from which variable names are extracted.
#' @param underscore_count The number of underscores to consider when extracting base names (default is 1).
#' @param keep_qualtrics_vars Logical value indicating whether to keep Qualtrics variables (default is \code{FALSE}).
#' @param other_vars_removal A character vector specifying additional variables to exclude from the extraction process (default is \code{NULL}).
#' @param use_numbers Logical value indicating whether to append numbers to base names (default is \code{FALSE}).
#'
#' @return A character vector containing the unique base names extracted from the dataset variable names.
#'
#' @references Remember to add reference here
#' @export
#' @examples
#' dataset <- data.frame(Age_1 = c(25, 30, 35),
#' Gender_1 = c("Male", "Female", "Male"),
#' Income_1 = c(50000, 60000, 70000),
#' Age_2 = c(40, 45, 50),
#' Gender_2 = c("Female", "Male", "Female"),
#' Income_2 = c(80000, 90000, 100000))
#'
#' extract_base_names(dataset, underscore_count = 1)
#'


extract_base_names <- function(dataset, underscore_count = 1, keep_qualtrics_vars = FALSE, other_vars_removal = NULL, use_numbers = FALSE) {
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

  # Choose regex based on use_numbers argument
  if (use_numbers) {
    underscore_regex <- "^(.+)_(\\d+.*)$"
  } else {
    underscore_regex <- paste0("^(.+?)(_.*?){", underscore_count, "}$")
  }

  base_names <- gsub(underscore_regex, "\\1", var_names)
  unique_base_names <- unique(base_names)

  return(unique_base_names)
}



