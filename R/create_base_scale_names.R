#' @title Create Base Scale Names
#'
#' @description This function generates base scale names from a list of scales,
#' keeping only the first few parts of each scale name as specified by the user.
#' The scales are separated into parts by an underscore (_). Scales with fewer
#' parts than a specified minimum are filtered out.
#'
#' @details For each scale in the scale list, the function splits the scale name
#' into parts based on the underscore (_). It keeps the first few parts as specified
#' by the user and combines them back into a base scale name. The base scale names are
#' then returned as a unique list.
#'
#' @param scale_list A character vector with the names of the scales to be processed.
#' @param min_parts The minimum number of parts a scale must have to be included. Default is 3.
#' @param parts_to_keep The number of parts to keep for the base scale name. Default is 2.
#'
#' @return A character vector with the base scale names.
#' @references (Optional)
#' @export
#' @examples
#' # Assuming scales is your list of scales
#' base_scales <- create_base_scale_names(scales, min_parts = 3, parts_to_keep = 2)
#' @importFrom stringr str_split




create_base_scale_names <- function(scale_list, min_parts = 3, parts_to_keep = 2) {
  # Filter out scales with less than min_parts parts
  scale_list <- scale_list[sapply(str_split(scale_list, "_"), length) >= min_parts]

  base_scales <- sapply(scale_list, function(x) {
    parts <- str_split(x, "_", simplify = TRUE)
    paste(parts[1:min(parts_to_keep, length(parts))], collapse = "_")
  })

  # Make the list unique
  base_scales <- unique(base_scales)
  return(base_scales)
}

