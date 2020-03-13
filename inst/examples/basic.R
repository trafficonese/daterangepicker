library(shiny)
library(daterangepicker)

end <- Sys.Date()
start <- end - 30

## UI ##########################
ui <- fluidPage(
  tags$head(tags$style(".myclass {
                        /*margin: 50px 0 0 507px;*/
                        background-color: #96dafb;}")),
  daterangepicker(
    inputId = "daterange",
    label = "Pick a Date",
    start = start, end = end,
    max = end,
    language = "en",
    style = "width:100%; border-radius:4px",
    class = "myclass",
    icon = icon("calendar")
  ),
  verbatimTextOutput("print"),
  actionButton("act", "Update Daterangepicker"),
  actionButton("act1", "Update Daterangepicker1")
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
                            opens = "left",
                            showCustomRangeLabel = TRUE,
                            alwaysShowCalendars = FALSE
                          ))
  })
  observeEvent(input$act1, {
    updateDaterangepicker(session, "daterange",
                          start = Sys.Date(),
                          end = Sys.Date() - 100)
  })
}

shinyApp(ui, server)
