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
    icon = icon("calendar"),
    start = start, end = end,
    language = "de",
    minYear = 1990, maxYear = 2020,
    maxDate = as.character(Sys.Date()),
    # parentEl = ".add_date_here", ### Not working ???
    opens = "left",
    drops = "down",
    class = "myclass",
    showDropdowns = T,
    ranges = list("Gestern" = Sys.Date() - 1,
                 "Heute" = Sys.Date(),
                 "Letzten 3 Tage" = c(Sys.Date() - 2, Sys.Date()),
                 "Letzten 7 Tage" = c(Sys.Date() - 6, Sys.Date()),
                 "Letzten 45 Tage" = c(Sys.Date() - 44, Sys.Date())
                 ),
    maxSpan = list("years" = 1),
    autoUpdateInput = TRUE,
    linkedCalendars = FALSE,
    timePicker = TRUE,
    timePickerIncrement = 0,
    timePicker24Hour = TRUE,
    timePickerSeconds = TRUE,
    showWeekNumbers = TRUE,
    showISOWeekNumbers = TRUE,
    singleDatePicker = FALSE,
    locale = list(
        direction = 'ltr',  ## or rtl
        separator = ' <-> ',
        # format = 'DD-MM-Y HH:MM:SS',
        format = 'LL',
        applyLabel = 'Bestätigen',
        cancelLabel = 'Abbrechen',
        customRangeLabel = 'Freier Zeitraum',
        weekLabel = 'W',
        firstDay = 1,
        daysOfWeek = format(seq.Date(as.Date("2000-01-03"),
                                     as.Date("2000-01-09"),
                                     by = "days"), "%a"),
        monthNames = format(seq.Date(as.Date("2000-01-01"),
                                     as.Date("2000-12-31"),
                                     by = "months"), "%b")
    ),
    alwaysShowCalendars = TRUE,
    showCustomRangeLabel = FALSE,
    cancelButtonClasses = "btn-danger"
  ),
  verbatimTextOutput("print"),
  br(),br(),  br(),br(),
  div(id = "add_date_here", class = "add_date_here",
      "Does the Datepicker come here?",
      span()),
  actionButton("act", "Update Daterangepicker")
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
                          minYear = 2019, maxYear = 2022,
                          icon = icon("car"))
  })
}

print(paste("Start is:", start));
print(paste("End is:", end))
print(paste("Start is:", as.POSIXct(start)));
print(paste("End is:", as.POSIXct(end)))

shinyApp(ui, server)
