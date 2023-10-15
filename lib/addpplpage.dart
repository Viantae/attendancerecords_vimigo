import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'people.dart';

class addpplPage extends StatelessWidget {
  const addpplPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final List<Person> loadedPeople = peopleProvider.peopleList;
    return Scaffold(
        appBar: AppBar(
          title: Text('Attendance Record Demo'), // app title
          backgroundColor: const Color.fromARGB(255, 255, 119, 0),
          centerTitle: true, //centers title,
        ),
        body: _addpplBody(peopleProvider: PeopleProvider(loadedPeople))
        );
  }
}

class _addpplBody extends StatefulWidget {
  final PeopleProvider peopleProvider; //Pass PeopleProvider as a parameter
  const _addpplBody({Key? key, required this.peopleProvider}) : super(key: key);
  @override
  State<_addpplBody> createState() => __addpplBodyState(peopleProvider: peopleProvider); 
}

//Page to add people inside the list
class __addpplBodyState extends State<_addpplBody> {
  final PeopleProvider peopleProvider;

  __addpplBodyState({required this.peopleProvider}); 
  //Text Fields
  TextEditingController idInput = TextEditingController();
  TextEditingController nameInput = TextEditingController();
  TextEditingController phoneInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  
  //clear text field
  void clearTextField(TextEditingController controller) {
    controller.clear();
  }

  //Image selection
  File? _userImage; //store the selected image
  Future<void> _pickImage() async 
  {
    final imagePicker = ImagePicker(); //to access user gallery
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery); //wait for user to pick an image in their gallery

    //refresh state to load image
    if (pickedFile != null) 
    {
      setState(() {
        _userImage = File(pickedFile.path);
      });
    }
  }

  //page design
  @override
  Widget build(BuildContext context) 
  { 
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight * 0.13;
    return Scaffold(
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          return FractionallySizedBox(
            widthFactor: 0.28,
            heightFactor: 0.08,
            child: FloatingActionButton.extended(
              onPressed: () {
                final newPerson = Person(
                  id: idInput.text,
                  name: nameInput.text,
                  phone: phoneInput.text,
                  time: timeInput.text,
                );
                peopleProvider.addPerson(newPerson);

                //Go back previous screen
                Navigator.pop(context);
              },
              label: Text('Save', style: TextStyle(fontSize: 16.0)),
              icon: Transform.scale(scale: 1.25, child: Icon(Icons.save)),
              backgroundColor: const Color(0xff764abc),
              foregroundColor: Colors.white,
            ),
          );
        }
      ),
      body: SingleChildScrollView(
      child: Padding
      (
        padding: const EdgeInsets.all(10),
        child: Column
        (
          children: 
          [
            CircleAvatar // Person Image
            (
              radius: tileHeight * 0.5, // Size dependant on screen size
              backgroundImage:
                _userImage != null ? FileImage(_userImage!) : null,
              backgroundColor: const Color(0xff764abc),
              child: _userImage == null
              ? Icon
              (
                Icons.person,
                size: tileHeight * 0.4 * 2, // Adjust the size
              ): null,
            ),
            ElevatedButton
            (
              // For user to choose an image
              onPressed: _pickImage,
              child: Text("Add an Image"),
            ),
            TextField // Input person ID
            (
              controller: idInput,
              decoration: const InputDecoration
              (
                prefixIcon: Icon(Icons.feed_outlined),
                labelText: "Person ID",
              )
            ),
            TextField // Input person name
            (
              controller: nameInput,
              decoration: const InputDecoration
              (
                prefixIcon: Icon(Icons.person),
                labelText: "Person's Name",
              ),
            ),
            TextField // Input person phone
            (
              controller: phoneInput,
              decoration: const InputDecoration
              (
                prefixIcon: Icon(Icons.phone),
                labelText: "Phone Number",
              ),
            ),
            TextField // Input person check in time 
            (
              controller: timeInput,
              decoration: InputDecoration
              (
                prefixIcon: const Icon(Icons.access_time),
                labelText: "Check-in Time",
                suffixIcon: IconButton
                (
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                      clearTextField(timeInput);
                  },
                ),
              ),
              readOnly: true, //user will not able to edit text
              onTap: () 
              async
              {
                TimeOfDay? pickedTime = await showTimePicker
                (
                initialTime: TimeOfDay.now(),
                context: context,
                );

                if (pickedTime != null) 
                {
                  String simplifiedTime = pickedTime.format(context);

                  //output 1970-01-01 22:53:00.000
                  //DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());

                  //output 14:59:00
                  // String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

                setState(() {
                timeInput.text = simplifiedTime; //set the value of text field.
                });
                } 
                else 
                {
                  print("Time is not selected");
                }
              },
            )
          ],
        )
      )
    )
    );
  }
}
