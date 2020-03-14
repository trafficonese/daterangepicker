#' daterangepicker
#'
#' Date Range Picker pop up two calendars for selecting dates, times, or
#' predefined ranges like "Last 30 Days".
#'
#' @importFrom htmltools htmlDependencies<- htmlDependencies htmlDependency tags
#'   tagList
#' @importFrom jsonify to_json
#'
#' @param inputId The input ID
#' @param label The label for the control, or NULL for no label.
#' @param start The beginning date of the initially selected. Must be a Date or
#'   string.
#' @param end The end date of the initially selected date range. Must be a Date
#'   or string
#' @param min The earliest date a user may select. Must be a Date or string
#' @param max The latest date a user may select. Must be a Date or string
#' @param ranges Set predefined date ranges the user can select from. Each key
#'   is the label for the range, and its value an array with two dates
#'   representing the bounds of the range.
#' @param language The language used for month and day names. Default is "en".
#'   See the \href{https://momentjs.com/}{Multipe Locale Support} for a list of
#'   other valid values.
#' @param style Add CSS-styles to the input.
#' @param class Custom class
#' @param icon Icon to display next to the label.
#' @param options List of further options. See
#'   \code{\link{daterangepickerOptions}}
#' @param initCallback A \code{\link[htmlwidgets]{JS}} function
#'
#' @seealso
#' \href{https://www.daterangepicker.com/#config}{www.daterangepicker.com}
#'
#' @export
#' @examples if (interactive()) {
#' library(shiny)
#' library(daterangepicker)
#'
#' ## UI ##########################
#' ui <- fluidPage(
#'   tags$head(tags$style(".myclass {background-color: #96dafb;}")),
#'   daterangepicker(
#'     inputId = "daterange",
#'     label = "Pick a Date",
#'     start = Sys.Date() - 30, end = Sys.Date(),
#'     max = Sys.Date(),
#'     language = "en",
#'     style = "width:100%; border-radius:4px",
#'     class = "myclass",
#'     icon = icon("calendar")
#'   ),
#'   verbatimTextOutput("print"),
#'   actionButton("act", "Update Daterangepicker"),
#' )
#'
#' ## SERVER ##########################
#' server <- function(input, output, session) {
#'   output$print <- renderPrint({
#'     req(input$daterange)
#'     input$daterange
#'   })
#'   observeEvent(input$act, {
#'     updateDaterangepicker(session, "daterange",
#'                           start = Sys.Date(),
#'                           end = Sys.Date() - 100)
#'   })
#' }
#' shinyApp(ui, server)
#' }
daterangepicker <- function(inputId = NULL,
                            label = "Select a Date",
                            start = NULL, end = NULL,
                            min = NULL, max = NULL,
                            ranges = NULL,
                            language = "en",
                            style = "width:100%;border-radius:4px;text-align:center;",
                            class = NULL,
                            icon = NULL,
                            options = daterangepickerOptions(),
                            initCallback = NULL
                            ) {

  ## Check Inputs #######################
  if (is.null(inputId)) stop("Daterangepicker needs an `inputId`")
  if (is.null(start)) stop("Daterangepicker needs a `start`-Date")
  if (is.null(end)) stop("Daterangepicker needs an `end`-Date")
  if (!is.null(min)) min <- format(as.Date(min), "%Y/%m/%d")
  if (!is.null(max)) max <- format(as.Date(max), "%Y/%m/%d")
  if (!is.null(ranges)) ranges <- checkRanges(ranges)
  #######################

  ## Fill + Filter options #######################
  options <- filterEMPTY(c(
    list(
    start = as.character(as.Date(start)),
    end = as.character(as.Date(end)),
    minDate = min, maxDate = max,
    ranges = ranges,
    language = language,
    initCallback = initCallback
  ), options))
  #######################

  ## Adapt time format, if not given in options$locale List ################
  # if (is.null(options$locale)) {
  #   format <- ifelse(nchar(end) > 10 &&
  #                    nchar(start) > 10, "DD-MM-Y HH:MM:SS", "DD-MM-Y")
  #   options$locale <- list("format" = format)
  # }


  ## Make Input Tag #######################
  x <- makeInput(label, inputId, class, icon, style, options)
  #######################

  ## Attach dependencies and output ###################
  htmlDependencies(x) <- htmlDependency(
    name = "daterangepicker",
    version = "1.0.0",
    src = system.file("htmlwidgets", package = "daterangepicker"),
    script = c(
      # "moment.min.js",
      "moment.locales.min.js",
      "daterangepicker.min.js",
      "daterangepicker-bindings.js"
    ),
    stylesheet = "daterangepicker.css"
  )
  #######################
  x
}


