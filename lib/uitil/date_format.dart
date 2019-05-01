import 'package:intl/intl.dart';

String dateformatted(){
  var now=DateTime.now();
  var formatter=DateFormat("EEE, MMM d, ''y");
  String formatted=formatter.format(now);
  return formatted;
}