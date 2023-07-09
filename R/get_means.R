#' @title Compute Mean Scores for Scales with Optional Reverse Scoring and Clustering
#'
#' @description This function computes mean scores for specified scales from a
#' given list. The scales are expected to be columns in the data frame starting
#' with a base name in the scale list. If a scale item needs to be reverse
#' scored (identified by "reverse" or "Reverse" in the item name), it is done
#' so before the mean is computed. An option allows renaming of reverse scored items.
#' If a cluster variable is provided, the function also computes cluster-level means for
#' each newly computed variable.
#'
#' @param data A data frame containing the scales and items.
#' @param scale_list A character vector with the base names of the scales to be computed.
#' @param reverse_score A logical indicating whether to apply reverse scoring. Default is TRUE.
#' @param rename_reversed_items A logical indicating whether to rename reverse
#' scored items by replacing "reverse" with "reversed". Default is FALSE.
#' @param order An integer indicating the order of the scale. Use 1 for first order scales
#' and 2 for second order scales. Default is 1.
#' @param cluster A character representing the name of the column to be used for clustering.
#' If provided, the function will compute cluster-level means for each new variable. Default is NULL.
#'
#' @return A data frame with the computed mean scale scores added as new columns.
#' If a cluster variable was provided, additional cluster-level mean variables are also added.
#'
#' @importFrom stringr str_detect str_replace
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @export
#'

get_means <- function(data, scale_list, reverse_score = TRUE, rename_reversed_items = FALSE, order = 1, cluster = NULL){
  new_vars <- 0 # Counter for new variables
  new_cluster_vars <- 0 # Counter for new cluster-level mean variables
  for(scale_name in scale_list){
    if(order == 1){
      item_cols <- grep(paste0("^", scale_name, "_.*[0-9](_[rR]everse|_reversed)?$"), names(data), value = TRUE)
    } else if(order == 2){
      item_cols <- grep(paste0("^", scale_name, "(_.*[0-9]|_reversed)(_[0-9]|_reversed)?$"), names(data), value = TRUE)
    }
    if(length(item_cols) > 0){
      if(reverse_score && order == 1) {
        for(col in item_cols){
          if(str_detect(col, "_[rR]everse$")){
            max_val <- max(data[[col]], na.rm = TRUE)
            min_val <- min(data[[col]], na.rm = TRUE)
            data[[col]] <- max_val - as.numeric(data[[col]]) + min_val
            cat(paste0("Variable ", col, " has been reverse scored.\n"))
            if(rename_reversed_items){
              new_name <- str_replace(col, "_[rR]everse$", "_reversed")
              colnames(data)[colnames(data) == col] <- new_name
              cat(paste0("Variable ", col, " has been renamed to ", new_name, ".\n"))
              item_cols[item_cols == col] <- new_name
            }
          }
        }
      }
      data <- data %>%
        mutate(!!scale_name := rowMeans(.[, item_cols, drop = FALSE], na.rm = TRUE))
      cat(paste0("New variable ", scale_name, " was computed from: "), paste(item_cols, collapse = ", "), "\n")
      new_vars <- new_vars + 1

      if (!is.null(cluster)) {
        cluster_means <- aggregate(data[[scale_name]], list(data[[cluster]]), mean, na.rm = TRUE)
        colnames(cluster_means) <- c(cluster, paste0(scale_name, "_between"))
        data <- merge(data, cluster_means, by = cluster)
        cat(paste0("New variable ", paste0(scale_name, "_between"), " was computed from cluster-level means of ", scale_name, "\n"))
        new_cluster_vars <- new_cluster_vars + 1 # Increment cluster-level mean variables counter
      }

    }else{
      message(paste("No variables found for scale:", scale_name))
    }
  }
  cat("\n", new_vars, "new variables were computed.\n")
  cat(new_cluster_vars, "new cluster-level mean variables were computed.\n") # Print the number of new cluster-level mean variables computed
  return(data)
}
