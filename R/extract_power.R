#' Extract Power Analysis Results
#'
#' This function calculates the statistical power of SEM models based on simulation results, providing a detailed summary including the convergence rate of simulations.
#'
#' @param data A dataframe containing the results of SEM simulations, typically produced by a function like \code{simulate_power}. It should include parameters estimates, p-values, and confidence intervals.
#' @param target A vector of strings specifying which parameters (paths) to analyze for power. These should match entries in the 'Parameter' column of the `data`.
#'
#' @return A dataframe summarizing the power analysis results for specified paths. Each row corresponds to a path with the following columns:
#' \itemize{
#'   \item{Value}{Mean estimate of the path coefficient across simulations.}
#'   \item{Median}{Median estimate of the path coefficient.}
#'   \item{Power}{Proportion of simulations where the path was statistically significant (p < 0.05), excluding NA values.}
#'   \item{`Power (All Cases)`}{Proportion of simulations where the path was significant, treating NAs as non-significant.}
#'   \item{CI_lower}{Average lower bound of the confidence interval for the path estimate.}
#'   \item{CI_upper}{Average upper bound of the confidence interval for the path estimate.}
#' }
#' @examples
#' # Assume 'sim_results' is a dataframe from simulate_power()
#' target_paths <- c("M ~ X", "Y ~ M")
#' power_summary <- extract_power(sim_results, target_paths)
#'
#' @export
extract_power <- function(data, target) {
  data2 <- data %>%
    dplyr::filter(Parameter %in% target) %>%
    dplyr::mutate(n.na = is.na(pvalue),
                  sig.p = pvalue < .05,
                  sig.p2 = ifelse(is.na(sig.p), FALSE, sig.p)) %>%
    dplyr::group_by(Parameter)
  ksim <- attributes(data)$ksim
  convr <- (ksim - sum(data2$n.na)) / ksim
  cat("Your convergence rate is:", convr, "\n")
  data2 <- data2 %>%
    dplyr::summarize(Value = mean(est, na.rm = TRUE),
                     Median = median(est, na.rm = TRUE),
                     Power = sum(sig.p, na.rm = TRUE) / n(),
                     `Power (All Cases)` = sum(sig.p2) / n(),
                     CI_lower = mean(ci.lower, na.rm = TRUE),
                     CI_upper = mean(ci.upper, na.rm = TRUE))
  return(data2)
}
