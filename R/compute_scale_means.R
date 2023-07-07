#' @title Compute Mean Scores for Scales with Optional Reverse Scoring
#'
#' @description This function computes mean scores for specified scales from a
#' given list. The scales are expected to be columns in the data frame starting
#' with a base name in the scale list. If a scale item needs to be reverse
#' scored (identified by "reverse" or "Reverse" in the item name), it is done
#' so before the mean is computed. An option allows renaming of reverse scored items.
#'
#' @details For each scale in the scale list, the function first identifies the
#' matching columns in the data frame. Then it checks each item to see if it needs
#' to be reverse scored, applies reverse scoring if the reverse_score argument is TRUE,
#' and finally computes the mean for each scale. Messages are printed to indicate which
#' new variables were computed, which variables were reverse scored, and which variables
#' were renamed.
#'
#' @param data A data frame containing the scales and items.
#' @param scale_list A character vector with the base names of the scales to be computed.
#' @param reverse_score A logical indicating whether to apply reverse scoring. Default is TRUE.
#' @param rename_reversed_items A logical indicating whether to rename reverse
#' scored items by replacing "reverse" with "reversed". Default is FALSE.
#'
#' @return A data frame with the computed mean scale scores added as new columns.
#' @references (Optional)
#' @export
#' @examples
#' # Assuming data.df is your data frame and scale_list is your list of scales
#' data.df <- compute_scale_means(data.df, scale_list, reverse_score = TRUE, rename_reversed_items = TRUE)
#' @importFrom stringr str_detect str_replace
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%


compute_scale_means <- function(data, scale_list, reverse_score = TRUE, rename_reversed_items = FALSE){

  new_vars <- 0 # Counter for new variables

  for(scale_name in scale_list){
    # Get the names of the columns that start with the scale name
    item_cols <- grep(paste0("^", scale_name, "_"), names(data), value = TRUE)

    # Check if there are any matching columns in the dataset
    if(length(item_cols) > 0){

      if(reverse_score) {
        # Check if reverse scoring is needed and apply it
        for(col in item_cols){
          if(str_detect(col, "reverse|Reverse")){
            # Find max and min values for the variable
            max_val <- max(data[[col]], na.rm = TRUE)
            min_val <- min(data[[col]], na.rm = TRUE)

            # Reverse score the variable
            data[[col]] <- max_val - as.numeric(data[[col]]) + min_val

            # Print a message about reverse scoring
            cat(paste0("Variable ", col, " has been reverse scored.\n"))

            # Rename reversed items if specified
            if(rename_reversed_items){
              new_name <- str_replace(col, "reverse|Reverse", "Reversed")
              colnames(data)[colnames(data) == col] <- new_name
              cat(paste0("Variable ", col, " has been renamed to ", new_name, ".\n"))

              # Update item_cols with the new name
              item_cols[item_cols == col] <- new_name
            }
          }
        }
      }

      # Compute the row mean of the items for the scale
      data <- data %>%
        mutate(!!scale_name := rowMeans(.[, item_cols, drop = FALSE], na.rm = TRUE))

      # Print the new variable and the columns that went into it
      cat(paste0("New variable ", scale_name, " was computed from: "), paste(item_cols, collapse = ", "), "\n")

      # Increase counter
      new_vars <- new_vars + 1
    }else{
      message(paste("No variables found for scale:", scale_name))
    }
  }

  # Print the number of new variables computed
  cat("\n", new_vars, "new variables were computed.\n")

  return(data)
}
