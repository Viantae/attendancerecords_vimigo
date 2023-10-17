import 'package:flutter/material.dart';
import 'records.dart';

class RecordDetailsPage extends StatelessWidget {
  final Records recordDetails; 

  RecordDetailsPage({required this.recordDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: Color(0xff764abc),
              radius: 30.0,
              child: Icon(
                Icons.person,
              ),
            ),
            Text('Record ID: ${recordDetails.id}'),
            Text('Date Created: ${recordDetails.date}'),
            Text('People Attended (by PersonID): ${recordDetails.personID}'),
            // Display other record details as needed
          ],
        ),
      ),
    );
  }
}



