#' filterEMPTY
#' Filter empty elements of a list
#' @param x The list of values
filterEMPTY <- function(x) {
  x[!lengths(x) == 0]
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
  if (!is.null(label)) {
    tags$label(label, class = "control-label",
               class = if (is.null(label)) "shiny-label-null", `for` = inputId)
  } else {
    NULL
  }
}
