#' Clean and filter survey responses
#'
#' This function cleans and filters survey response data based on a variety of user-specified criteria. This includes
#' filtering based on distribution channel, progress threshold, and response date.
#'
#' @param data A data.frame containing the survey response data.
#' @param apply_channel_filter Logical; if TRUE, filter responses based on distribution channel.
#' @param channel_keep The name of the distribution channel to keep. Responses from other channels are excluded.
#' @param apply_progress_filter Logical; if TRUE, filter responses based on progress threshold.
#' @param progress_threshold The minimum required progress for a response to be included in the cleaned data.
#' @param apply_date_filter Logical; if TRUE, filter responses based on response date.
#' @param date_variable The name of the column in the data.frame containing response dates.
#' @param date_filter A list specifying the earliest date (year, month, day) to include in the cleaned data.
#' @return A data.frame of the cleaned survey response data.
#' @export
#'
#' @examples
#' \dontrun{
#' cleaned_data <- clean_answers(data = survey_data,
#'                               apply_channel_filter = TRUE,
#'                               channel_keep = "anonymous",
#'                               apply_progress_filter = TRUE,
#'                               progress_threshold = 60,
#'                               apply_date_filter = TRUE,
#'                               date_variable = "StartDate",
#'                               date_filter = c(year = 2023, month = NULL, day = NULL))
#' }

clean_answers <- function(data,
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
