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
  TextEditingController idInput = TextEditingController();
  TextEditingController datecreatedInput = TextEditingController();
  List<TextEditingController> checkinTimeInput = [];
  List<String> selectedNames = [];
  bool shouldRefresh = false;


  // GlobalKey to refresh the page
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Initialize the list of controllers and selected names
    checkinTimeInput = List.generate(peopleProvider.peopleList.length, (index) => TextEditingController());
    selectedNames = List.generate(peopleProvider.peopleList.length, (index) => "");
  }

  // Shows the list of names
    // Shows the list of names
  void _showNameSelectionDialog() async {
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
      }

      // Set the flag to trigger a refresh
      setState(() {
        shouldRefresh = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: customfloatingButton(
          label: 'Save',
          iconData: Icons.save,
          onPressed: () {
            /*
            final newRecord = Records(
                  id: idInput.text,
                  name: nameInput.text,
                  phone: phoneInput.text,
                );
                
            recordProvider.addRecords(newRecord);
              */
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // ID input goes here
              TextField(
                controller: idInput,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.feed_outlined),
                  labelText: "Attendance ID",
                ),
              ),

            // Widget to pick the date record was created
              TimePicker(
              controller: datecreatedInput,
              labelText: "Date Created",
            ),

            ElevatedButton(
              onPressed: _showNameSelectionDialog,
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
                          selectedNames[i],
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
