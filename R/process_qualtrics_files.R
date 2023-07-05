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


# Function to process files
process_qualtrics_files <- function(data_files, rename_files = FALSE, new_names = NULL) {
  # If rename_files is FALSE or not provided, use the original file names
  if (!rename_files) {
    new_names <- gsub("\\.csv$", "", basename(data_files))
  }
  # If rename_files is TRUE but no new_names list is provided, create new names
  else if (is.null(new_names)) {
    new_names <- gsub(".+\\+-+(.+?)_.+", "\\1", basename(data_files))
  }

  for (i in seq_along(data_files)) {
    file <- data_files[i]
    new_name <- new_names[i]
    data <- read.csv(file, na.strings = c("", "NA", "N/A"), header = TRUE)

    # Extract labels and clean data directly within the loop
    labels <- data[1, ]
    cleaned_data <- data[-(1:2),]

    # Save and reload the cleaned data and labels directly within the loop
    filename_data <- paste0('data_', gsub('\\W', '', new_name), '.csv')
    filename_labels <- paste0('labels_data_', gsub('\\W', '', new_name), '.csv')

    write.csv(cleaned_data, filename_data, na = "")# Function to process files
    process_qualtrics_files <- function(data_files, rename_files = FALSE, new_names = NULL) {
      # If rename_files is FALSE or not provided, use the original file names
      if (!rename_files) {
        new_names <- gsub("\\.csv$", "", basename(data_files))
      }
      # If rename_files is TRUE but no new_names list is provided, create new names
      else if (is.null(new_names)) {
        new_names <- gsub(".+\\+-+(.+?)_.+", "\\1", basename(data_files))
      }

      for (i in seq_along(data_files)) {
        file <- data_files[i]
        new_name <- new_names[i]
        data <- read.csv(file, na.strings = c("", "NA", "N/A"), header = TRUE)

        # Extract labels and clean data directly within the loop
        labels <- data[1, ]
        cleaned_data <- data[-(1:2),]

        # Save and reload the cleaned data and labels directly within the loop
        filename_data <- paste0('data_', gsub('\\W', '', new_name), '.csv')
        filename_labels <- paste0('labels_data_', gsub('\\W', '', new_name), '.csv')

        write.csv(cleaned_data, filename_data, na = "")
        write.csv(labels, filename_labels, na = "")

        cleaned_data <- read.csv(filename_data, na.strings = c("", "NA", "N/A"), header = TRUE)
        labels <- read.csv(filename_labels, na.strings = c("", "NA", "N/A"), header = TRUE)

        # Assign the cleaned data and labels to new objects in the global environment
        assign(paste0('data_', gsub('\\W', '', new_name)), cleaned_data, envir = .GlobalEnv)
        assign(paste0('labels_data_', gsub('\\W', '', new_name)), labels, envir = .GlobalEnv)
      }
    }

    write.csv(labels, filename_labels, na = "")

    cleaned_data <- read.csv(filename_data, na.strings = c("", "NA", "N/A"), header = TRUE)
    labels <- read.csv(filename_labels, na.strings = c("", "NA", "N/A"), header = TRUE)

    # Assign the cleaned data and labels to new objects in the global environment
    assign(paste0('data_', gsub('\\W', '', new_name)), cleaned_data, envir = .GlobalEnv)
    assign(paste0('labels_data_', gsub('\\W', '', new_name)), labels, envir = .GlobalEnv)
  }
}



