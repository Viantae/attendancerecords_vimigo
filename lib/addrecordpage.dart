import 'package:attendancerecords_vimigo/records.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'people.dart';
import 'content.dart';

class AddRecordPage extends StatelessWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recordProvider = Provider.of<RecordProvider>(context);
    final List<Records> loadedRecords = recordProvider.recordList;
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final List<Person> loadedPeople = peopleProvider.peopleList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records Demo'),
        backgroundColor: const Color.fromARGB(255, 255, 119, 0),
        centerTitle: true,
      ),
      body: ARP_Body(
          recordProvider: RecordProvider(loadedRecords),
          peopleProvider: PeopleProvider(loadedPeople)),
    );
  }
}

class ARP_Body extends StatefulWidget {
  final RecordProvider recordProvider;
  final PeopleProvider peopleProvider;

  const ARP_Body(
      {Key? key, required this.recordProvider, required this.peopleProvider})
      : super(key: key);

  @override
  State<ARP_Body> createState() =>
      ARP_State(recordProvider: recordProvider, peopleProvider: peopleProvider);
}

class ARP_State extends State<ARP_Body> {
  final RecordProvider recordProvider;
  final PeopleProvider peopleProvider;

  ARP_State({required this.recordProvider, required this.peopleProvider});
  TextEditingController recordIDInput = TextEditingController(); // controller to store record ID
  TextEditingController datecreatedInput = TextEditingController();  // controller to store date created
  List<TextEditingController> checkinTimeInput = []; // List to store the employee checkintime of each person
  List<String> checkinTime = []; // List to store the checkintime of each person
  List<String> selectedNames = [];  // List to store selected persons names
  List<String> selectedPersonIDs = []; // List to store selected person IDs
  bool shouldRefresh = false; // for refreshing the page if true


  // GlobalKey to refresh the page
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the list of controllers and selected names
    checkinTimeInput = List.generate(peopleProvider.peopleList.length, (index) => TextEditingController());
    selectedNames = List.generate(peopleProvider.peopleList.length, (index) => "");
  }
    // Shows the list of names
  void showNameSelectionDialog() async {
    final selectedPeople = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return NameSelectChecklist(peopleList: peopleProvider.peopleList);
      },
    );

    if (selectedPeople != null) {
      for (int i = 0; i < selectedPeople.length; i++) {
        // Assign the selected names to the corresponding controllers
        selectedNames[i] = selectedPeople[i];
        // Find the corresponding person ID and add it to the list
      final selectedPerson = peopleProvider.peopleList.firstWhere(
          (person) => person.name == selectedNames[i],
          orElse: () => Person(name: '', id: '', phone: ''), // Handle the case when no matching person is found
        );
        selectedPersonIDs.add(selectedPerson.id);
      }

      
      // Set the flag to trigger a refresh
      setState(() {
        shouldRefresh = true;
      });
    }
  }

  void saveRecord() async {
    if (recordIDInput.text.isEmpty ||
        datecreatedInput.text.isEmpty) {
      // Show an error message or dialog to inform the user that some fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all required fields. (ID and Date)'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Convert text editing controller to List<String>
      for (int i = 0; i < checkinTimeInput.length; i++) {
        checkinTime.add(checkinTimeInput[i].text);
      }

      // Create a Records object with the data from input fields
      final newRecord = Records(
        id: recordIDInput.text,
        personID: selectedPersonIDs,
        checkinTime: checkinTime, // Join the checkin times into a single string
        date: datecreatedInput.text,
      );

      // Add the new record to the provider
      recordProvider.addRecords(newRecord);
      

      recordIDInput.clear();
      datecreatedInput.clear();
      for (final controller in checkinTimeInput) {
        controller.clear();
      }

      // Return to the record page
      Navigator.pop(context);
      showSuccessDialog(context, "Added Sucessfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: customfloatingButton(
          label: 'Save',
          iconData: Icons.save,
          onPressed: () {
            saveRecord();
          }),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // ID input goes here
              TextField(
                controller: recordIDInput,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.feed_outlined),
                  labelText: "Input Attendance Record ID",
                ),
              ),

            // Widget to pick the date record was created
              TimePicker(
              controller: datecreatedInput,
              labelText: "Input the Date Created for this Record",
            ),

            ElevatedButton(
              onPressed: showNameSelectionDialog,
              child: Text("Select People Who Attended"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40), // Set a minimum height
              ),
            ),
            // Display selected names and put time
            if (shouldRefresh) ...[
              for (int i = 0; i < selectedNames.length; i++)
                if (selectedNames[i].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          "${selectedNames[i]}   id: ${selectedPersonIDs[i]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete), // Add the delete icon
                          onPressed: () {
                            // Handle deletion here, for example, clear the controller
                            checkinTimeInput[i].clear();
                            setState(() {
                              selectedNames[i] = ''; // Clear the selected name
                            });
                          },
                        ),
                      ),
                      Text("Checked-in Time"),
                      TimePicker(
                        controller: checkinTimeInput[i], 
                        labelText: "Select Check-in Time",
                      ),
                    ],
                  ),
            ]
          ]),
        ),
      ),
    );
  }
}
