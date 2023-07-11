#' @title Apply `bestNormalize` Transformation to Variables in a Dataset and Update Dataset Accordingly
#'
#' @description The `transform_and_update` function takes a dataset and a vector of variable names,
#' applies the `bestNormalize` function to each variable, creates transformed versions of the
#' variables when necessary, and updates the dataset and the variable list accordingly.
#' It returns a list containing the updated dataset and the updated variable list.
#'
#' @param data A dataframe to which the `bestNormalize` function should be applied.
#' @param var_list A character vector of variable names.
#' @param seed A single value, interpreted as an integer, to set the random seed for reproducibility.
#' @return A list with two elements: `data` containing the updated dataframe and `var_list` containing
#' the updated variable list.
#'
#' @examples
#' \dontrun{
#' # Generate some data
#' df <- data.frame(
#'   daily_sat_aut = rnorm(100),
#'   daily_fru_aut = rnorm(100),
#'   daily_sat_rel = rnorm(100),
#'   daily_fru_rel = rnorm(100)
#' )
#'
#' # Apply the `bestNormalize` function and update dataset
#' result <- transform_and_update(df, var_list = c("daily_sat_aut", "daily_fru_aut", "daily_sat_rel", "daily_fru_rel"))
#' updated_df <- result$data
#' updated_var_list <- result$var_list
#' }
#'
#' @importFrom bestNormalize bestNormalize
#'
#' @export

get_transformation <- function(data, var_list, seed = 100) {
  # First function to apply bestNormalize and print results
  predict_bestNormalize <- function(var_name, df) {
    var <- df[[var_name]]
    x <- bestNormalize(var, standardize = FALSE, allow_orderNorm = FALSE)
    print(var_name)
    print(x$chosen_transform)
    print(class(x$chosen_transform))
    cat("\n")
    return(x)
  }

  # Apply bestNormalize and create new dataframe
  set.seed(seed)
  new_data <- purrr::map_dfc(var_list, ~ {
    x = predict_bestNormalize(.x, data)
    if ("no_transform" %in% class(x$chosen_transform)) {
      tibble(!!.x := x$x)
    } else {
      tibble(!!paste0(.x, ".t") := predict(x))
    }
  })

  # Get the variable names from new_data that contain '.t'
  var_list_t <- names(new_data)[grepl(".t$", names(new_data))]

  # Select only '.t' variables from new_data
  new_data_t <- new_data[var_list_t]

  # Bind these '.t' variables to the original dataset
  data <- bind_cols(data, new_data_t)

  # Replace suffix for the variables in var_list based on the existence of '.t' version
  var_list_t <- ifelse(var_list %in% sub(".t$", "", var_list_t), paste0(var_list, ".t"), var_list)

  # Return the updated dataframe and the new variable list
  list(data = data, var_list = var_list_t)
}

