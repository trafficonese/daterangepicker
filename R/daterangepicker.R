#' daterangepicker
#'
#' The Date Range Picker pops up two calendars for selecting dates, times, or
#' predefined ranges like "Yesterday", "Last 30 Days", etc.
#'
#' @importFrom shiny restoreInput
#' @importFrom htmltools htmlDependencies<- htmlDependencies htmlDependency tags
#'   tagList
#' @importFrom jsonify to_json
#' @importFrom utils packageVersion
#'
#' @param inputId The input ID
#' @param label The label for the control, or NULL for no label.
#' @param start The beginning date of the initially selected. Must be a Date /
#'   POSIXt or string. If NULL will default to the current day.
#' @param end The end date of the initially selected date range. Must be a Date
#'   / POSIXt or string. If NULL will default to the current day.
#' @param min The earliest date a user may select. Must be a Date or string
#' @param max The latest date a user may select. Must be a Date or string
#' @param ranges Set predefined date ranges the user can select from. Each key
#'   is the label for the range, and its value an array with two dates
#'   representing the bounds of the range.
#'   Alternatively, the labels can be specified via `rangeNames`. If that
#'   argument is used, `ranges` should not be named and `rangeNames` will
#'   take precedence.
#' @param rangeNames Optional character vector specifying the labels for
#'   predefined date ranges. If specified, it will override the names
#'   of `ranges`.
#' @param language The language used for month and day names. Default is "en".
#'   See the \href{https://momentjs.com/}{Multiple Locale Support} for a list of
#'   other valid values.
#' @param style Add CSS-styles to the input.
#' @param class Custom class
#' @param icon Icon to display next to the label.
#' @param options List of further options. See
#'   \code{\link{daterangepickerOptions}}
#'
#' @seealso
#' \href{https://www.daterangepicker.com/#config}{www.daterangepicker.com}
#'
#' @export
#' @family daterangepicker Functions
#' @examples if (interactive()) {
#'   library(shiny)
#'   library(daterangepicker)
#'   ## UI ##########################
#'   ui <- fluidPage(
#'     tags$head(tags$style(".myclass {background-color: #96dafb;}")),
#'     daterangepicker(
#'       inputId = "daterange",
#'       label = "Pick a Date",
#'       start = Sys.Date() - 30, end = Sys.Date(),
#'       max = Sys.Date(),
#'       language = "en",
#'       ranges = list(
#'         "Today" = Sys.Date(),
#'         "Yesterday" = Sys.Date() - 1,
#'         "Last 3 days" = c(Sys.Date() - 2, Sys.Date()),
#'         "Last 7 days" = c(Sys.Date() - 6, Sys.Date())
#'       ),
#'       style = "width:100%; border-radius:4px",
#'       class = "myclass",
#'       icon = icon("calendar")
#'     ),
#'     verbatimTextOutput("print"),
#'     actionButton("act", "Update Daterangepicker"),
#'   )
#'   ## SERVER ##########################
#'   server <- function(input, output, session) {
#'     output$print <- renderPrint({
#'       req(input$daterange)
#'       input$daterange
#'     })
#'     observeEvent(input$act, {
#'       updateDaterangepicker(
#'         session, "daterange",
#'         start = Sys.Date(),
#'         end = Sys.Date() - 100,
#'         ranges = list(
#'           Sys.Date(), Sys.Date() - 1,
#'           c(Sys.Date() - 3, Sys.Date()),
#'           c(Sys.Date() - 6, Sys.Date()),
#'           Sys.Date() + 2
#'         ),
#'         rangeNames = c(
#'           "Today", "Yesterday", "Last 3 days",
#'           "Last 7 days", "The day after tomorrow \u263a"
#'         ),
#'         max = Sys.Date() + 2
#'       )
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
daterangepicker <- function(
    inputId = NULL,
    label = "Select a Date",
    start = NULL, end = NULL,
    min = NULL, max = NULL,
    ranges = NULL,
    rangeNames = names(ranges),
    language = "en",
    style = "width:100%;border-radius:4px;text-align:center;",
    class = NULL,
    icon = NULL,
    options = daterangepickerOptions()) {

  ## Check Inputs #######################
  if (is.null(inputId)) stop("Daterangepicker needs an `inputId`")
  if (!is.null(start)) start <- as.character(start)
  if (!is.null(end)) end <- as.character(end)
  if (!is.null(min)) min <- as.character(min)
  if (!is.null(max)) max <- as.character(max)
  if (!is.null(ranges)) {
    ranges <- checkRanges(ranges)
    if (!is.null(names(ranges)) && !missing(rangeNames)) {
      warning("'ranges' is named and 'rangeNames' is provided.\n",
              "Ignoring names of 'ranges'.")
    }
    rangeNames <- as.character(rangeNames)
    ranges <- unname(ranges)
    if (length(rangeNames) != length(ranges)) {
      stop("`ranges` and `rangeNames` must have the same length")
    }
  }
  #######################

  ## Enable Bookmarking / Restore #####################
  restored <- restoreInput(id = inputId, default = list(start, end))
  start <- restored[[1]]
  end <- restored[[2]]
  #######################

  ## Fill + Filter options #######################
  options <- filterEMPTY(c(
    list(
      start = start,
      end = end,
      minDate = min, maxDate = max,
      ranges = ranges, rangeNames = rangeNames,
      language = language
    ), options
  ))
  #######################

  ## Make Input Tag #######################
  x <- makeInput(label, inputId, class, icon, style, options)
  #######################

  ## Attach dependencies and output ###################
  htmlDependencies(x) <- htmlDependency(
    name = "daterangepicker",
    version = packageVersion("daterangepicker"),
    src = system.file("htmlwidgets", package = "daterangepicker"),
    script = c(
      ifelse(is.null(language), "moment/moment.min.js",
        "moment/moment.locales.min.js"
      ),
      "daterangepicker/daterangepicker.min.js",
      "daterangepicker-bindings.js"
    ),
    stylesheet = "daterangepicker/daterangepicker.min.css"
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
#' @param drops Whether the picker appears below (\code{down}) or above
#'   (\code{up}) the HTML element it's attached to. Default is \code{down}
#' @param buttonClasses CSS class names that will be added to both the apply and
#'   cancel buttons.
#' @param applyButtonClasses CSS class names that will be added only to the
#'   apply button.
#' @param cancelButtonClasses CSS class names that will be added only to the
#'   cancel button.
#' @param cancelIsClear If TRUE, will treat the Cancel Button like a Clear
#'   Button.
#' @param locale Allows you to provide localized strings for buttons and labels,
#'   customize the date format, and change the first day of week for the
#'   calendars. See the examples in `./inst/examples/`
#' @param singleDatePicker Show only a single calendar to choose one date,
#'   instead of a range picker with two calendars. The start and end dates
#'   provided to your callback will be the same single date chosen.
#' @param autoApply Hide the apply and cancel buttons, and automatically apply a
#'   new date range as soon as two dates are clicked.
#' @param linkedCalendars When enabled, the two calendars displayed will always
#'   be for two sequential months (i.e. January and February), and both will be
#'   advanced when clicking the left or right arrows above the calendars. When
#'   disabled, the two calendars can be individually advanced and display any
#'   month/year.
#' @param autoUpdateInput Indicates whether the date range picker should
#'   automatically update the value of the <input> element it's attached to at
#'   initialization and when the selected dates change.
#' @param parentEl jQuery selector of the parent element that the date range
#'   picker will be added to, if not provided this will be 'body'
#' @param ... Further arguments passed to `daterangepicker`, like
#'   \code{isInvalidDate} or \code{isCustomDate}.
#'
#' @seealso
#' \href{https://www.daterangepicker.com/#config}{www.daterangepicker.com}
#'
#' @family daterangepicker Functions
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
                                   cancelIsClear = FALSE,
                                   locale = NULL,
                                   singleDatePicker = FALSE,
                                   autoApply = FALSE,
                                   linkedCalendars = TRUE,
                                   # isInvalidDate = NULL, ## JS
                                   # isCustomDate = NULL, ## JS
                                   autoUpdateInput = TRUE,
                                   ...) {

  ## Check Inputs ###################
  if (!is.null(maxSpan)) checkMaxSpan(maxSpan)
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
    cancelIsClear = cancelIsClear,
    locale = locale,
    singleDatePicker = singleDatePicker,
    autoApply = autoApply,
    linkedCalendars = linkedCalendars,
    # isInvalidDate = isInvalidDate, ## JS
    # isCustomDate = isCustomDate, ## JS
    autoUpdateInput = autoUpdateInput,
    parentEl = parentEl,
    ...
  ))
}

