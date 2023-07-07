#' @title Retrieve Specified Files from Working Directory
#'
#' @description The `get_files` function generates a list of files (default .csv,
#' can be optionally set to .sav) in the working directory that contain a specified
#' keyword in their names. If no keyword is provided, it returns all files of the
#' specified type.
#'
#' @details The function uses the `list.files()` and `grepl()` functions to retrieve
#' all files of the specified type in the working directory. If a keyword is provided,
#' it filters the list to include only those files whose names contain the keyword.
#'
#' @param keyword A character string. Only files containing this keyword in their
#' names will be included in the returned list. The search is case-sensitive.
#' Default is NULL.
#' @param filetype A character string. Specifies the type of files to be retrieved.
#' Can be "csv" (default) or "sav".
#'
#' @return A character vector of file names that matched the criteria.
#'
#' @references This function relies on base R functions `list.files()` and `grepl()`.
#' @export
#' @examples
#' \dontrun{
#' # Assume we have the following files in our working directory:
#' # "Alcohol_Study1.csv", "Alcohol_Study2.csv", "Other_Study.sav"
#'
#' # Get all 'Alcohol' related .csv files
#' get_files("Alcohol")
#' # This will return: c("Alcohol_Study1.csv", "Alcohol_Study2.csv")
#'
#' # Get all .sav files
#' get_files(filetype = "sav")
#' # This will return: c("Other_Study.sav")
#' }



get_files <- function(keyword = NULL, filetype = "csv") {
  # Create the pattern based on the filetype
  pattern <- paste0("\\.", filetype, "$")

  # Get all files of the specified type in the working directory
  all_files <- list.files(pattern = pattern)

  # If keyword is not provided, return all files of the specified type
  if (is.null(keyword)) {
    return(all_files)
  }

  # If keyword is provided, filter the files to include only those that contain the keyword
  data_files <- all_files[grepl(keyword, all_files)]

  return(data_files)
}