#' daterangepickerOptions
#'
#' Update the daterangepicker
#'
#' @param minYear The minimum year as numeric shown in the dropdowns when
#'   showDropdowns is set to \code{TRUE}
#' @param maxYear The maximum year as numeric shown in the dropdowns when
#'   showDropdowns is set to \code{TRUE}
#' @param maxSpan The maximum span between the selected start and end dates as
#'   List or table. You can provide any object the moment library would let you
#'   add to a date.
#' @param showDropdowns Show year and month select boxes above calendars to jump
#'   to a specific month and year.
#' @param showWeekNumbers Show localized week numbers at the start of each week
#'   on the calendars.
#' @param showISOWeekNumbers Show ISO week numbers at the start of each week on
#'   the calendars.
#' @param timePicker Adds select boxes to choose times in addition to dates.
#' @param timePickerIncrement Increment of the minutes selection list for times
#'   (i.e. 30 to allow only selection of times ending in 0 or 30).
#' @param timePicker24Hour Use 24-hour instead of 12-hour times, removing the
#'   AM/PM selection.
#' @param timePickerSeconds Show seconds in the timePicker.
#' @param showCustomRangeLabel Displays "Custom Range" at the end of the list of
#'   predefined ranges, when the ranges option is used. This option will be
#'   highlighted whenever the current date range selection does not match one of
#'   the predefined ranges. Clicking it will display the calendars to select a
#'   new range.
#' @param alwaysShowCalendars Normally, if you use the ranges option to specify
#'   pre-defined date ranges, calendars for choosing a custom date range are not
#'   shown until the user clicks "Custom Range". When this option is set to
#'   \code{TRUE}, the calendars for choosing a custom date range are always
#'   shown instead.
#' @param opens Whether the picker appears aligned to the \code{left}, to the
#'   \code{right}, or to the \code{center} under the HTML element it's attached
#'   to.
#' @param drops Whether the picker appears below (\code{down}) or
#'   above (\code{up}) the HTML element it's attached to. Default is \code{down}
#' @param buttonClasses CSS class names that will be added to both the
#'   apply and cancel buttons.
#' @param applyButtonClasses CSS class names that will be added only to
#'   the apply button.
#' @param cancelButtonClasses CSS class names that will be added only
#'   to the cancel button.
#' @param locale Allows you to provide localized strings for buttons and
#'   labels, customize the date format, and change the first day of week for the
#'   calendars.
#' @param singleDatePicker Show only a single calendar to choose one
#'   date, instead of a range picker with two calendars. The start and end dates
#'   provided to your callback will be the same single date chosen.
#' @param autoApply Hide the apply and cancel buttons, and
#'   automatically apply a new date range as soon as two dates are clicked.
#' @param linkedCalendars When enabled, the two calendars displayed
#'   will always be for two sequential months (i.e. January and February), and
#'   both will be advanced when clicking the left or right arrows above the
#'   calendars. When disabled, the two calendars can be individually advanced
#'   and display any month/year.
#' @param isInvalidDate A JS-function that is passed each date in the
#'   two calendars before they are displayed, and may return true or false to
#'   indicate whether that date should be available for selection or not.
#' @param isCustomDate A JS-function that is passed each date in the
#'   two calendars before they are displayed, and may return a string or array
#'   of CSS class names to apply to that date's calendar cell.
#' @param autoUpdateInput Indicates whether the date range picker
#'   should automatically update the value of the <input> element it's attached
#'   to at initialization and when the selected dates change.
#' @param parentEl jQuery selector of the parent element that the date
#'   range picker will be added to, if not provided this will be 'body'
#'
#' @seealso
#' \href{https://www.daterangepicker.com/#config}{www.daterangepicker.com}
#'
#' @export
daterangepickerOptions <- function(minYear = NULL, maxYear = NULL,
                                   showDropdowns = TRUE,
                                   showCustomRangeLabel = TRUE,
                                   opens = c("right", "left", "center"),
                                   drops = c("down", "up"),
                                   timePicker = FALSE,
                                   timePickerIncrement = 1,
                                   timePicker24Hour = FALSE,
                                   timePickerSeconds = FALSE,
                                   showWeekNumbers = FALSE,
                                   showISOWeekNumbers = FALSE,
                                   parentEl = NULL,
                                   maxSpan = NULL,
                                   alwaysShowCalendars = FALSE,
                                   buttonClasses = NULL,
                                   applyButtonClasses = NULL,
                                   cancelButtonClasses = NULL,
                                   locale = NULL,
                                   singleDatePicker = FALSE,
                                   autoApply = FALSE,
                                   linkedCalendars = TRUE,
                                   isInvalidDate = NULL, ## JS
                                   isCustomDate = NULL, ## JS
                                   autoUpdateInput = TRUE) {

  ## Check Inputs ###################
  if (!is.null(maxSpan)) {
    if (!is.list(maxSpan) && length(maxSpan) == 1)
      stop("`maxSpan` must be a named list with a numeric value.")
    choicesmaxspan <- c("milliseconds","seconds","minutes",
                        "days","months","years")
    if (!names(maxSpan) %in% choicesmaxspan)
      stop("The valid names for `maxSpan` are:\n",
           paste(choicesmaxspan, collapse = ", "))
  }
  opens <- match.arg(opens)[1]
  drops <- match.arg(drops)[1]

  ## Filter and create options-List #########################
  filterEMPTY(list(
    minYear = minYear, maxYear = maxYear,
    maxSpan = maxSpan,
    showDropdowns = showDropdowns,
    showWeekNumbers = showWeekNumbers,
    showISOWeekNumbers = showISOWeekNumbers,
    timePicker = timePicker,
    timePickerIncrement = timePickerIncrement,
    timePicker24Hour = timePicker24Hour,
    timePickerSeconds = timePickerSeconds,
    showCustomRangeLabel = showCustomRangeLabel,
    alwaysShowCalendars = alwaysShowCalendars,
    opens = opens,
    drops = drops,
    buttonClasses = buttonClasses,
    applyButtonClasses = applyButtonClasses,
    cancelButtonClasses = cancelButtonClasses,
    locale = locale,
    singleDatePicker = singleDatePicker,
    autoApply = autoApply,
    linkedCalendars = linkedCalendars,
    isInvalidDate = isInvalidDate, ## JS
    isCustomDate = isCustomDate, ## JS
    autoUpdateInput = autoUpdateInput,
    parentEl = parentEl
  ))
}

#' updateDaterangepicker
#'
#' Change the start and end values of a daterangepicker on the client
#'
#' @param session The session object passed to function given to shinyServer.
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param start The start date. Either a Date object, or a string in yyyy-mm-dd
#'   format.
#' @param end The end date. Either a Date object, or a string in yyyy-mm-dd
#'   format.
#' @param min The earliest date a user may select.
#' @param max The latest date a user may select.
#' @param icon Icon to display next to the label.
#' @param options List of further options. See
#'   \code{\link{daterangepickerOptions}}
#' @export
updateDaterangepicker <- function(session, inputId, label = NULL,
                                  start = NULL, end = NULL,
                                  min = NULL, max = NULL,
                                  icon = NULL, options = NULL) {

  # if (!is.null(icon)) icon$htmldeps <- htmltools::htmlDependencies(icon)

  message <- filterEMPTY(list(
    id = session$ns(inputId),
    label = label,
    start = start,
    end = end,
    minDate = min,
    maxDate = max,
    icon = icon,
    options = options
  ))

  session$sendInputMessage(inputId, message)
}



