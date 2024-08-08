import 'package:assignment/models/event_model.dart';
import 'package:assignment/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<EventModel> _events = [];
  String _searchQuery = '';

  late EventProvider _eventProvider;
  void _loadEvents() {
    setState(() {
      _events = _eventProvider.events.where((event) {
        bool matchesDateTime = event.datetime.any((dateMap) {
          return dateMap.keys.any((date) => isSameDay(date, _selectedDay)) || dateMap.values.any((date) => isSameDay(date, _selectedDay));
        });
        bool matchesTitle = event.title.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchesDesc = event.description.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesDateTime && (matchesTitle || matchesDesc);
      }).toList();
    });
  }

  // void _search() {
  //   _events = _eventProvider.events.where((event) {
  //     bool matchesTitle = event.title.contains(_searchQuery.toLowerCase());
  //     bool matchesDesc = event.description.contains(_searchQuery.toLowerCase());
  //     return matchesTitle || matchesDesc;
  //   }).toList();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _eventProvider = Provider.of<EventProvider>(context, listen: false);
    _eventProvider.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search by Keyword',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (val) {
              _searchQuery = val;
              // debugPrint(_searchQuery);
              _loadEvents();
            },
          ),
          const SizedBox(height: 16.0),
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _loadEvents();
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 16.0),
          if (_events.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _events.map((event) {
                return Card(
                  // color: 
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.description),
                  ),
                );
              }).toList(),
            )
          else
            const Text('No events for this day'),
        ],
      ),
    );
  }
}
