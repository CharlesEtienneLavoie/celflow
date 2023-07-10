#' @title Compute Mean Scores for Scales with Optional Reverse Scoring and Clustering
#'
#' @description This function computes mean scores for specified scales derived from a given
#' data frame. The scales are anticipated to be represented as columns in the data frame that
#' begin with a base name specified in the scale list. Items that require reverse scoring
#' (identified by "reverse" or "Reverse" in the item name) are automatically reversed before
#' calculating the mean. An option is provided to rename reversed scored items. If a clustering
#' variable is specified, the function also computes cluster-level means for each newly computed
#' variable.
#'
#' @param data A data frame containing the scales and items.
#' @param scale_list A vector of characters representing the base names of the scales to compute.
#' @param reverse_score A logical indicating whether reverse scoring should be applied. Default is TRUE.
#' @param rename_reversed_items A logical indicating whether to rename reverse scored items by
#' replacing "reverse" with "reversed". Default is FALSE.
#' @param order An integer indicating the order of the scale. Use 1 for first order scales
#' and 2 for second order scales. Default is 1.
#' @param cluster A character string representing the column name used for clustering. If provided,
#' the function computes cluster-level means for each new variable. Default is NULL.
#'
#' @return A data frame with new columns of computed mean scale scores. If a cluster variable
#' was provided, additional columns representing cluster-level mean variables are added.
#'
#' @importFrom stringr str_detect str_replace
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @export
#'


get_means <- function(data, scale_list, reverse_score = TRUE, rename_reversed_items = FALSE, order = 1, cluster = NULL) {

  # Helper function to determine the second last non-numeric chunk
  get_second_last_non_numeric_chunk <- function(x) {
    x <- sapply(x, function(name) {
      parts <- str_split(name, "_")[[1]]
      numeric_indices <- which(suppressWarnings(sapply(parts, function(chunk) {
        return(!is.na(as.numeric(chunk)))
      })))

      non_numeric_index <- ifelse(length(numeric_indices) > 0, max(numeric_indices) - 2, length(parts) - 1)

      # concatenate the parts up to the second to last non-numeric part
      return(str_c(parts[1:non_numeric_index], collapse = "_"))
    }, USE.NAMES = FALSE)

    # Identify constant chunks
    constant_chunks <- sapply(str_split(scale_list, "_"), function(parts) parts[1])

    # Exclude constant chunks from the output
    x <- x[!x %in% constant_chunks]

    unique(x)
  }

  # Modify scale_list according to 'order' argument
  if (order == 2) {
    scale_list <- get_second_last_non_numeric_chunk(scale_list)
  }

  # Initialize counters for new variables and new cluster-level mean variables
  new_vars <- 0
  new_cluster_vars <- 0

  # Loop over each scale name in the provided list
  for(scale_name in scale_list){
    # Generate a regular expression pattern based on the scale name and use this to match column names in the dataset
    item_cols <- grep(paste0("^", scale_name, "_.*[0-9](_[rR]everse|_reversed)?$"), names(data), value = TRUE)
    if(length(item_cols) > 0){
      if(reverse_score) {
        for(col in item_cols){
          if(str_detect(col, "_[rR]everse$")){
            # Reverse score the values in this column
            max_val <- max(data[[col]], na.rm = TRUE)
            min_val <- min(data[[col]], na.rm = TRUE)
            data[[col]] <- max_val - as.numeric(data[[col]]) + min_val
            cat(paste0("Variable ", col, " has been reverse scored.\n"))
            if(rename_reversed_items){
              # Rename the column
              new_name <- str_replace(col, "_[rR]everse$", "_reversed")
              colnames(data)[colnames(data) == col] <- new_name
              cat(paste0("Variable ", col, " has been renamed to ", new_name, ".\n"))
              item_cols[item_cols == col] <- new_name
            }
          }
        }
      }
      # Compute a new variable in the dataset
      data <- data %>%
        mutate(!!scale_name := rowMeans(.[, item_cols, drop = FALSE], na.rm = TRUE))
      cat(paste0("New variable ", scale_name, " was computed from: "), paste(item_cols, collapse = ", "), "\n")
      new_vars <- new_vars + 1

      if (!is.null(cluster)) {
        # Compute cluster-level means for the new variable
        cluster_means <- aggregate(data[[scale_name]], list(data[[cluster]]), mean, na.rm = TRUE)
        colnames(cluster_means) <- c(cluster, paste0(scale_name, "_between"))
        data <- merge(data, cluster_means, by = cluster)
        cat(paste0("New variable ", paste0(scale_name, "_between"), " was computed from cluster-level means of ", scale_name, "\n"))
        new_cluster_vars <- new_cluster_vars + 1
      }
    } else if(order != 2 || (order == 2 && any(str_detect(scale_name, second_last_non_numeric_chunks)))){
      # Only print a message if order != 2, or if order == 2 but the scale_name still contains any of the second last non-numeric chunks
      message(paste("No variables found for scale:", scale_name))
    }
  }
  cat("\n", new_vars, "new variables were computed.\n")
  cat(new_cluster_vars, "new cluster-level mean variables were computed.\n")
  return(data)
}
