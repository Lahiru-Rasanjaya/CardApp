import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  final textID = TextEditingController();

  Query dbRef = FirebaseDatabase.instance.reference().child('student_details');

  Widget listItem({required Map student}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${student['name']}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${student['id']}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          Text(
            'Phone: ${student['phone']}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            'Batch: ${student['batch']}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            'Email: ${student['email']}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching data'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textID,
              decoration: const InputDecoration(
                labelText: 'Enter Student ID',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text('Fetch Student Details'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: dbRef.onValue,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> studentsData =snapshot.data!.snapshot.value;
                  List<Map> studentsList = [];
                  
                  studentsData.forEach((key, value) {
                    studentsList.add({...value, 'key': key});
                  });
                  if (textID.text.isNotEmpty) {
                    studentsList.retainWhere((student) =>student['id'] == textID.text.trim());
                  }
                  return ListView.builder(
                    itemCount: studentsList.length,
                    itemBuilder: (context, index) =>listItem(student: studentsList[index]),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
