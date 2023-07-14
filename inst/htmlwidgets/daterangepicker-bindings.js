var DateRangePickerBinding = new Shiny.InputBinding();
$.extend(DateRangePickerBinding, {
  find: function(scope) {
    return $(scope).find(".daterangepickerclass");
  },
  initialize: function initialize(el) {
    // Parse options
    var options = JSON.parse(el.attributes.options.value);

    // Change Moment Locale globally
    if (options.language !== undefined && options.language !== null) {
      moment.locale(options.language);
    }

    // Adapt Ranges, so moment.js can read the Dates
    // Also, use rangeNames as keys
    var ranges = {}
    if (options.ranges !== undefined && options.ranges !== null &&
        options.rangeNames !== undefined && options.rangeNames !== null) {
      for (var i in options.ranges) {
        if (typeof options.ranges[i] === "string") {
          ranges[options.rangeNames[i]] = [moment(options.ranges[i]), moment(options.ranges[i])];
        } else {
          ranges[options.rangeNames[i]] = [moment(options.ranges[i][0]), moment(options.ranges[i][1])];
        }
      }
    }

    // Initialize daterangepicker
    $(el).daterangepicker({
      parentEl: options.parentEl ? options.parentEl : 'body',
      startDate: options.start ? moment(options.start) : false,
      endDate: options.end ? moment(options.end) : false,
      minDate: options.minDate ? moment(options.minDate) : false,
      maxDate: options.maxDate ? moment(options.maxDate) : false,
      maxSpan: options.maxSpan ? options.maxSpan : false,
      autoApply: options.autoApply !== undefined ? options.autoApply : false,
      singleDatePicker: options.singleDatePicker !== undefined ? options.singleDatePicker : false,
      showDropdowns: options.showDropdowns !== undefined ? options.showDropdowns : false,
      minYear: options.minYear ? options.minYear : moment().subtract(100, 'year').format('YYYY'),
      maxYear: options.maxYear ? options.maxYear : moment().add(100, 'year').format('YYYY'),

      showWeekNumbers: options.showWeekNumbers !== undefined ? options.showWeekNumbers : false,
      showISOWeekNumbers: options.showISOWeekNumbers !== undefined ? options.showISOWeekNumbers : false,
      showCustomRangeLabel: options.showCustomRangeLabel !== undefined ? options.showCustomRangeLabel : true,

      timePicker: options.timePicker !== undefined ? options.timePicker : false,
      timePicker24Hour: options.timePicker24Hour !== undefined ? options.timePicker24Hour : false,
      timePickerIncrement:  options.timePickerIncrement ? options.timePickerIncrement : 1,
      timePickerSeconds: options.timePickerSeconds !== undefined ? options.timePickerSeconds : false,

      linkedCalendars: options.linkedCalendars !== undefined ? options.linkedCalendars : true,
      autoUpdateInput: options.autoUpdateInput !== undefined ? options.autoUpdateInput : false,
      alwaysShowCalendars: options.alwaysShowCalendars !== undefined ? options.alwaysShowCalendars : false,
      ranges: options.ranges ? ranges : undefined,
      opens:  options.opens ? options.opens : "right",
      drops:  options.drops ? options.drops : "down",

      buttonClasses: options.buttonClasses ? options.buttonClasses : 'btn btn-sm',
      applyButtonClasses: options.applyButtonClasses ? options.applyButtonClasses : 'btn-primary',
      cancelButtonClasses: options.cancelButtonClasses ? options.cancelButtonClasses : 'btn-default',

      locale: options.locale ? options.locale : {format: 'Y-MM-DD'},
      isInvalidDate: options.isInvalidDate ? options.isInvalidDate : undefined,
      isCustomDate: options.isCustomDate ? options.isCustomDate : undefined,
    });
  },
  getValue: function(el) {
    var res, start, end;

    if ($(el).val() === '') {
      return(null);
    }

    // Get start/end time
    start = $(el).data("daterangepicker").startDate;
    end = $(el).data("daterangepicker").endDate;

    // If timePicker is true, we return a POSIX otherwise a Date
    if ($(el).data("daterangepicker").timePicker === true) {
      // Make a Timestamp
      res = {
        format: "POSIX",
        start: start.unix(),
        end: end.unix()
      };
    } else {
      // Make a Date
      res = {
        format: "DATE",
        start: start.format('YYYY-MM-DD'),
        end: end.format('YYYY-MM-DD')
      };
    }

    return res;
  },
  getType: function(el) {
    return "DateRangePickerBinding";
  },
  subscribe: function(el, callback) {
    $(el).on("show.daterangepicker", function(event) {
      callback();
    });
    $(el).on("hide.daterangepicker", function(event) {
      callback();
    });
    $(el).on("apply.daterangepicker", function(event) {
      callback();
    });
    $(el).on("cancel.daterangepicker", function(event) {
      var opt = JSON.parse(this.attributes.options.nodeValue);
      if (opt.cancelIsClear !== undefined && opt.cancelIsClear) {
        $(this).val('');
      } else {
        callback();
      }
    });
    $(el).on("change.daterangepicker", function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".DateRangePickerBinding");
  },
  receiveMessage: function(el, data) {
    // Get daterangepicker Data
    var pickerdata = $("#"+data.id).data('daterangepicker');

    // Update Start
    if (data.hasOwnProperty("start")) {
      pickerdata.setStartDate(moment(data.start));
    }
    // Update End
    if (data.hasOwnProperty("end")) {
      pickerdata.setEndDate(moment(data.end));
    }
    // Update Icon
    if (data.hasOwnProperty("icon")) {
      var ico = $(el).parent().find("i")[0];
      if (ico !== undefined) {
        // If there is an icon already, change the class
        ico.className = data.icon.attribs.class;
      } else {
        // If no icon was given, add it to the DOM. (Add the dependencie, if not loaded initially)
        Shiny.renderDependencies(data.icon.htmldeps);
        $(el).before(' <i class="'+data.icon.attribs.class+'"></i>');
      }
    }
    // Update Label
    if (data.hasOwnProperty("label")) {
      var lbl = $(el).parent().find('label[for="' + data.id + '"]');
      // Is a label already there? If yes, update it, otherwise create it
      if (lbl.length !== 0) {
        lbl.text(data.label);
      } else {
        $(el).before('<label class="control-label" for="'+el.id+'">'+data.label+'</label>');
      }
    }
    // Update minDate
    if (data.hasOwnProperty("minDate")) {
      pickerdata.minDate = moment(data.minDate);
    }
    // Update maxDate
    if (data.hasOwnProperty("maxDate")) {
      pickerdata.maxDate = moment(data.maxDate);
    }

    // Update style
    if (data.hasOwnProperty("style")) {
      $("#"+data.id).attr("style", data.style);
    }
    // Update ranges
    if (data.hasOwnProperty("ranges") && data.hasOwnProperty("rangeNames")) {
      var ranges = {}
      if (data.ranges !== undefined && data.ranges !== null &&
          data.rangeNames !== undefined && data.rangeNames !== null) {
        for (var i in data.ranges) {
          if (typeof data.ranges[i] === "string") {
            ranges[data.rangeNames[i]] = [moment(data.ranges[i]), moment(data.ranges[i])];
          } else {
            ranges[data.rangeNames[i]] = [moment(data.ranges[i][0]), moment(data.ranges[i][1])];
          }
        }
      }
      var pickerRanges = {}
      for (range in ranges) {
        start = ranges[range][0];
        end = ranges[range][1];

        // If the start or end date exceed those allowed by the minDate or maxSpan
        // options, shorten the range to the allowable period.
        if (pickerdata.minDate && start.isBefore(pickerdata.minDate))
          start = pickerdata.minDate.clone();

        var maxDate = pickerdata.maxDate;
        if (pickerdata.maxSpan && maxDate && start.clone().add(pickerdata.maxSpan).isAfter(maxDate))
          maxDate = start.clone().add(pickerdata.maxSpan);
        if (maxDate && end.isAfter(maxDate))
          end = maxDate.clone();

        // If the end of the range is before the minimum or the start of the range is
        // after the maximum, don't display pickerdata range option at all.
        if ((pickerdata.minDate && end.isBefore(pickerdata.minDate, pickerdata.timepicker ? 'minute' : 'day'))
            || (maxDate && start.isAfter(maxDate, pickerdata.timepicker ? 'minute' : 'day'))) {
          continue;
        }

        //Support unicode chars in the range names.
        var elem = document.createElement('textarea');
        elem.innerHTML = range;
        var rangeHtml = elem.value;
        pickerRanges[rangeHtml] = [start, end];
      }
      pickerdata.ranges = pickerRanges
      var list = '<ul>';
      for (range in pickerdata.ranges) {
          list += '<li data-range-key="' + range + '">' + range + '</li>';
      }
      if (pickerdata.showCustomRangeLabel) {
          list += '<li data-range-key="' + pickerdata.locale.customRangeLabel + '">' + pickerdata.locale.customRangeLabel + '</li>';
      }
      list += '</ul>';
      pickerdata.container.find('.ranges ul').remove()
      pickerdata.container.find('.ranges').prepend(list);
    }
    // Update class
    if (data.hasOwnProperty("class")) {
      $("#"+data.id).addClass(data.class);
    }
    /*
    // Update language - Not working - locale is set globally for moment.js
    if (data.hasOwnProperty("language")) {
      moment.locale(data.language);
    }
    */

    // Update options
    if (data.hasOwnProperty("options")) {
      // Update minYear
      if (data.options.hasOwnProperty("minYear")) {
        pickerdata.minYear = data.options.minYear;
      }
      // Update maxYear
      if (data.options.hasOwnProperty("maxYear")) {
        pickerdata.maxYear = data.options.maxYear;
      }
      // Update showDropdowns
      if (data.options.hasOwnProperty("showDropdowns")) {
        pickerdata.showDropdowns = data.options.showDropdowns;
      }
      // Update showCustomRangeLabel
      if (data.options.hasOwnProperty("showCustomRangeLabel")) {
        pickerdata.showCustomRangeLabel = data.options.showCustomRangeLabel;
      }
      // Update opens
      if (data.options.hasOwnProperty("opens")) {
        pickerdata.opens = data.options.opens;
      }
      // Update drops
      if (data.options.hasOwnProperty("drops")) {
        pickerdata.drops = data.options.drops;
      }
      // Update timePicker
      if (data.options.hasOwnProperty("timePicker")) {
        pickerdata.timePicker = data.options.timePicker;
      }
      // Update timePickerIncrement
      if (data.options.hasOwnProperty("timePickerIncrement")) {
        pickerdata.timePickerIncrement = data.options.timePickerIncrement;
      }
      // Update timePicker24Hour
      if (data.options.hasOwnProperty("timePicker24Hour")) {
        pickerdata.timePicker24Hour = data.options.timePicker24Hour;
      }
      // Update timePickerSeconds
      if (data.options.hasOwnProperty("timePickerSeconds")) {
        pickerdata.timePickerSeconds = data.options.timePickerSeconds;
      }
      // Update showWeekNumbers
      if (data.options.hasOwnProperty("showWeekNumbers")) {
        pickerdata.showWeekNumbers = data.options.showWeekNumbers;
      }
      // Update showISOWeekNumbers
      if (data.options.hasOwnProperty("showISOWeekNumbers")) {
        pickerdata.showISOWeekNumbers = data.options.showISOWeekNumbers;
      }
      // Update parentEl
      if (data.options.hasOwnProperty("parentEl")) {
        pickerdata.parentEl = data.options.parentEl;
      }
      // Update maxSpan
      if (data.options.hasOwnProperty("maxSpan")) {
        pickerdata.maxSpan = data.options.maxSpan;
      }
      // Update alwaysShowCalendars
      if (data.options.hasOwnProperty("alwaysShowCalendars")) {
        pickerdata.alwaysShowCalendars = data.options.alwaysShowCalendars;
      }
      // Update buttonClasses
      if (data.options.hasOwnProperty("buttonClasses")) {
        pickerdata.buttonClasses = data.options.buttonClasses;
      }
      // Update applyButtonClasses
      if (data.options.hasOwnProperty("applyButtonClasses")) {
        pickerdata.applyButtonClasses = data.options.applyButtonClasses;
      }
      // Update cancelButtonClasses
      if (data.options.hasOwnProperty("cancelButtonClasses")) {
        pickerdata.cancelButtonClasses = data.options.cancelButtonClasses;
      }
      // Update autoUpdateInput
      if (data.options.hasOwnProperty("autoUpdateInput")) {
        pickerdata.autoUpdateInput = data.options.autoUpdateInput;
      }
      // Update autoApply
      if (data.options.hasOwnProperty("autoApply")) {
        pickerdata.autoApply = data.options.autoApply;
      }
      // Update linkedCalendars
      if (data.options.hasOwnProperty("linkedCalendars")) {
        pickerdata.linkedCalendars = data.options.linkedCalendars;
      }

      //$(el).trigger("apply");
      //$(el).trigger("change");
    }
  }
});
Shiny.inputBindings.register(DateRangePickerBinding);

