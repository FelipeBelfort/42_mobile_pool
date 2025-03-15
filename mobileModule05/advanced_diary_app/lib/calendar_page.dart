import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart';
import 'user_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirestoreService _firestoreService = FirestoreService();
  DateTime _selectedDate = DateTime.now();
  final ProfilePage _profilePage = ProfilePage();

  Widget _getCalendar() {
    return SizedBox(
      height: MediaQuery.of(context).orientation == Orientation.portrait
      ?MediaQuery.of(context).size.height * 0.65
      :MediaQuery.of(context).size.height * 0.065,
      width:
      MediaQuery.of(context).orientation == Orientation.portrait
      ?MediaQuery.of(context).size.width * 0.9
      :MediaQuery.of(context).size.width * 0.45,
      child: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _selectedDate,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() => _selectedDate = selectedDay);
        },
        availableCalendarFormats: {
          CalendarFormat.month: 'Month',
          },
        rowHeight: MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.065
        : 30,
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, day) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${day.month < 10 ? '0' : ''}${day.month} / ${day.year}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                  },
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                  child: Text("Today"),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _getEntriesOfTheDay() {
    return Expanded(
      child: Container(
        // color: Colors.black45,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getEntriesByDate(_selectedDate),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var entries = snapshot.data!.docs;
          return _profilePage.getEntriesList(entries.length, entries);
        },
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getCalendar(),
          Expanded(
            child: Column(
              children: [_getEntriesOfTheDay()],
          )
          ),
        ],
      );
    }
    return Column(
      children: [
        _getCalendar(),
        Container(),
        _getEntriesOfTheDay(),
      ],
  );
  }
}
