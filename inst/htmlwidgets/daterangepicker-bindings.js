var DateRangePickerBinding = new Shiny.InputBinding();

$.extend(DateRangePickerBinding, {
  find: function(scope) {
    console.log("find");console.log($(scope).find(".daterangepickerclass"));
    return $(scope).find(".daterangepickerclass");
  },
  initialize: function initialize(el) {
    console.log("initiliaze"); console.log(el);

    function cb(start, end) {
      console.log("cb is run.");
      console.log("start: " + start);
      console.log("end: " + end);
      $('#add_date_here span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }
    var options = JSON.parse(el.attributes.options.value);
    console.log("options"); console.log(options);
    debugger;
    if (options.language !== undefined && options.language !== undefined) {
      console.log("Language set. Change the locale of moment globally");
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

      locale: options.locale ? options.locale : {format: 'M/DD hh:mm:ss A'},
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
    console.log("subscribe");
    //console.log("el"); console.log(el)
    //console.log("callback"); console.log(callback)

    $(el).on("show.DateRangePickerBinding", function(event) {
      console.log("subscribe - show");
      callback();
    });
    $(el).on("hide.DateRangePickerBinding", function(event) {
      console.log("subscribe - hide");
      callback();
    });
    $(el).on("showCalendar.DateRangePickerBinding", function(event) {
      console.log("subscribe - showCalendar");
      callback();
    });
    $(el).on("hideCalendar.DateRangePickerBinding", function(event) {
      console.log("subscribe - hideCalendar");
      callback();
    });
    $(el).on("apply.DateRangePickerBinding", function(event) {
      console.log("subscribe - apply");
      callback();
    });
    $(el).on("cancel.DateRangePickerBinding", function(event) {
      console.log("subscribe - cancel");
      callback();
    });
    /*
    */
    $(el).on("change.DateRangePickerBinding", function(event) {
      console.log("subscribe - change");
      callback();
    });
  },
  unsubscribe: function(el) {
    console.log("unsubscribe"); console.log(el);
    $(el).off(".DateRangePickerBinding");
  },
  receiveMessage: function(el, data) {
  // Get daterangepicker Data
  var pickerdata = $("#"+data.id).data('daterangepicker');
  debugger;

  // Update Start
  if (data.hasOwnProperty("start")) {
    pickerdata.setStartDate(moment(data.start));
  }
  // Update End
  if (data.hasOwnProperty("end")) {
    pickerdata.setEndDate(moment(data.end));
  }
  // Update minYear
  if (data.hasOwnProperty("minYear")) {
    pickerdata.minYear = data.minYear;
  }
  // Update maxYear
  if (data.hasOwnProperty("maxYear")) {
    pickerdata.maxYear = data.maxYear;
  }
  // Update Icon
  if (data.hasOwnProperty("icon")) {
      $(el)
        .parent()
        .find("i")[0].className = data.icon.attribs.class;
  }
  // Update Label
  if (data.hasOwnProperty("label")) {
    $(el)
      .parent()
      .find('label[for="' + data.id + '"]')
      .text(data.label);
  }


  /*
  $(el).trigger("change");
  */
  }
});
Shiny.inputBindings.register(DateRangePickerBinding);


