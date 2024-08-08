import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CustomDateTimePicker extends StatefulWidget {
  const CustomDateTimePicker({super.key, required this.setDatetime, required this.lastDateTime});
  final Function(DateTime startDate, DateTime endDate) setDatetime;
  final DateTime lastDateTime;

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  void showDatetimePicker() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: widget.lastDateTime.add(const Duration(days: 1)),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: widget.lastDateTime.add(const Duration(days: 1, minutes: 15)),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      startSelectableDayPredicate: (dateTime) {
        if (dateTime.isBefore(widget.lastDateTime.subtract(const Duration(days: 1)))) {
          return false;
        } else {
          return true;
        }
      },
      endSelectableDayPredicate: (dateTime) {
        if (dateTime.isBefore(widget.lastDateTime.subtract(const Duration(days: 1)))) {
          return false;
        } else {
          return true;
        }
      },
    );
    if (dateTimeList != null) {
      if (dateTimeList[0].isBefore(dateTimeList[1]) &&
          dateTimeList[0].isAfter(widget.lastDateTime)) {
        widget.setDatetime(
            formatDateTime(dateTimeList[0]), formatDateTime(dateTimeList[1]));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Invalid Datetime",
                style: mediumTextStyle.copyWith(color: Colors.white),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: showDatetimePicker,
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.blue,
            )),
      ],
    );
  }
}
