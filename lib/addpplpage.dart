import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'people.dart';
import 'content.dart';

class AddPeoplePage extends StatelessWidget {
  const AddPeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final List<Person> loadedPeople = peopleProvider.peopleList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records Demo'),
        backgroundColor: const Color.fromARGB(255, 255, 119, 0),
        centerTitle: true,
      ),
      body: AddPeopleBody(peopleProvider: PeopleProvider(loadedPeople)),
    );
  }
}

class AddPeopleBody extends StatefulWidget {
  final PeopleProvider peopleProvider;

  const AddPeopleBody({Key? key, required this.peopleProvider}) : super(key: key);

  @override
  State<AddPeopleBody> createState() => AddPeopleBodyState(peopleProvider: peopleProvider);
}

class AddPeopleBodyState extends State<AddPeopleBody> {
  final PeopleProvider peopleProvider;

  AddPeopleBodyState({required this.peopleProvider});
  TextEditingController idInput = TextEditingController();
  TextEditingController nameInput = TextEditingController();
  TextEditingController phoneInput = TextEditingController();
  File? _userImage;

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

  // Allow user to pick an image from their gallery
  Future<void> _pickImage() async { 
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _userImage = File(pickedFile.path);
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
          if (idInput.text.isEmpty ||
              nameInput.text.isEmpty ||
              phoneInput.text.isEmpty) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Please fill in all fields.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          } else {
            // All fields are entered, proceed to save the data
            final newPerson = Person(
              id: idInput.text,
              name: nameInput.text,
              phone: phoneInput.text,
            );
            peopleProvider.addPerson(newPerson);
            Navigator.pop(context);
            showSuccessDialog(context, "Added Sucessfully");
          }
      },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CircleAvatar(
                radius: 75.0,
                backgroundImage: _userImage != null ? FileImage(_userImage!) : null,
                backgroundColor: const Color(0xff764abc),
                child: _userImage == null ? const Icon(
                  Icons.person,
                  size: 80.0,
                ) : null,
              ),
              ElevatedButton( // Button to allow users to add an image
                onPressed: _pickImage,
                child: Text("Add an Image"), 
              ),
              TextField( // ID input goes here
                controller: idInput,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.feed_outlined),
                  labelText: "Person ID",
                ),
              ),
              TextField( // Name input goes here
                controller: nameInput,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Person's Name",
                ),
              ),
              TextField( // Phone input goes here
                controller: phoneInput,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Phone Number",
                ),
                keyboardType: TextInputType.number, // Allow only numbers
              ),
            ]
          ),
        ),
      ),
    );
  }
}

