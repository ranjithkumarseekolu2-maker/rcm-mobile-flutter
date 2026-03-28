
import 'package:intl/intl.dart';

class DateTimeUtils {
  static formatDate(date) {
    print('date brfore formating $date');
    if (date != null && date != '') {
      return DateFormat('MM/dd/yyyy').format(DateTime.parse(date).toLocal());
    } else {
      return '';
    }
  }

    static formatMeetingDate(date) {
    print('date brfore formating $date');
    if (date != null && date != '') {
      return DateFormat('EEE, dd MMM').format(DateTime.parse(date));
    } else {              
      return '';
    }
  }

  static formatMeetingTime(date) {
    print('date brfore formating $date');
    if (date != null && date != '') {
      return DateFormat('HH:mm a').format(DateTime.parse(date));
    } else {              
      return '';
    }
  }

 

  static formatDateAndTime(date) {
    //dd-MMM-yyyy  H : m : s
    print('date time brfore formating $date');
    if (date != null && date != '') {
      return DateFormat('dd-MMM-yyyy').format(DateTime.parse(date).toLocal());
    } else {
      return '';
    }
  }

  static convertTimeStampToDate(timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toString();
    print('date: $date');
    if (date != null && date != '') {
      return DateFormat('dd-MMM-yyyy').format(DateTime.parse(date));
    } else {
      return '';
    }
  }

  //Get Human readble date format 12 hours and 24 hours from seconds
  static convertSecondsToDate(seconds, hours) {
    var millis = seconds * 1000;
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);
    var date;
    // for 12 hours format
    if (hours == 12) {
      // 12 Hour format:
      date =
          DateFormat('dd-MM-yyyy, hh:mm a').format(dt); // 12/31/2000, 10:00 PM
    } else if (hours == 24) {
      // 24 Hour format:
      date = DateFormat('dd-MM-yyyy, HH:mm').format(dt); // 31/12/2000, 22:00
    }
    return date;
  }

  static convertSecondsToDateOtherFormat(seconds, hours) {
    var millis = seconds * 1000;
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);
    var date;
    // for 12 hours format
    if (hours == 12) {
      // 12 Hour format:
      date = DateFormat('yyyy-MM-dd hh:mm:ss a')
          .format(dt); // 12/31/2000, 10:00 PM
    } else if (hours == 24) {
      // 24 Hour format:
      date = DateFormat('yyyy-MM-dd hh:mm:ss').format(dt); // 31/12/2000, 22:00
    }
    return date;
  }
}
