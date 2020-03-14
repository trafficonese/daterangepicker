var DateRangePickerBinding = new Shiny.InputBinding();
$.extend(DateRangePickerBinding, {
  find: function(scope) {
    return $(scope).find(".daterangepickerclass");
  },
  initialize: function initialize(el) {
    // Parse options
    var options = JSON.parse(el.attributes.options.value);

    // Initiliaze a callback function
    var cb;
    if (options.initCallback !== undefined && typeof options.initCallback === "string") {
      cb = new Function('return ' + options.initCallback)();
    }

    // Change Moment Locale globally
    if (options.language !== undefined && options.language !== null) {
      moment.locale(options.language);
    }

    // Adapt Ranges, so moment.js can read the Dates
    if (options.ranges !== undefined || options.ranges !== null) {
      for (var key in options.ranges) {
    		if (typeof options.ranges[key] === "string") {
    		  options.ranges[key] = [moment(options.ranges[key]), moment(options.ranges[key])];
    		} else {
    		  for (var i in [0,1]) {
    		    options.ranges[key].push(moment(options.ranges[key][0]));
    		    options.ranges[key].shift();
    		  }
    		}
      }
    }

    // Initialize daterangepicker
    $(el).daterangepicker({
      parentEl: options.parentEl ? options.parentEl : 'body',
      startDate: moment(options.start),
      endDate: moment(options.end),
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
      autoUpdateInput: options.autoUpdateInput ? options.autoUpdateInput : true,
      alwaysShowCalendars: options.alwaysShowCalendars !== undefined ? options.alwaysShowCalendars : false,
      ranges: options.ranges ? options.ranges : undefined,
      opens:  options.opens ? options.opens : "right",
      drops:  options.drops ? options.drops : "down",

      buttonClasses: options.buttonClasses ? options.buttonClasses : 'btn btn-sm',
      applyButtonClasses: options.applyButtonClasses ? options.applyButtonClasses : 'btn-primary',
      cancelButtonClasses: options.cancelButtonClasses ? options.cancelButtonClasses : 'btn-default',

      locale: options.locale ? options.locale : {format: 'Y-MM-DD'},
      isInvalidDate: options.isInvalidDate ? options.isInvalidDate : undefined,
      isCustomDate: options.isCustomDate ? options.isCustomDate : undefined,
    }, cb);
  },
  getValue: function(el) {
    var res, start, end;
    // Get start/end time
    start = $(el).data("daterangepicker").startDate;
    end = $(el).data("daterangepicker").endDate;
    // If timePicker is true, we return a POSIX otherwise a Date
    if ($(el).data("daterangepicker").timePicker === true) {
      // Make a Timestamp
      res = {
        format: "POSIX",
        //start: start.format('YYYY-MM-DD HH:MM:SS'),
        //end: end.format('YYYY-MM-DD HH:MM:SS')
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
  setValue: function(el, value) {
    console.log("setValue");console.log(el);console.log(value);debugger;
    //value = JSON.parse(value);
  },
  subscribe: function(el, callback) {
    $(el).on("show.DateRangePickerBinding", function(event) {
      //console.log("subscribe - show");
      callback();
    });
    $(el).on("hide.DateRangePickerBinding", function(event) {
      //console.log("subscribe - hide");
      callback();
    });
    $(el).on("showCalendar.DateRangePickerBinding", function(event) {
      //console.log("subscribe - showCalendar");
      callback();
    });
    $(el).on("hideCalendar.DateRangePickerBinding", function(event) {
      //console.log("subscribe - hideCalendar");
      callback();
    });
    $(el).on("apply.DateRangePickerBinding", function(event) {
      //console.log("subscribe - apply");
      callback();
    });
    $(el).on("cancel.DateRangePickerBinding", function(event) {
      //console.log("subscribe - cancel");
      callback();
    });
    $(el).on("change.DateRangePickerBinding", function(event) {
      //console.log("subscribe - change");
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

      $(el).trigger("apply");
      $(el).trigger("change");
    }
  }
});
Shiny.inputBindings.register(DateRangePickerBinding);

