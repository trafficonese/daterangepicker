library(shiny)
library(daterangepicker)

## UI ##########################
ui <- fluidPage(
  br(),
  tags$head(
    tags$style("
                       .somenewclass {
                          background-color: yellow !important;
                          color: green !important;
                          border-radius: 4px !important;
                       }
                       ")),
  splitLayout(
    cellWidths = c("30%", "70%"),
    div(
      div(icon("calendar"), HTML("<b>Date Range</b>")),
      daterangepicker(
        inputId = "datepicker",
        style = "width:100%;text-align:center;",
        class = "form-control",
        label = NULL,
        start = Sys.Date() - 30,
        end = as.Date(Sys.time()),
        max = as.Date(Sys.time()) + 1,
        min = Sys.Date() - 100,
        ranges = list(
          "Today" = Sys.Date(),
          "2 Days from 6:00 to 18:00" = c(
            as.POSIXct("2022-03-01 06:00:00"),
            as.POSIXct("2022-03-03 18:00:00")),
          "Last 3 days" = c(Sys.Date() - 2, Sys.Date()),
          "Last 7 days" = c(Sys.Date() - 6, Sys.Date()),
          "Last 30 days" = c(Sys.Date() - 29, Sys.Date())
        ),
        options = daterangepickerOptions(
          timePicker = TRUE,
          alwaysShowCalendars = TRUE,
          autoApply = TRUE,
          locale = list(
            separator = " - ",
            format = "DD-MM-Y HH:mm:ss"
          )
        )
      )
    ),
    div(
      verbatimTextOutput("print"),
      actionButton("act", "Update Daterangepicker (start/end/min/max/style)"),
      actionButton("class", "Update Daterangepicker (class)"),
      actionButton("range", "Update Daterangepicker (ranges)")
    )
  )
)

## SERVER ##########################
server <- function(input, output, session) {
  output$print <- renderPrint({
    req(input$datepicker)
    input$datepicker
  })
  observeEvent(input$act, {
    updateDaterangepicker(
      session, "datepicker",
      start = Sys.Date(), end = Sys.Date() - 100,
      min = Sys.Date() - 20,
      max = Sys.Date() - 2,
      style = "border-radius:20px;text-align:left;color:red"
    )
  })
  observeEvent(input$class, {
    updateDaterangepicker(session, "datepicker", class = "somenewclass")
  })
  observeEvent(input$range, {
    updateDaterangepicker(
      session, "datepicker",
      ranges = list(
        "Today" = Sys.Date(),
        "Last 400.000 ms" = c(Sys.time() - 400000, Sys.time()),
        "Last 5 days" = c(Sys.Date() - 4, Sys.Date()),
        "Last 60 days" = c(Sys.Date() - 60, Sys.Date())
      ))
  })
}

shinyApp(ui, server)
