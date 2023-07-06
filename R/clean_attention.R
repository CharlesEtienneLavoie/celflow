#' @title Clean Attention Check Failures in a Dataset
#'
#' @description The `clean_attention` function identifies and removes responses
#' from participants who failed attention checks in a survey dataset. It operates
#' by comparing participant responses to a set of correct answers. It can be
#' configured to treat missing responses as incorrect. The function calculates
#' the total number of correct responses per participant and removes participants
#' who do not reach a specified minimum number of correct answers.
#'
#' @param data A dataset where attention check failures need to be identified and removed.
#' @param questions A vector of column names in the dataset that represent the questions
#' used for attention checks.
#' @param correct_answers A vector of the correct answers to the attention check
#' questions. Must be the same length as the `questions` vector.
#' @param min_correct The minimum number of correct answers a participant must
#' have to be retained in the dataset (default is 1).
#' @param set_missing_to_zero A logical value to decide if missing responses should
#' be treated as incorrect (default is FALSE).
#'
#' @return A dataset where responses from participants who failed the attention
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



clean_attention <- function(data, questions, correct_answers, min_correct = 1, set_missing_to_zero = FALSE) {
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

