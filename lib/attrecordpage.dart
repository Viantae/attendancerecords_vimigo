import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content.dart';
import 'addrecordpage.dart';
import 'records.dart';
import 'search.dart';
import 'people.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // A variable to hold the loaded people
  List<Records> loadedRecords = [];

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
        body: ListView.builder(

          itemCount: loadedRecords.length,
          itemBuilder: (context, index){
            int totalPeople = Provider.of<PeopleProvider>(context).peopleList.length;
            double attendancePercentage = (loadedRecords[index].personID.length / totalPeople) * 100;

            // Create a list of content widgets for each Records
            List<Widget> contentWidgets = [
              const CircleAvatar(
                // backgroundImage: AssetImage('your_image_path'),
                backgroundColor: const Color(0xff764abc),
                radius: 30.0,
                child: Icon(
                  Icons.receipt,
                ),
              ),
              Text('Attendance ID Number: ${loadedRecords[index].id}'),
              Text('Date Created: ${loadedRecords[index].date}'),
              Text('Overall Attendance: $attendancePercentage'), // change this to calculation of total people attended
              IconButton(
                icon: Icon(Icons.arrow_forward_sharp),
                onPressed: () {
                  // Handle the button click
                },
              ),
            ];
            // Pass the contentWidgets to ContentPage
            return ContentPage(contentWidgets);
          },
        ),
      ),
    );
  }
}
