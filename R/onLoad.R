#' @importFrom shiny registerInputHandler
.onLoad <- function(...) {
  shiny::registerInputHandler("DateRangePickerBinding", function(data, ...) {
    if (is.null(data)) {
      NULL
    } else {
      ## Return POSIX or Date, depending on format
      if (data$format == "POSIX") {
        # res <- try(as.POSIXct(c(data$start, data$end)), silent = TRUE)
        res <- try(format(as.POSIXct(c(data$start, data$end),
                                     origin = "1970-01-01 00:00:00"),
                          "%Y-%m-%d %H:%M:%S"), silent = TRUE)
      } else {
        res <- try(as.Date(c(data$start, data$end)), silent = TRUE)
      }
      if ("try-error" %in% class(res)) {
        warning("Failed to parse dates!")
        data
      } else {
        res
      }
    }
  }, force = TRUE)
}


