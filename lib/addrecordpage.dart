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
      body: ARP_Body(recordProvider: RecordProvider(loadedRecords), peopleProvider: PeopleProvider(loadedPeople)),
    );
  }
}

class ARP_Body extends StatefulWidget {
  final RecordProvider recordProvider;
  final PeopleProvider peopleProvider;

  const ARP_Body({Key? key, required this.recordProvider, required this.peopleProvider}) : super(key: key);

  @override
  State<ARP_Body> createState() => ARP_State(recordProvider: recordProvider, peopleProvider: peopleProvider);
}

class ARP_State extends State<ARP_Body> {
  final RecordProvider recordProvider;
  final PeopleProvider peopleProvider;

  ARP_State({required this.recordProvider, required this.peopleProvider});
  TextEditingController idInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController phoneInput = TextEditingController();

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
            }
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField( // ID input goes here
                controller: idInput,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.feed_outlined),
                  labelText: "Attendance ID",
                ),
              ),
              CheckListWidget(peopleList: peopleProvider.peopleList), // widget to check the people who attended
              TimePicker( // Widget to pick the time 
                controller: timeInput, 
                labelText: "Enter Time", 
              ),
            ],
          ),
        ),
      ),
    );
  }
}

