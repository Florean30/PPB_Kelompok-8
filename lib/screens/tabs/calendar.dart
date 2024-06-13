import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedDays = [];
  bool _isEditing = false;
  Map<DateTime, List<Event>> tempEvents = {};

  final Map<DateTime, List<Event>> _events = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadFirestoreEvents(_focusedDay);
  }

  Future<void> _loadFirestoreEvents(DateTime focusedDay) async {
    tempEvents.clear();
    // Calculate the first and last day of the month
    DateTime firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    DateTime lastDayOfMonth =
        DateTime(focusedDay.year, focusedDay.month + 1, 0);
    // Query Firestore for events in the current month
    QuerySnapshot snapshot = await _firestore
        .collection('events')
        .where('date',
            isGreaterThanOrEqualTo: firstDayOfMonth.toIso8601String())
        .where('date', isLessThanOrEqualTo: lastDayOfMonth.toIso8601String())
        .get();

    for (var doc in snapshot.docs) {
      DateTime date = DateTime.parse(doc['date']);
      String title = doc['title'];
      if (!tempEvents.containsKey(date)) {
        tempEvents[date] = [];
      }
      tempEvents[date]!.add(Event(title));
    }

    setState(() {
      _events.clear();
      _events.addAll(tempEvents);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _addEvents();
      }
    });
  }

  Future<void> _addEvents() async {
    tempEvents.clear();
    for (var i = 0; i < _selectedDays.length; i++) {
      var day = _selectedDays[i];
      String tmpTitle = "Haid ke ${(i + 1) + tempEvents.length}";

      if (!_events.containsKey(day) ||
          !_events[day]!.any((event) => event.title == tmpTitle)) {
        setState(() {
          _events[day] = [..._events[day] ?? [], Event(tmpTitle)];
        });

        // Simpan event ke Firestore
        await _firestore.collection('events').add({
          'date': day.toIso8601String(),
          'title': tmpTitle,
        });
      }
    }
    _selectedDays.clear();
    _loadFirestoreEvents(_focusedDay);
  }

  void _removeEvent(DateTime day, Event event) async {
    setState(() {
      _events[day]?.remove(event);
      if (_events[day]?.isEmpty ?? false) {
        _events.remove(day);
      }
    });

    // Hapus event dari Firestore
    var snapshot = await _firestore
        .collection('events')
        .where('date', isEqualTo: day.toIso8601String())
        .where('title', isEqualTo: event.title)
        .get();
    for (var doc in snapshot.docs) {
      await _firestore.collection('events').doc(doc.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color.fromRGBO(247, 65, 143, 1),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromRGBO(247, 65, 143, 0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
            ),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return _selectedDays.contains(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_isEditing) {
                  if (_selectedDays.contains(selectedDay)) {
                    _selectedDays.remove(selectedDay);
                  } else {
                    _selectedDays.add(selectedDay);
                  }
                } else {
                  _selectedDays = [selectedDay];
                }
                _focusedDay = focusedDay;
              });
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
              _loadFirestoreEvents(_focusedDay);
            },
            eventLoader: _getEventsForDay,
          ),
          Expanded(
            child: ListView(
              children: _selectedDays
                  .map((day) => Column(
                        children: [
                          Divider(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                          ..._getEventsForDay(day).map((event) => ListTile(
                                title: Text(event.title),
                                subtitle: const Text("Subtitle"),
                                trailing: IconButton(
                                  onPressed: () {
                                    _removeEvent(day, event);
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.grey),
                                ),
                              )),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleEditMode,
        tooltip: _isEditing ? 'Save' : 'Edit',
        backgroundColor: const Color.fromRGBO(247, 65, 143, 1),
        child: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Event {
  final String title;
  Event(this.title);

  @override
  String toString() => title;
}
