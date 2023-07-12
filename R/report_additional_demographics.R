#' @title Report Descriptive Statistics for Demographics
#'
#' @description The `report_additional_demographics` function generates a summary
#' report of descriptive statistics (counts and percentages) for demographic variables
#' such as income, employment status, and weekly alcohol units.
#'
#' @details The function allows each demographic to be optional.
#' If a demographic parameter is set to null (default), the function will not perform any
#' operations related to that demographic. If a valid demographic variable name
#' is passed as a parameter, the function will calculate the number of instances and
#' the corresponding percentage for each category in the given demographic variable.
#'
#' @param data A dataframe that contains the demographic variables.
#' @param income A string that represents the name of the income variable in the data (default: NULL).
#' @param empl_status A string that represents the name of the employment status variable in the data (default: NULL).
#' @param alcohol_units A string that represents the name of the weekly alcohol units variable in the data (default: NULL).
#'
#' @return A string containing the descriptive statistics for each demographic variable provided.
#'
#' @examples
#' \dontrun{
#' data <- data.frame(
#'  demo_income_c = sample(c("$100,001 - $125,000", "$125,001 - $150,000"), 100, replace = TRUE),
#'  demo_empl_status_c = sample(c("Full-time", "Part-time"), 100, replace = TRUE),
#'  demo_alcohol_units_c = sample(c("1-4", "5-9"), 100, replace = TRUE)
#' )
#'
#' report_additional_demographics(
#'   data = data,
#'   income = "demo_income_c",
#'   empl_status = "demo_empl_status_c",
#'   alcohol_units = "demo_alcohol_units_c"
#' )
#' }
#'
#' @export
report_additional_demographics <- function(data, income = NULL, empl_status = NULL, alcohol_units = NULL) {

  report <- c()

  if(!is.null(income)){
    income_descriptives <- data %>%
      group_by(.data[[income]]) %>%
      summarise(n = n(), percentage = n() / nrow(data) * 100) %>%
      mutate(description = paste0(round(percentage, 2), "% ", .data[[income]], " (n=", n, ")")) %>%
      pull(description) %>%
      paste0(collapse = "; ")

    report <- c(report, paste("Income levels:", income_descriptives))
  }

  if(!is.null(empl_status)){
    empl_status_descriptives <- data %>%
      group_by(.data[[empl_status]]) %>%
      summarise(n = n(), percentage = n() / nrow(data) * 100) %>%
      mutate(description = paste0(round(percentage, 2), "% ", .data[[empl_status]], " (n=", n, ")")) %>%
      pull(description) %>%
      paste0(collapse = "; ")

    report <- c(report, paste("Employment Status:", empl_status_descriptives))
  }

  if(!is.null(alcohol_units)){
    alcohol_units_descriptives <- data %>%
      group_by(.data[[alcohol_units]]) %>%
      summarise(n = n(), percentage = n() / nrow(data) * 100) %>%
      mutate(description = paste0(round(percentage, 2), "% ", .data[[alcohol_units]], " (n=", n, ")")) %>%
      pull(description) %>%
      paste0(collapse = "; ")

    report <- c(report, paste("Weekly Alcohol Units:", alcohol_units_descriptives))
  }

  report <- paste(report, collapse = "\n")

  return(report)
}
