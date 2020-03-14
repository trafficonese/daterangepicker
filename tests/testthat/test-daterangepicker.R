context("daterangepicker")

library(shiny)

end <- Sys.Date()
start <- end - 30

test_that("daterangepicker", {

  ## Errors ##############################
  ## No inputID
  expect_error(daterangepicker())
  ## No start/end-Date
  expect_error(daterangepicker(inputId = "daterange"))
  expect_error(daterangepicker(inputId = "daterange", start = start))
  expect_error(daterangepicker(inputId = "daterange", end = end))
  ## Wrong maxSpan
  expect_error(daterangepicker(inputId = "daterange", start = start, end = end,
                               options = daterangepickerOptions(maxSpan = "days")))
  ## Wrong maxSpan
  expect_error(daterangepicker(inputId = "daterange", start = start, end = end,
                               options = daterangepickerOptions(
                                 maxSpan = list("days1" = 8))))
  ## Wrong Ranges
  x <- expect_error(daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       ranges = list("Gestern" = 12,
                                     "Heute" = "a",
                                     "Letzten 45 Tage" = list(1213))))

  ################################

  x <- daterangepicker(inputId = "daterange", label = NULL,
                       start = start, end = end)
  expect_is(x, "shiny.tag")
  expect_null(unlist(x$children[1:2]))

  x <- daterangepicker(inputId = "daterange",
                       start = start, end = end)
  expect_is(x, "shiny.tag")
  expect_null(x$children[[2]])

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end)
  expect_is(x, "shiny.tag")
  expect_false(is.null(x$children[[2]]))
  expect_type(x$children[[2]], "list")

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       max = Sys.Date())
  expect_is(x, "shiny.tag")

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       min = Sys.Date() - 10)
  expect_is(x, "shiny.tag")

  x <- daterangepicker(inputId = "daterange",
                       icon = shiny::icon("calendar"),
                       start = start, end = end,
                       min = Sys.Date() - 10,
                       max = Sys.Date())
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

  x <- daterangepicker(inputId = "daterange",
                       start = start, end = end,
                       ranges = data.frame("Gestern" = Sys.Date() - 1,
                                           "Heute" = Sys.Date(),
                                           "Letzten 45 Tage" = c(Sys.Date() - 44, Sys.Date())
                       ))
  expect_is(x, "shiny.tag")

})
