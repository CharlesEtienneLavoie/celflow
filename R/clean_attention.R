#' @title Clean Attention Check Failures in a Dataset
#'
#' @description The `clean_attention` function identifies and removes responses
#' from participants who failed attention checks in a survey dataset. It operates
#' by comparing participant responses to a set of correct answers. It can be
#' configured to treat missing responses as incorrect. The function calculates
#' the total number of correct responses per participant and removes participants
#' who do not reach a specified minimum number of correct answers.
#'
#' @param data A dataframe where attention check failures need to be identified and removed.
#' @param questions A character vector of column names in the dataframe that represent the questions
#' used for attention checks.
#' @param correct_answers A numeric vector of the correct answers to the attention check
#' questions. Must be the same length as the `questions` vector.
#' @param min_correct The minimum number of correct answers a participant must
#' have to be retained in the dataframe (default is 1).
#' @param set_missing_to_zero A logical value indicating whether missing responses should
#' be treated as incorrect (default is FALSE).
#'
#' @return A dataframe where responses from participants who failed the attention
#' checks have been removed.
#' @references Remember to add reference here.
#' @export
#' @examples
#' \dontrun{
#' # Generate some data
#' df <- data.frame(
#'   q1 = c(1, 2, 3, 2, 2, 1, 3, 2, 1, 2),
#'   q2 = c(2, 2, 3, 1, 2, 3, 2, 3, 1, 2),
#'   q3 = c(3, 2, 1, 2, 2, 3, 1, 3, 2, 1)
#' )
#'
#' # Specify the correct answers
#' correct_answers <- c(2, 3, 1)
#'
#' # Clean the data
#' clean_data <- clean_attention(df, questions = c("q1", "q2", "q3"),
#' correct_answers = correct_answers, min_correct = 2, set_missing_to_zero = TRUE)
#' }
clean_attention <- function (data, questions, correct_answers, min_correct = 1, set_missing_to_zero = FALSE) {

  # Ensure that the length of questions and correct_answers are the same
  if (length(questions) != length(correct_answers)) {
    stop("The length of the questions vector and the correct answers vector must be the same.")
  }

  # Loop over each question
  for (i in 1:length(questions)) {

    # Initialize a new column for each question's correct answer
    data[paste0("correct_answer", i)] <- numeric(nrow(data))

    # Calculate the number of missing responses for the current question
    num_na <- sum(is.na(data[[questions[i]]]))
    cat("Number of participants with NA for ", questions[i], ": ", num_na, "\n")

    # Loop over each row (participant) in the data
    for (j in 1:nrow(data)) {

      # Check if the current response is missing
      if (is.na(data[j, questions[i]])) {
        if (set_missing_to_zero) {
          data[j, paste0("correct_answer", i)] <- 0
        }

        # Check if the current response is correct
      } else if (data[j, questions[i]] == correct_answers[i]) {
        data[j, paste0("correct_answer", i)] <- 1

        # The current response is incorrect
      } else {
        data[j, paste0("correct_answer", i)] <- 0
      }
    }
  }

  # Calculate the total number of correct answers for each participant
  if(length(questions) > 1) {
    data$correct_answer_total <- rowSums(data[, sapply(1:length(questions), function(x) paste0("correct_answer", x))])
  } else {
    data$correct_answer_total <- data[, sapply(1:length(questions), function(x) paste0("correct_answer", x))]
  }

  # Calculate the number of initial and remaining participants
  num_initial_participants <- nrow(data)
  num_remaining_participants <- nrow(data[data$correct_answer_total >= min_correct, ])

  # Print the number of participants excluded due to failing attention checks
  cat("Number of participants excluded due to failing attention checks: ", num_initial_participants - num_remaining_participants, "\n")

  # Exclude participants who failed the attention checks
  data <- data[data$correct_answer_total >= min_correct, ]

  return(data)
}
