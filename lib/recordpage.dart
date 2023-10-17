import 'package:attendancerecords_vimigo/attendedpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendedpage.dart';
import 'content.dart';
import 'addrecordpage.dart';
import 'records.dart';
import 'search.dart';
import 'people.dart';
import 'timepassed.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // A variable to hold the loaded people
  List<Records> loadedRecords = [];

  bool timeFormat = true; // Add a flag to track the time format

  @override
  void initState() {
    super.initState();
    loadTimeFormat();
  }


  void updateState() {
  setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the recordProvider to retrieve the list of records
    final recordProvider = Provider.of<RecordProvider>(context);

    // Update the loadedRecords whenever the dependencies change
    loadedRecords = recordProvider.recordList;

    // Sort the loadedRecords list by date in descending order (most recent to oldest)
    loadedRecords.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
  }
  
  Future<void> loadTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeFormat = prefs.getBool('timeFormat') ?? true;
    });
  }

  Future<void> saveTimeFormat(bool newTimeFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('timeFormat', newTimeFormat);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Records Demo'),
          backgroundColor: const Color.fromARGB(255, 255, 119, 0),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Transform.scale(scale: 1.22, child: Icon(Icons.search)),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: Searchbar(loadedRecords),
                );
              },
            )
          ],
        ),
        floatingActionButton: customfloatingButton( 
          label: 'Record',
          iconData: Icons.add,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecordPage()),
            ).then((_) {
              // This code runs after returning from AddPeoplePage
              updateState(); // Refresh List
            });
          },
        ),
        body: Column(
          children: <Widget>[
            TimeFormatDropdown(
              // Use the custom dropdown button
              timeFormat: timeFormat,
              onChanged: (newTimeFormat) {
                setState(() {
                  timeFormat = newTimeFormat;
                  saveTimeFormat(newTimeFormat);
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: loadedRecords.length,
                itemBuilder: (context, index) {
                  int totalPeople =
                      Provider.of<PeopleProvider>(context).peopleList.length;
                  double attendancePercentage = (loadedRecords[index].personID.length / totalPeople) * 100;

                  String timeDifference = timeFormat
                      ? time_passed(DateTime.parse(loadedRecords[index].date))
                      : time_passed(DateTime.parse(loadedRecords[index].date), full: false);

                  List<Widget> contentWidgets = [
                    const CircleAvatar(
                      backgroundColor: const Color(0xff764abc),
                      radius: 30.0,
                      child: Icon(
                        Icons.receipt,
                      ),
                    ),
                    Text('Record ID: ${loadedRecords[index].id}'),
                    Text('Date Created: $timeDifference'),
                    Text('Overall Attendance: $attendancePercentage'),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_sharp),
                      onPressed: () {
                        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecordDetailsPage(recordDetails: loadedRecords[index])),
                        );
                      },
                    ),
                  ];
                  return ContentPage(contentWidgets);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
