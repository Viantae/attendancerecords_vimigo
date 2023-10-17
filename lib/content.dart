import 'package:attendancerecords_vimigo/peoplepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'attrecordpage.dart';
import 'people.dart';

//List View
class ContentPage extends StatelessWidget {
  final List<Widget> contentWidgets;
  const ContentPage(this.contentWidgets, {Key? key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight * 0.12;

    /*
    Design include:
      - Circular avatar on the left
      - Text details on the next to avatar 
      - Trailing icon on the most right
    */
    return Column(
      children: [
        SizedBox(
          height: tileHeight,
          child: ListTile(
            leading: CircleAvatar(
              radius: tileHeight * 0.27,
              backgroundColor: const Color(0xff764abc),
              child: contentWidgets[0], // First widget (e.g., an image)
            ),
            title: _TextWithPadding(contentWidgets[1]), // Title widget (e.g., a name)
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ //Other accompanying text
                for (int i = 2; i < contentWidgets.length - 1; i++)
                  _TextWithPadding(contentWidgets[i]),
              ],
            ),
            trailing: contentWidgets[contentWidgets.length - 1], // Last widget (e.g., a trailing widget)
          ),
        ),
        const Divider(
          height: 2, // Make it thicker
          color: Colors.black, 
        ),
      ],
    );
  }

  Widget _TextWithPadding(Widget widget) {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: widget,
    );
  }
}

// floating button
class customfloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData iconData;

  customfloatingButton({
    required this.label, 
    required this.onPressed,
    required this.iconData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FractionallySizedBox(
          widthFactor: 0.3,
          heightFactor: 0.09,
          child: FloatingActionButton.extended(
            onPressed: onPressed,
            label: Text("$label: ", style: TextStyle(fontSize: 16.0)),
            icon: Transform.scale(scale: 1.25, child: Icon(iconData)),
            backgroundColor: const Color(0xff764abc),
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

// checkbox list
class CheckListWidget extends StatefulWidget {
  final List<Person> peopleList;

  CheckListWidget({required this.peopleList});

  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {
  // Maintain a list of selected people
  List<bool> selectedPeople = [];

  @override
  void initState() {
    super.initState();
    // Initialize the selectedPeople list with false values for each person
    selectedPeople = List<bool>.generate(widget.peopleList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.peopleList.length,
      itemBuilder: (context, index) {
        final person = widget.peopleList[index];
        return ListTile(
          title: Text(person.name), // Display names
          leading: Checkbox(
            value: selectedPeople[index], // Get the checkbox state from the list
            onChanged: (value) {
              setState(() {
                // Update the checkbox state when changed
                selectedPeople[index] = value!;
              });
            },
          ),
        );
      },
    );
  }
}

// Bottom Navigation bar (customise if have time)
class Navigate extends StatefulWidget {
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // different pages/screens here
    AttendancePage(),
    PeoplePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendence Records Demo'),
      ),
      body: _pages[_currentIndex], // Display the currently selected page/screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_sharp),
            label: 'Records',
          ),
        ],
      ),
    );
  }
}

// Time picker field
class TimePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  TimePicker({required this.controller, required this.labelText});

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        icon: Icon(Icons.timer),
        labelText: widget.labelText,
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDateTime != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            initialTime: TimeOfDay.now(),
            context: context,
          );

          if (pickedTime != null) {
            DateTime combinedDateTime = DateTime(
              pickedDateTime.year,
              pickedDateTime.month,
              pickedDateTime.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedDateTime);

            setState(() {
              widget.controller.text = formattedDateTime;
            });
          } else {
            // print("Time is not selected");
          }
        } else {
          // print("Date is not selected");
        }
      }
    );
  }
}