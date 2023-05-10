# daterangepicker

<p align="center">
  <img src="./man/figures/daterangepicker.PNG" align="right" width="300"/>
</p>

<!-- badges: start -->
[![](https://www.r-pkg.org/badges/version/daterangepicker)](https://www.r-pkg.org/pkg/daterangepicker)
[![cran checks](https://badges.cranchecks.info/worst/daterangepicker.svg)](https://cran.r-project.org/web/checks/check_results_daterangepicker.html)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/daterangepicker?color=brightgreen)](https://www.r-pkg.org/pkg/daterangepicker)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/daterangepicker)](https://cranlogs.r-pkg.org/badges/grand-total/daterangepicker)
[![R build status](https://github.com/trafficonese/daterangepicker/workflows/R-CMD-check/badge.svg)](https://github.com/trafficonese/daterangepicker/actions)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![Codecov test coverage](https://codecov.io/gh/trafficonese/daterangepicker/branch/master/graph/badge.svg)](https://app.codecov.io/gh/trafficonese/daterangepicker?branch=master)
<!-- badges: end -->

Custom Shiny input binding for a [Date Range Picker](https://www.daterangepicker.com/).

## Installation from CRAN

``` r
install.packages("daterangepicker")
```

or the dev version:
``` r
# install.packages("remotes")
remotes::install_github("trafficonese/daterangepicker")
```

## Example

A basic example of a Date Range Picker:

``` r
library(shiny)
library(daterangepicker)

## UI ##########################
ui <- fluidPage(
  daterangepicker(
    inputId = "daterange",
    label = "Pick a Date",
    start = Sys.Date() - 30, end = Sys.Date(),
    style = "width:100%; border-radius:4px",
    icon = icon("calendar")
  ),
  verbatimTextOutput("print"),
  actionButton("act", "Update Daterangepicker"),
)

## SERVER ##########################
server <- function(input, output, session) {
  output$print <- renderPrint({
    req(input$daterange)
    input$daterange
  })
  observeEvent(input$act, {
    updateDaterangepicker(session, "daterange",
                          start = Sys.Date(), 
                          end = Sys.Date() - 100)
  })
}

shinyApp(ui, server)
```

Further examples are in [/inst/examples/](https://github.com/trafficonese/daterangepicker/tree/master/inst/examples)

## Further Information

Check out the [Configuration Generator](https://www.daterangepicker.com/#config) for a Live-Demo of the different options. 
