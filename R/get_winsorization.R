#' @title Perform Winsorization on a Vector Based on Median Absolute Deviation (MAD)
#'
#' @description This function performs winsorization on a given vector `x` based on
#' the median absolute deviation (MAD). It replaces extreme values (those beyond
#' `criteria` number of MADs from the median) with the highest/lowest non-extreme value.
#' If there are no outliers in the vector based on the MAD criterion, the function
#' returns NULL and prints a message to the console.
#'
#' @details In statistical analysis, winsorization can be useful for limiting the
#' effect of outliers in your data. This implementation uses the MAD, a robust
#' measure of variability, to determine which data points are considered outliers.
#'
#' @param x A numeric vector to winsorize.
#' @param criteria The number of MADs from the median beyond which values are considered outliers. Defaults to 3.
#'
#' @return A winsorized vector if there are outliers based on the MAD criterion,
#' otherwise NULL.
#'
#' @examples
#' # Generate a vector with a few extreme values
#' set.seed(123)
#' x <- c(rnorm(100), 10, -10)
#'
#' # Winsorize the vector
#' x_winsorized <- get_winsorization(x, criteria = 3)
#'
#' @export


get_winsorization <- function (x, criteria = 3)
{
  if (criteria <= 0) {
    stop("bad value for 'criteria'")
  }

  med <- median(x, na.rm = TRUE)
  y <- x - med
  sc <- mad(y, center = 0, na.rm = TRUE) * criteria
  if(any(abs(y) > sc)) {
    y[y > sc] <- sc
    y[y < -sc] <- -sc
    y + med
  } else {
    NULL
  }
}

