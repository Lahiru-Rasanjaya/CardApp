import 'package:cardapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class studentDetails extends StatefulWidget {
  const studentDetails({super.key});

  @override
  State<studentDetails> createState() => _studentDetailsState();
}

class _studentDetailsState extends State<studentDetails> {
  final textID = TextEditingController();

  CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('student_details');

  Widget listItem({required Map student}) {
    return Container(
      margin: const EdgeInsets.only(
          left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
      padding: const EdgeInsets.only(
          left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: kbgColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: kBoxShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Name : ${student['name']}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 233, 233, 233),
                  fontSize: 16,
                  fontFamily: 'JosefinSans'),
            ),
            const SizedBox(height: 8),
            Text(
              'Student ID : ${student['id']}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 233, 233, 233),
                  fontSize: 16,
                  fontFamily: 'JosefinSans'),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone Number : ${student['phone']}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 233, 233, 233),
                  fontSize: 16,
                  fontFamily: 'JosefinSans'),
            ),
            const SizedBox(height: 8),
            Text(
              'OL/AL Batch : ${student['batch']}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 233, 233, 233),
                  fontSize: 16,
                  fontFamily: 'JosefinSans'),
            ),
            const SizedBox(height: 8),
            Text(
              'Email : ${student['email']}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 233, 233, 233),
                  fontSize: 16,
                  fontFamily: 'JosefinSans'),
            ),
          ],
        ),
      ),
    );
  }
int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: kAppbarColor,
        title: const Text(
          'Student Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
           StreamBuilder<QuerySnapshot>(
        stream: dbRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            totalCount = snapshot.data!.docs.length;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: kbgColor,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 70.0,right:70),
                      child: Text(
                        'Total number of students - $totalCount',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 221, 221, 221),
                    fontSize: 16.0,
                    fontFamily: 'JosefinSans',),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: kbgColor,
                boxShadow: kBoxShadow,
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: textID,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  prefixIcon:
                      Icon(Icons.person_search_sharp, color: kAppbarColor),
                  border: InputBorder.none,
                  hintText: 'Enter Student ID',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 221, 221, 221),
                    fontSize: 16.0,
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 75.0, right: 75.0, top: 10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (textID.text.trim().isNotEmpty) {
                    dbRef
                        .where('id', isEqualTo: textID.text.trim())
                        .get()
                        .then((snapshot) {
                      if (snapshot.docs.isNotEmpty) {
                      } else {
                        _studentIdNotMatch(context);
                      }
                    });
                  } else {
                    _enterStudentId(context);
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(kbgColor),
              ),
              child: const Text(
                'Student Search',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: dbRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Check if the snapshot has data
                  final studentsList = snapshot.data!.docs
                      .map((doc) => {...doc.data(), 'key': doc.id})
                      .toList();

                  if (textID.text.isNotEmpty) {
                    // Filter studentsList based on textID
                    studentsList.retainWhere(
                        (student) => student['id'] == textID.text.trim());
                  }

                  return ListView.builder(
                    itemCount: studentsList.length,
                    itemBuilder: (context, index) =>
                        listItem(student: studentsList[index]),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Show a loading indicator while waiting for data
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Show an error message if snapshot has no data
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _studentIdNotMatch(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  'Student not found',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 3,
    ));
  }

  _enterStudentId(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  'Enter Student ID',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 3,
    ));
  }
}
