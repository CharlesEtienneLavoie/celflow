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


create_correct_answer_total <- function(data, questions, correct_answers, min_correct = 1, set_missing_to_zero = FALSE) {
  # Check that the correct answers vector has the same length as the questions vector
  if (length(questions) != length(correct_answers)) {
    stop("The length of the questions vector and the correct answers vector must be the same.")
  }

  for (i in 1:length(questions)) {
    # Initialize a new column for each question to store whether the answer is correct
    data[paste0("correct_answer", i)] <- numeric(nrow(data))

    # Count the number of NAs for each question
    num_na <- sum(is.na(data[[questions[i]]]))
    cat("Number of participants with NA for ", questions[i], ": ", num_na, "\n")

    # For each row in the data, check if the answer is correct
    for (j in 1:nrow(data)) {
      # Check if the answer is missing and if missing answers should be treated as incorrect
      if (is.na(data[j, questions[i]]) && set_missing_to_zero) {
        data[j, paste0("correct_answer", i)] <- 0
      } else if (data[j, questions[i]] == correct_answers[i]) {  # Check if the answer is correct
        data[j, paste0("correct_answer", i)] <- 1
      } else {  # The answer is incorrect
        data[j, paste0("correct_answer", i)] <- 0
      }
    }
  }

  # Calculate the total number of correct answers for each participant
  data$correct_answer_total <- rowSums(data[, sapply(1:length(questions), function(x) paste0("correct_answer", x))])

  # Print the number of participants that will be excluded based on the min_correct criterion
  num_initial_participants <- nrow(data)
  num_remaining_participants <- nrow(data[data$correct_answer_total >= min_correct, ])
  cat("Number of participants excluded due to failing attention checks: ", num_initial_participants - num_remaining_participants, "\n")

  # Exclude participants that do not meet the min_correct criterion
  data <- data[data$correct_answer_total >= min_correct, ]

  return(data)
}

