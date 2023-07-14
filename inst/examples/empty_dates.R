
library(shiny)
library(lubridate)
library(shinyjs)
library(daterangepicker)

sysdat <- Sys.Date()
end <- Sys.Date()
start <- end - 30

## UI ##########################
ui <- fluidPage(
  useShinyjs(),
  daterangepicker(inputId = "daterange", label="Daterange", language = "de",
                  class = "daterangeclass",
                  options = daterangepickerOptions(
                    autoUpdateInput = FALSE,
                    cancelIsClear = TRUE,
                    locale = list(
                      format = "YYYY-MM-DD",
                      applyLabel= "Ok",
                      cancelLabel= 'Clear'
                    )
                  )),
  tags$script("
    $('#daterange').on('apply.daterangepicker', function(ev, picker) {
        $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
    });
    $('#daterange').on('hide.daterangepicker', function(ev, picker) {
        $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
    });
  "),
  verbatimTextOutput("print"),
  actionButton("act", "Update Daterangepicker")
)

## SERVER ##########################
server <- function(input, output, session) {
  output$print <- renderPrint({
    input$daterange
  })
  observeEvent(input$act, {
    updateDaterangepicker(session, "daterange", label = "New Label",
                          start = as.Date("2023-06-01"),
                          end = as.Date("2023-06-30"),
                          icon = icon("car"),
                          options = list(
                            minYear = 2019, maxYear = 2022,
                            showDropdowns = FALSE,
                            opens = "center",
                            showCustomRangeLabel = T,
                            alwaysShowCalendars = T
                          ))
    shinyjs::delay(100,
                   shinyjs::runjs("
                      $('#daterange').click();
                      $('.daterangepicker .applyBtn').click();"
                   ))
  })
}

shinyApp(ui, server)
