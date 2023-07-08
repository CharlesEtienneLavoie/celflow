#' @title Extract Base Names from Dataset Variable Names
#'
#' @description This function extracts the base names from variable names in a dataset and optionally, demo variable names.
#'
#' @details The function takes a dataset as input and extracts the base names from the variable names. It allows for flexibility in handling variable names with underscores by specifying the number of underscores to consider. By default, the function removes Qualtrics variables commonly found in survey data, but this behavior can be modified with the \code{keep_qualtrics_vars} argument. Additional variables specified by the user can also be excluded. The function can also append numbers to base names if \code{use_numbers} is set to \code{TRUE}. Variables with 'dem' or 'demo' can be excluded and separately extracted if \code{extract_demo} is \code{TRUE}. Variables with 'check' or a user-defined keyword can also be excluded.
#'
#' @param dataset The dataset from which variable names are extracted.
#' @param underscore_count The number of underscores to consider when extracting base names (default is NULL).
#' @param keep_qualtrics_vars Logical value indicating whether to keep Qualtrics variables (default is \code{FALSE}).
#' @param other_vars_removal A character vector specifying additional variables to exclude from the extraction process (default is \code{NULL}).
#' @param use_numbers Logical value indicating whether to append numbers to base names (default is \code{TRUE}).
#' @param exclude_demo Logical value indicating whether to exclude variables containing 'dem' or 'demo' (default is \code{TRUE}).
#' @param exclude_check Logical value indicating whether to exclude variables containing 'check' (default is \code{TRUE}).
#' @param keyword_exclude A string indicating a keyword to exclude from variable names (default is \code{NULL}).
#' @param extract_demo Logical value indicating whether to return a list of variables that contain 'dem' or 'demo' (default is \code{FALSE}).
#'
#' @return A character vector containing the unique base names extracted from the dataset variable names, or a list containing the base names and demo variable names if \code{extract_demo} is \code{TRUE}.
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
#' get_base_names(dataset, underscore_count = 1)
#'


get_base_names <- function(dataset, underscore_count = NULL,
                           keep_qualtrics_vars = FALSE, other_vars_removal = NULL,
                           use_numbers = TRUE, exclude_demo = TRUE,
                           exclude_check = TRUE, keyword_exclude = NULL, extract_demo = FALSE) {
  var_names <- names(dataset)

  # If extract_demo is TRUE, extract demo variables before they are potentially excluded
  demo_vars <- NULL
  if (extract_demo) {
    demo_vars <- var_names[grepl("dem|demo", var_names, ignore.case = TRUE)]
  }

  # Exclude Qualtrics vars if keep_qualtrics_vars is FALSE
  if (!keep_qualtrics_vars) {
    qualtrics_vars <- c("IPAddress", "ResponseId", "RecipientLastName",
                        'RecipientFirstName', 'RecipientEmail',
                        'ExternalReference', 'LocationLatitude',
                        'LocationLongitude', 'UserLanguage', "StartDate" ,
                        "EndDate" , "Status" , "Progress" ,
                        "Duration..in.seconds.", "Finished" ,
                        "RecordedDate", "DistributionChannel")
    var_names <- var_names[!var_names %in% qualtrics_vars]
  }

  # Exclude other vars specified by the user
  if (!is.null(other_vars_removal)) {
    var_names <- var_names[!var_names %in% other_vars_removal]
  }

  # Exclude variables containing 'dem' or 'demo' if exclude_demo is TRUE
  if (exclude_demo) {
    var_names <- var_names[!grepl("dem|demo", var_names, ignore.case = TRUE)]
  }

  # Exclude variables containing 'check' or 'Check' if exclude_check is TRUE
  if (exclude_check) {
    var_names <- var_names[!grepl("check", var_names, ignore.case = TRUE)]
  }

  # Exclude variables containing user-defined string if provided
  if (!is.null(keyword_exclude)) {
    var_names <- var_names[!grepl(keyword_exclude, var_names, ignore.case = TRUE)]
  }

  # Choose regex based on use_numbers argument
  if (use_numbers) {
    underscore_regex <- "^(.+)_(\\d+.*)$"
    # Filter out variables without a number in their name
    var_names <- var_names[grepl(underscore_regex, var_names)]
  } else if (!is.null(underscore_count)) {
    underscore_regex <- paste0("^(.+?)(_.*?){", underscore_count, "}$")
  }

  base_names <- gsub(underscore_regex, "\\1", var_names)
  unique_base_names <- unique(base_names)

  # If extract_demo is TRUE, return a list with base names and demo variables
  if (extract_demo) {
    return(list("BaseNames" = unique_base_names, "DemoVars" = demo_vars))
  }

  return(unique_base_names)
}
