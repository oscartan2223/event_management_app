import 'package:google_maps_flutter/google_maps_flutter.dart';

String formatLocationToString(LatLng location) {
  return '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
}

LatLng formatStringToLocation(String location) {
  List<String> parts = location.split(','); // Split the input string by comma
  
  if (parts.length != 2) {
    throw const FormatException('Invalid location format'); // Handle invalid format
  }
  
  try {
    double lat = double.parse(parts[0].trim()); // Parse latitude
    double lng = double.parse(parts[1].trim()); // Parse longitude
    return LatLng(lat, lng); // Return LatLng object
  } catch (e) {
    throw FormatException('Error parsing location: $e'); // Handle parsing error
  }
}

String formatDateTimeToString(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  
  String year = dateTime.year.toString();
  String month = twoDigits(dateTime.month);
  String day = twoDigits(dateTime.day);
  String hour = twoDigits(dateTime.hour);
  String minute = twoDigits(dateTime.minute);
  // String second = twoDigits(dateTime.second);
  
  return '$year-$month-$day $hour:$minute';
}

String formatDateTimeToStringDate(DateTime dateTime) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  
  String year = dateTime.year.toString();
  String month = twoDigits(dateTime.month);
  String day = twoDigits(dateTime.day);  
  return '$year-$month-$day';
}

DateTime formatDateTime (DateTime dateTime) {
  return DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
  );
}

DateTime formatDateTimeToDate (DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

String formatContact(String contact) {

  String part1 = contact.substring(0, 3);
  String part2 = contact.substring(3, 6);
  String part3 = contact.substring(6);

  return '$part1-$part2 $part3';
}
