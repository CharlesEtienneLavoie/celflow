#' @title Clean and Filter Research Data
#'
#' @description The `clean_data` function is designed to streamline the
#' data cleaning process for psychology research. It allows for the filtering
#' of data based on a specified date range, progress threshold, and channel.
#'
#' @details This function filters data based on three optional conditions:
#' 1. Filter out all rows that do not match a specified distribution channel
#' (`channel_keep`).
#' 2. Filter out all rows that do not meet a certain progress threshold
#' (`progress_threshold`).
#' 3. Filter out all rows that are before a specified date (`date_filter`).
#'
#' The function then checks for the existence of the specified date variable
#' (`date_variable`) and that it can be parsed into a date. If the check fails,
#' an error is thrown.
#'
#' @param data A dataframe containing the data to be cleaned.
#' @param apply_channel_filter Logical, whether to apply channel filtering. Default is TRUE.
#' @param channel_keep A string specifying the channel to keep. Default is "anonymous".
#' @param apply_progress_filter Logical, whether to apply progress filtering. Default is TRUE.
#' @param progress_threshold A numeric value indicating the progress threshold. Default is 60.
#' @param apply_date_filter Logical, whether to apply date filtering. Default is TRUE.
#' @param date_variable A string specifying the name of the date variable in the dataframe. Default is "StartDate".
#' @param date_filter A list specifying the date (year, month, day) for filtering. Default is the current date.
#'
#' @return A cleaned dataframe.
#' @references Add any relevant references here.
#' @export
#' @examples
#' \dontrun{
#' cleaned_data <- clean_data(mydata,
#'                            apply_channel_filter = TRUE,
#'                            channel_keep = "anonymous",
#'                            apply_progress_filter = TRUE,
#'                            progress_threshold = 75,
#'                            apply_date_filter = TRUE,
#'                            date_variable = "StartDate",
#'                            date_filter = list(year = 2023, month = 7, day = 1))
#' }



clean_data <- function(data,
                       apply_channel_filter = TRUE,
                       channel_keep = "anonymous",
                       apply_progress_filter = TRUE,
                       progress_threshold = 60,
                       apply_date_filter = TRUE,
                       date_variable = "StartDate",
                       date_filter = c(year = 2023, month = NULL, day = NULL)) {

  # Check if provided date_variable exists in the data
  if(apply_date_filter){
    if(!date_variable %in% names(data)){
      stop(paste0(date_variable, " does not exist in the dataset. Please choose between 'StartDate', 'EndDate', or 'RecordedDate'."))
    }

    # Check if provided date variable can be parsed to Date/POSIXct
    if(!inherits(data[[date_variable]], c("Date", "POSIXct"))){
      data[[date_variable]] <- ymd_hms(data[[date_variable]])
      if(all(is.na(data[[date_variable]]))){
        stop(paste0(date_variable, " could not be parsed into a date. Check the format of the date variable."))
      }
    }

    # Create a date with specified year, month, day for filtering
    date_filter <- as.Date(paste(date_filter$year,
                                 ifelse(is.null(date_filter$month), "01", date_filter$month),
                                 ifelse(is.null(date_filter$day), "01", date_filter$day), sep = "-"))
  }

  # Perform data cleaning operations
  if(apply_channel_filter){
    original_nrows <- nrow(data)
    data <- data %>%
      filter(DistributionChannel == channel_keep)
    # Remove DistributionChannel column
    data$DistributionChannel <- NULL
    cat("\nChannel Filter:", original_nrows - nrow(data), "observations were excluded.\n")
  }

  if(apply_progress_filter){
    original_nrows <- nrow(data)
    data <- data %>%
      filter(Progress >= progress_threshold)
    cat("\nProgress Filter:", original_nrows - nrow(data), "observations were excluded.\n")
  }

  if(apply_date_filter){
    original_nrows <- nrow(data)
    data <- data %>%
      filter(ymd_hms(data[[date_variable]]) >= date_filter)
    cat("\nDate Filter:", original_nrows - nrow(data), "observations were excluded.\n")
  }

  return(data)
}




