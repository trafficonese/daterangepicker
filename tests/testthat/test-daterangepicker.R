context("daterangepicker")

library(shiny)

end <- Sys.Date()
start <- end - 30

test_that("daterangepicker", {

  ## Errors ##############################
  expect_error(daterangepicker())
  expect_error(daterangepicker(inputId = "daterange"))
  expect_error(daterangepicker(inputId = "daterange", start = start))

  expect_error(daterangepicker(inputId = "daterange", start = start, end = end,
                  maxSpan = "days"))
  expect_error(daterangepicker(inputId = "daterange", start = start, end = end,
                  maxSpan = list("days1" = 8)))
  ################################

  x <- daterangepicker(inputId = "daterange", label = NULL,
                       start = start, end = end,
                       maxSpan = list("days" = c(1)))
  expect_is(x, "shiny.tag")
  expect_null(unlist(x$children[1:2]))

  x <- daterangepicker(inputId = "daterange",
                       start = start, end = end,
                       maxSpan = list("days" = c(1)))
  expect_is(x, "shiny.tag")
  expect_null(x$children[[2]])

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       maxSpan = list("days" = c(1)))
  expect_is(x, "shiny.tag")
  expect_false(is.null(x$children[[2]]))


  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       maxDate = Sys.Date())
  expect_is(x, "shiny.tag")

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       minDate = Sys.Date() - 10)
  expect_is(x, "shiny.tag")

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       minDate = Sys.Date() - 10,
                       maxDate = Sys.Date())
  expect_is(x, "shiny.tag")

  ## Ranges
  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       ranges = list("Gestern" = Sys.Date() - 1,
                                     "Heute" = Sys.Date(),
                                     "Letzten 3 Tage" = c(Sys.Date() - 2, Sys.Date()),
                                     "Letzten 7 Tage" = c(Sys.Date() - 6, Sys.Date()),
                                     "Letzten 45 Tage" = c(Sys.Date() - 44, Sys.Date())
                       ))
  expect_is(x, "shiny.tag")

  # x <- daterangepicker(inputId = "daterange",
  #                      icon = shiny::icon("calendar"),
  #                      start = start, end = end,
  #                      ranges = list("Gestern" = 12,
  #                                    "Heute" = "a",
  #                                    "Letzten 45 Tage" = list(1213)
  #                      ))
  # expect_is(x, "shiny.tag")


})
