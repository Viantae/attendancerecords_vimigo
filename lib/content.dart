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
class NameSelectChecklist extends StatefulWidget {
  final List<Person> peopleList;

  NameSelectChecklist({required this.peopleList});

  @override
  _NameSelectChecklistState createState() => _NameSelectChecklistState();
}

class _NameSelectChecklistState extends State<NameSelectChecklist> {
  List<bool> selectedNames = [];

  @override
  void initState() {
    super.initState();
    // Initialize the selectedNames list with false values for each name
    selectedNames = List<bool>.generate(widget.peopleList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Names'),
      content: Container(
        width: double.maxFinite,
        height: 300, // Set a fixed height 
        child: ListView.builder(
          itemCount: widget.peopleList.length,
          itemBuilder: (context, index) {
            final person = widget.peopleList[index];
            return ListTile(
              title: Text(person.name),
              leading: Checkbox(
                value: selectedNames[index],
                onChanged: (value) {
                  setState(() {
                    selectedNames[index] = value!;
                  });
                },
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Perform actions when "OK" is selected
            List<String> selected = [];
            for (int i = 0; i < selectedNames.length; i++) {
              if (selectedNames[i]) {
                selected.add(widget.peopleList[i].name);
              }
            }
            Navigator.of(context).pop(selected);
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

// Bottom Navigation bar 
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
            label: 'Add Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add_rounded),
            label: 'Manage People',
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

class TimeFormatDropdown extends StatelessWidget {
  final bool timeFormat;
  final Function(bool) onChanged;

  TimeFormatDropdown({required this.timeFormat, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: const BoxDecoration(
        color: const Color(0xff5b7c99), // Choose your desired background color
        borderRadius: BorderRadius.vertical(),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.access_time, // Your icon here
            color: const Color(0xffcfe8ef), // Icon color
          ),
          SizedBox(width: 5.0),
          DropdownButton<String>(
            value: timeFormat ? 'Detailed' : 'Simplified',
            onChanged: (newValue) {
              onChanged(newValue == 'Detailed');
            },
            items: <String>['Simplified', 'Detailed']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Color.fromARGB(255, 33, 229, 212), fontWeight: FontWeight.bold), // Text color
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}