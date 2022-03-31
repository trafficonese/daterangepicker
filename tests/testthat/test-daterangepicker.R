context("daterangepicker")

library(shiny)

end <- Sys.Date()
start <- end - 30

test_that("daterangepicker", {
  ## Errors ##############################
  ## No inputID
  expect_error(daterangepicker())
  ## Wrong maxSpan
  expect_error(
    daterangepicker(inputId = "daterange", start = start, end = end,
                    options = daterangepickerOptions(maxSpan = "days")))
  ## Wrong maxSpan
  expect_error(
    daterangepicker(inputId = "daterange", start = start, end = end,
                    options = daterangepickerOptions(
                      maxSpan = list("days1" = 8))))
  ## Wrong Ranges
  expect_error(daterangepicker(inputId = "daterange",
                               icon = shiny::icon("calendar"),
                               start = start, end = end,
                               ranges = list("Gestern" = 12,
                                             "Heute" = "a",
                                             "Letzten 45 Tage" = list(1213))))


  ## Daterangepicker ############################
  x <- daterangepicker(inputId = "daterange")
  expect_is(x, "shiny.tag")
  expect_null(unlist(x$children[2]))
  expect_length(object = htmltools::findDependencies(x), n = 1)
  expect_true("daterangepicker" %in% unlist(
    lapply(htmltools::findDependencies(x), `[[`, "name")))

  x <- daterangepicker(inputId = "daterange", start = start)
  expect_is(x, "shiny.tag")
  expect_null(unlist(x$children[2]))
  expect_length(object = htmltools::findDependencies(x), n = 1)
  expect_true("daterangepicker" %in% unlist(
    lapply(htmltools::findDependencies(x), `[[`, "name")))

  x <- daterangepicker(inputId = "daterange", end = end)
  expect_is(x, "shiny.tag")
  expect_null(unlist(x$children[2]))
  expect_length(object = htmltools::findDependencies(x), n = 1)
  expect_true("daterangepicker" %in% unlist(
    lapply(htmltools::findDependencies(x), `[[`, "name")))

  x <- daterangepicker(inputId = "daterange", label = NULL,
                       start = start, end = end)
  expect_is(x, "shiny.tag")
  expect_null(unlist(x$children[1:2]))
  expect_length(object = htmltools::findDependencies(x), n = 1)
  expect_true("daterangepicker" %in% unlist(
    lapply(htmltools::findDependencies(x), `[[`, "name")))

  x <- daterangepicker(inputId = "daterange",
                       start = start, end = end)
  expect_is(x, "shiny.tag")
  expect_null(x$children[[2]])
  expect_length(object = htmltools::findDependencies(x), n = 1)

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end)
  expect_is(x, "shiny.tag")
  expect_false(is.null(x$children[[2]]))
  expect_type(x$children[[2]], "list")
  expect_length(object = htmltools::findDependencies(x), n = 2)
  expect_true("daterangepicker" %in% unlist(
    lapply(htmltools::findDependencies(x), `[[`, "name")))

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       max = Sys.Date())
  expect_is(x, "shiny.tag")
  expect_length(object = htmltools::findDependencies(x), n = 2)

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       min = Sys.Date() - 10)
  expect_is(x, "shiny.tag")
  expect_length(object = htmltools::findDependencies(x), n = 2)

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       min = Sys.Date() - 10,
                       max = Sys.Date())
  expect_is(x, "shiny.tag")
  expect_length(object = htmltools::findDependencies(x), n = 2)

  ## Ranges
  x <- daterangepicker(
    inputId = "daterange",
    icon = shiny::icon("calendar"),
    start = start, end = end,
    ranges = list("Gestern" = Sys.Date() - 1,
                  "Heute" = Sys.Date(),
                  "Letzten 3 Tage" = c(Sys.Date() - 2, Sys.Date()),
                  "Letzten 7 Tage" = c(Sys.Date() - 6, Sys.Date()),
                  "Letzten 45 Tage" = c(Sys.Date() - 44, Sys.Date())
    ))
  expect_is(x, "shiny.tag")
  expect_length(object = htmltools::findDependencies(x), n = 2)

  x <- daterangepicker(
    inputId = "daterange",
    start = start, end = end,
    ranges = data.frame("Gestern" = Sys.Date() - 1,
                        "Heute" = Sys.Date(),
                        "Letzten 45 Tage" = c(Sys.Date() - 44, Sys.Date())
    ))
  expect_is(x, "shiny.tag")
  expect_length(object = htmltools::findDependencies(x), n = 1)

  ## Updates #########################
  session <- as.environment(list(
    ns = identity,
    sendInputMessage = function(inputId, message) {
      session$lastInputMessage = list(id = inputId, message = message)
    }
  ))

  updateDaterangepicker(session, "daterange", label = "NewLabel",
                        start = start, end = end)
  res <- session$lastInputMessage
  expect_identical(res$message$id, "daterange")
  expect_identical(res$message$label, "NewLabel")
  expect_identical(res$message$start, start)
  expect_identical(res$message$end, end)

  updateDaterangepicker(session, "daterange", label = "NewLabel",
                        start = start, end = end, icon = icon("calendar"))
  res <- invisible(session$lastInputMessage)
  expect_identical(res$message$id, "daterange")
  expect_identical(res$message$label, "NewLabel")
  expect_identical(res$message$start, start)
  expect_identical(res$message$end, end)
  expect_is(res$message$icon, "shiny.tag")
  expect_is(res$message$icon$htmldeps[[1]], "html_dependency")
  expect_length(res$message$icon$htmldeps[[1]], 9)

  ## onLoad #######################
  expect_null(daterangepicker:::.onLoad()(NULL))

  war <- list(start = "sysd - 10", end = end, format = "Date")
  x <- expect_warning(daterangepicker:::.onLoad()(war))
  expect_identical(x, war)

  data <- list(start = start - 10,
               end = end,
               format = "Date")
  x <- daterangepicker:::.onLoad()(data)
  expect_identical(x[1], start - 10)
  expect_identical(x[2], end)

  data <- list(start = start - 10,
               end = end,
               format = "POSIX")
  x <- daterangepicker:::.onLoad()(data)
  expect_identical(x[1], as.POSIXct(start - 10))
  expect_identical(x[2], as.POSIXct(end))
})
