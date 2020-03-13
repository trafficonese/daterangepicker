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
    label = "Wählen Sie ein Datum aus",
    start = start, end = end,
    max = as.character(Sys.Date()),
    language = "de",
    style = "width:100%; border-radius:4px",
    class = "myclass",
    icon = icon("calendar")
  ),
  verbatimTextOutput("print"),
  br(),br(),  br(),br(),
  div(id = "add_date_here", class = "add_date_here",
      "Does the Datepicker come here?",
      span()),
  actionButton("act", "Update Daterangepicker"),
  actionButton("act1", "Update Daterangepicker1")
)

## SERVER ##########################
server <- function(input, output, session) {
  observe({
    print(paste("The date is:", input$daterange))
  })
  output$print <- renderPrint({
    req(input$daterange)
    input$daterange
  })
  observeEvent(input$act, {
    end <- Sys.Date() - 30
    start <- end - 30
    updateDaterangepicker(session, "daterange", label = "new Label",
                          start = start, end = end,
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
    end <- Sys.Date() - 30
    start <- end - 30
    updateDaterangepicker(session, "daterange",
                          start = as.Date(Sys.Date()), end = as.Date(Sys.Date())-100)
  })
}

print(paste("Start is:", start));
print(paste("End is:", end))
print(paste("Start is:", as.POSIXct(start)));
print(paste("End is:", as.POSIXct(end)))

shinyApp(ui, server)
