import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content.dart';
import 'records.dart';

class AttHead extends StatefulWidget {
  AttHead({Key? key}) : super(key: key);

  @override
  _AttHeadState createState() => _AttHeadState();
}

class _AttHeadState extends State<AttHead> {
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
                /* SEARCH FOR Records ID
                showSearch(
                  context: context,
                  delegate: SearchPeople(loadedRecords),
                );
                */
              },
            )
          ],
        ),
        //floating icon here
        body: ListView.builder(
          itemCount: loadedRecords.length,
          itemBuilder: (context, index){
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
              Text('Date: ${loadedRecords[index].date}'),
              Text('Present: ${loadedRecords[index].isPresent}'),
              Text('Checked in: ${loadedRecords[index].checkinTime}'),
              Text('ID Number: ${loadedRecords[index].id}'),
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
