library(shiny)
library(htmlwidgets)
library(daterangepicker)

end <- Sys.Date()
start <- end - 30

## UI ##########################
ui <- fluidPage(
  tags$head(tags$style(".myclass {
                        margin-left: 400px;
                        background-color: #96dafb;}")),
  br(), br(),
  daterangepicker(
    inputId = "daterange",
    label = "Pick a Date",
    start = start, end = end,
    max = end,
    ranges = list(Sys.Date(),
                  Sys.Date() - 1,
                  c(Sys.Date() - 2, Sys.Date()),
                  c(Sys.Date() - 6, Sys.Date()),
                  c(Sys.Date() - 44, Sys.Date())
    ),
    rangeNames = c("Today \U0001f604",
                   "Yesterday \U0001f603",
                   "Last 3 days \U0001f60a",
                   "Last 7 days \U0001f629",
                   "Last 45 days"),
    language = "en",
    style = "width:100%; border-radius:4px",
    class = "myclass",
    icon = icon("calendar"),
    options = daterangepickerOptions(
      minYear = 1990, maxYear = 2020,
      opens = "center",
      drops = "down",
      showDropdowns = TRUE,
      maxSpan = list("years" = 1),
      autoUpdateInput = TRUE,
      linkedCalendars = FALSE,
      showWeekNumbers = TRUE,
      singleDatePicker = FALSE,
      locale = list(
        direction = "ltr",  ## or rtl
        separator = " <-> ",
        format = "LL",      ## "DD-MM-Y hh:mm:ss",
        applyLabel = "Apply",
        cancelLabel = "Cancel",
        customRangeLabel = "Free Range",
        weekLabel = "W",
        firstDay = 1,
        daysOfWeek = format(seq.Date(as.Date("2000-01-03"),
                                     as.Date("2000-01-09"),
                                     by = "days"), "%a"),
        monthNames = format(seq.Date(as.Date("2000-01-01"),
                                     as.Date("2000-12-31"),
                                     by = "months"), "%b")
      ),
      alwaysShowCalendars = TRUE,
      showCustomRangeLabel = TRUE,
      cancelButtonClasses = "btn-danger"
    )
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
                          start = Sys.Date() - 60, end = Sys.Date() - 30,
                          icon = icon("car"),
                          options = list(
                            minYear = 2000, maxYear = 2025,
                            showDropdowns = FALSE,
                            opens = "left",
                            showCustomRangeLabel = FALSE,
                            alwaysShowCalendars = FALSE
                          ))
  })
  observeEvent(input$act1, {
    updateDaterangepicker(session, "daterange",
                          start = Sys.Date(),
                          end = Sys.Date() - 100,
                          max = end + (365 * 3),
                          min = end - 365,
                          label = "Another new Label",
                          icon = icon("calendar-check"),
                          options = list(
                            showDropdowns = TRUE,
                            opens = "right",
                            alwaysShowCalendars = TRUE,
                            showCustomRangeLabel = TRUE
                          )
    )
  })
}

shinyApp(ui, server)
