#' @title Compute Power Analysis For SEM Model Using Monte Carlo Simulation
#'
#' @description Compute Power Analysis For SEM Model Using Monte Carlo
#' Simulation
#'
#' @details The function uses the simulate_data function from the lavaan
#' package to perform a monte carlo simulation. The mean, std error, z value,
#' p value and confidence intervals are then computed and reported in a table
#' for each parameter.
#'
#' @param model.population The lavaan model with population estimate values
#' specified.
#' @param model The lavaan model that will be tested in each simulation
#' @param ksim  How many simulations the function should perform
#' @param nobs  How many observations to generate in each simulation

#' @return A table.
#' @references Remember to add reference here
#' @export
#' @examples
#' library(lavaan)
#' modpop <- '
#' M ~ 0.40*X
#' Y ~ 0.30*M
#' '
#' mod <- '
#' M ~ X
#' Y ~ M
#' '
#'
#' simulate_power(modpop, mod)


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