# param isInvalidDate A JS-function that is passed each date in the two
#   calendars before they are displayed, and may return true or false to
#   indicate whether that date should be available for selection or not.
# param isCustomDate A JS-function that is passed each date in the two
#   calendars before they are displayed, and may return a string or array of
#   CSS class names to apply to that date's calendar cell.



#' updateDaterangepicker
#'
#' Change the start and end values of a daterangepicker on the client
#'
#' @param session The session object passed to function given to shinyServer.
#' @inheritParams daterangepicker
#' @family daterangepicker Functions
#' @export
updateDaterangepicker <- function(
    session, inputId, label = NULL,
    start = NULL, end = NULL,
    min = NULL, max = NULL,
    icon = NULL, options = NULL,
    ranges = NULL, rangeNames = NULL, style = NULL,
    class = NULL) {

  ## If no icon was passed initially, we need to create a WebDependency-list
  ## On the JS-side `Shiny.renderDependencies` adds the deps to the header
  if (!is.null(icon)) {
    icon$htmldeps <- list(shiny::createWebDependency(
      htmltools::resolveDependencies(
        htmltools::htmlDependencies(
          icon
        )
      )[[1]]
    ))
  }

  message <- filterEMPTY(list(
    id = session$ns(inputId),
    label = label,
    start = start,
    end = end,
    minDate = min,
    maxDate = max,
    icon = icon,
    options = options,
    ranges = ranges,
    rangeNames = rangeNames,
    style = style,
    class = class
  ))

  session$sendInputMessage(inputId, message)
}
