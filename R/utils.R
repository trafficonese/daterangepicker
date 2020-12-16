#' filterEMPTY
#' Filter empty elements of a list
#' @param x The list of values
filterEMPTY <- function(x) {
  x[!lengths(x) == 0]
}

#' checkRanges
#' Check the ranges element, for Date objects
#' @param ranges The list of ranges
checkRanges <- function(ranges) {
  cls <- lapply(ranges, class)
  if (!all(unlist(cls) %in% c("Date","POSIXct","POSIXt","POSIXlt", "numeric"))) {
    stop("All elements of `ranges` must be of class:\n",
         "`Date`, `POSIXct`, `POSIXlt`, `POSIXt` or `numeric`.")
  } else {
    ranges <- lapply(ranges, as.Date, origin = "1970-01-01")
    ranges <- lapply(ranges, as.character)
  }
  ranges
}

#' checkMaxSpan
#' Check the maxSpan element, for Time objects
#' @param maxSpan The list of ranges
checkMaxSpan <- function(maxSpan) {
  if (!is.list(maxSpan) && length(maxSpan) == 1)
    stop("`maxSpan` must be a named list with a numeric value.")
  choicesmaxspan <- c("milliseconds","seconds","minutes",
                      "days","months","years")
  if (!names(maxSpan) %in% choicesmaxspan)
    stop("The valid names for `maxSpan` are:\n",
         paste(choicesmaxspan, collapse = ", "))
}

#' makeInput
#' Make the input div-tag
#' @param label The label of the daterangepicker
#' @param inputId The inputId of the daterangepicker
#' @param class The class of the daterangepicker
#' @param icon The icon of the daterangepicker
#' @param style The style of the daterangepicker
#' @param options The options of the daterangepicker
makeInput <- function(label, inputId, class, icon, style, options) {
  tags$div(
    class = "form-group shiny-input-container",
    makeLabel(label, inputId),
    icon,
    tags$input(
      id = inputId,
      class = paste("daterangepickerclass", class),
      name = "daterangepicker",
      type = "text",
      style = style,
      options = jsonify::to_json(options, unbox = TRUE)
    )
  )
}

#' makeLabel
#' Make the label
#' @param label The label of the daterangepicker
#' @param inputId The inputId of the daterangepicker
makeLabel <- function(label, inputId) {
  if (is.null(label)) {
    NULL
  } else {
    tags$label(label, class = "control-label", `for` = inputId)
  }
}
