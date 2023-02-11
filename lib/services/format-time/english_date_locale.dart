class EnglishDateLocale implements DateLocale {
  const EnglishDateLocale();

  @override
  final List<String> monthsShort = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  @override
  final List<String> monthsLong = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  final List<String> daysShort = const [
    'Mon',
    'Tue',
    'Wed',
    'Thur',
    'Fri',
    'Sat',
    'Sun'
  ];
  @override
  final List<String> daysLong = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  String get am => "AM";

  @override
  String get pm => "PM";
}

abstract class DateLocale {
  List<String> get monthsShort;

  List<String> get monthsLong;

  List<String> get daysShort;

  List<String> get daysLong;

  String get am;

  String get pm;
}
