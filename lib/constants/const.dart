import 'dart:ui';

const aPrimaryColor = Color(0xFF00574B);
const aPrimaryColorLight = Color(0xFF19675D);
const aPrimaryColorLightest = Color(0xFF4C8981);

class FormStructure {
  FormStructure._();

  static bool is5MinutesAhead(DateTime date) {

  // Current time - at this moment
  DateTime today = DateTime.now();

  // Parsed date to check
  DateTime dateCheck = date;

  // Date to check but moved 5 minutes behind
  DateTime newDate = DateTime(
    dateCheck.year,
    dateCheck.month,
    dateCheck.day,
    dateCheck.hour,
    dateCheck.minute - 5,
    dateCheck.second
  );
  return today.isBefore(newDate);
  } 
}