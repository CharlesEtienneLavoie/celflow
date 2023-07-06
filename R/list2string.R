#' @title Convert List to String
#'
#' @description This function takes a list of variables as input and converts them to a string representation,
#' enclosed within `c()`. This could be useful when dealing with the formatted printing of a vector/list
#' in a user-friendly manner.
#'
#' @param var_list A list or vector of items to be converted to a string.
#'
#' @return Prints out the string representation of the input list.
#' However, the function itself does not have a return value; it is called for its side effects.
#' @references Remember to add reference here
#' @export
#' @examples
#' \dontrun{
#' list2string(c("var1", "var2", "var3"))
#' }



list2string <- function(var_list){
  # convert the elements of the list into a string
  list_string <- paste(shQuote(var_list, type = "sh"), collapse = ", ")

  # print out the formatted string
  formatted_string <- paste("c(", list_string, ")", sep="")

  print(formatted_string)
}


