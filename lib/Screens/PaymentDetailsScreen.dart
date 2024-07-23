import 'package:cardapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final textID = TextEditingController();

  CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('student_details');
  CollectionReference<Map<String, dynamic>> paymentRef =
      FirebaseFirestore.instance.collection('payment');

  int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: kAppbarColor,
        title: const Text(
          'Payment Details',
          style: TextStyle(
            color: kWhiteColor,
          ),
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: paymentRef.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                totalCount = snapshot.data!.docs.length;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        color: kbgColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 75.0, right: 75),
                          child: Text(
                            'Frequency of Payments - $totalCount',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 221, 221, 221),
                              fontSize: 16.0,
                              fontFamily: 'JosefinSans',
                            ),
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
            padding:
                const EdgeInsets.only(left: 100.0, right: 100.0, top: 10.0),
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
              stream: dbRef.where('id', isEqualTo: textID.text).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final studentDocs = snapshot.data!.docs;
                  if (studentDocs.isNotEmpty) {
                    final studentData = studentDocs.first.data();
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 15.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kbgColor,
                              boxShadow: kBoxShadow,
                            ),
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(
                                  text: studentData['name']),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0), // Adjust this as needed
                                prefixIcon:
                                    Icon(Icons.person, color: kAppbarColor),
                                border: InputBorder.none,
                                hintText: 'Student Name',
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
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 10.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kbgColor,
                              boxShadow: kBoxShadow,
                            ),
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(
                                  text: studentData['email']),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0), // Adjust this as needed
                                prefixIcon:
                                    Icon(Icons.email, color: kAppbarColor),
                                border: InputBorder.none,
                                hintText: 'Student Email',
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
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 10.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kbgColor,
                              boxShadow: kBoxShadow,
                            ),
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(
                                  text: studentData['phone']),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0), // Adjust this as needed
                                prefixIcon:
                                    Icon(Icons.call, color: kAppbarColor),
                                border: InputBorder.none,
                                hintText: 'Student Phone Number',
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
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 10.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kbgColor,
                              boxShadow: kBoxShadow,
                            ),
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(
                                  text: studentData['batch']),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0), // Adjust this as needed
                                prefixIcon: Icon(Icons.batch_prediction,
                                    color: kAppbarColor),
                                border: InputBorder.none,
                                hintText: 'Student AL/OL batch',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 221, 221, 221),
                                  fontSize: 16.0,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: paymentRef
                              .where('studentID', isEqualTo: textID.text)
                              .snapshots(),
                          builder: (context, paymentSnapshot) {
                            if (paymentSnapshot.hasData) {
                              final paymentDocs = paymentSnapshot.data!.docs;
                              if (paymentDocs.isNotEmpty) {
                                final paymentData = paymentDocs.first.data();
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 10.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: kbgColor,
                                          boxShadow: kBoxShadow,
                                        ),
                                        child: TextField(
                                          enabled: false,
                                          controller: TextEditingController(
                                              text: paymentData['date']),
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical:
                                                    12.0), // Adjust this as needed
                                            prefixIcon: Icon(Icons.date_range,
                                                color: kAppbarColor),
                                            border: InputBorder.none,
                                            hintText: 'Payment Date',
                                            hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 221, 221, 221),
                                              fontSize: 16.0,
                                              fontFamily: 'JosefinSans',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 10.0,
                                          bottom: 15.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: kbgColor,
                                          boxShadow: kBoxShadow,
                                        ),
                                        child: TextField(
                                          enabled: false,
                                          controller: TextEditingController(
                                              text: paymentData['time']),
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical:
                                                    12.0), // Adjust this as needed
                                            prefixIcon: Icon(
                                                Icons.timelapse_outlined,
                                                color: kAppbarColor),
                                            border: InputBorder.none,
                                            hintText: 'Payment Time',
                                            hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 221, 221, 221),
                                              fontSize: 16.0,
                                              fontFamily: 'JosefinSans',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'JosefinSans',
                                  ),
                                );
                              }
                            } else {
                              return const Text(
                                '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'JosefinSans',
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'JosefinSans',
                      ),
                    );
                  }
                } else {
                  return const Text(
                    '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'JosefinSans',
                    ),
                  );
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
