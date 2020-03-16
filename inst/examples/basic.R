library(shiny)
library(daterangepicker)

end <- Sys.Date()
start <- end - 30

## UI ##########################
ui <- fluidPage(
  daterangepicker(
    inputId = "daterange",
    label = "Pick a Date",
    start = start, end = end,
    icon = icon("calendar"),
    ranges = data.frame(
      "Today" = Sys.Date(),
      "Yesterday" = Sys.Date() - 1,
      "Last 3 Days" = c(Sys.Date() - 2, Sys.Date())),
    options = daterangepickerOptions(
      autoUpdateInput = FALSE,
      cancelIsClear = TRUE
      ,locale = list(
        format = "YYYY-MM-DD",
        cancelLabel = 'Clear'
      )
    )
  ),
  verbatimTextOutput("print"),
  actionButton("act", "Update Daterangepicker")
)

## SERVER ##########################
server <- function(input, output, session) {
  output$print <- renderPrint({
    req(input$daterange)
    input$daterange
  })
  observeEvent(input$act, {
    updateDaterangepicker(session, "daterange", label = "New Label",
                          start = Sys.Date() - 60,
                          end = Sys.Date() - 30,
                          icon = icon("car"),
                          options = list(
                            minYear = 2019, maxYear = 2022,
                            showDropdowns = FALSE,
                            opens = "center",
                            showCustomRangeLabel = FALSE,
                            alwaysShowCalendars = FALSE
                          ))
  })
}

shinyApp(ui, server)
