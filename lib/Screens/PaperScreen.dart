import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cardapp/Screens/SReportScreen.dart';
import 'package:cardapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Paper extends StatefulWidget {
  const Paper({super.key});

  @override
  State<Paper> createState() => _TheoryState();
}

class _TheoryState extends State<Paper> {
  final TextEditingController textID = TextEditingController();
  final CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('student_details');
  final CollectionReference<Map<String, dynamic>> paymentRef =
      FirebaseFirestore.instance.collection('payment');
  final CollectionReference<Map<String, dynamic>> attendanceRef =
      FirebaseFirestore.instance.collection('attendancePaper');

  StreamSubscription<QuerySnapshot>? _subscription;

  String? name;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchStudentDetails();
    textID.addListener(_fetchStudentDetails);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    textID.removeListener(_fetchStudentDetails);
    super.dispose();
  }

  void _fetchStudentDetails() {
    final String id = textID.text.trim();

    _subscription?.cancel();
    if (id.isNotEmpty) {
      _subscription =
          dbRef.where('id', isEqualTo: id).snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            name = snapshot.docs.first.data()['name'];
            imageUrl = snapshot.docs.first.data()['imageUrl'];
          });
          _checkMonthlyPayment(id);
          _fetchAttendanceWeeks(id);
        } else {
          setState(() {
            name = null;
            imageUrl = null;
            monthlyPaymentMade = false;
            weeksOfMonth = [];
          });
        }
      });
    } else {
      setState(() {
        name = null;
        imageUrl = null;
        monthlyPaymentMade = false;
        weeksOfMonth = [];
      });
    }
  }

  // Monthly Payment
  bool monthlyPaymentMade = false;

  void _checkMonthlyPayment(String studentID) {
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    paymentRef.where('studentID', isEqualTo: studentID).get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final paymentDate = (doc.data()['date'] as String).split('-');
          final int paymentYear = int.parse(paymentDate[0]);
          final int paymentMonth = int.parse(paymentDate[1]);

          if (paymentYear == currentYear && paymentMonth == currentMonth) {
            if ((doc.data()['payments'] as List).contains('Paper')) {
              setState(() {
                monthlyPaymentMade = true;
              });
            }
            break;
          }
        }
      } else {
        setState(() {
          monthlyPaymentMade = false;
        });
      }
    });
  }

  bool payment = false;
  bool week1 = false;
  bool today = false;

  void _submitAttendance() {
    final List<String> selectedAttendance = [];
    if (today) selectedAttendance.add('Participation is OK');

    if (selectedAttendance.isNotEmpty) {
      final DateTime now = DateTime.now();
      final String dateString = '${now.year}-${now.month}-${now.day}';
      final String timeString = DateFormat('hh:mm:ss a').format(now);

      final String monthString = '${now.month}';
      final String yearString = '${now.year}';

      // Calculate the week of the month
      final String weekOfMonth = 'week ${((now.day - 1) ~/ 7) + 1}';

      attendanceRef.add({
        'studentID': textID.text.trim(),
        'Participation': selectedAttendance,
        'date': dateString,
        'time': timeString,
        'month': monthString,
        'year': yearString,
        'weekOfMonth': weekOfMonth, // Add the week of the month here
      });
    }
  }

// Display month attendence
  List<String> weeksOfMonth = [];
  void _fetchAttendanceWeeks(String studentID) {
    final DateTime now = DateTime.now();
    final String monthString = '${now.month}';

    attendanceRef
        .where('studentID', isEqualTo: studentID)
        .where('month', isEqualTo: monthString)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        List<String> weeks = [];
        for (var doc in snapshot.docs) {
          weeks.add(doc.data()['weekOfMonth']);
        }
        setState(() {
          weeksOfMonth = weeks;
        });
      } else {
        setState(() {
          weeksOfMonth = [];
        });
      }
    }).catchError((error) {
      print('Error fetching attendance records: $error');
      setState(() {
        weeksOfMonth = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: kAppbarColor,
        title: const Row(
          children: [
            Text(
              'Attendance Marking',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: kWhiteColor,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 15.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: kBoxShadow,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Paper',
                                  style: TextStyle(
                                      color: kbgColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 10.0),
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
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    prefixIcon: Icon(Icons.person_search_sharp,
                                        color: kAppbarColor),
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
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 10.0),
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
                                  controller: TextEditingController(text: name),
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 12.0),
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
                            if (imageUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 60.0, right: 60.0, top: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kbgColor,
                                    boxShadow: kBoxShadow,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Image.network(
                                    imageUrl!,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: Container(
                                    height: 28.0,
                                    decoration: BoxDecoration(
                                      color: kbgColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: kBoxShadow,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 15.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Monthly Payment',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'JosefinSans',
                                            ),
                                          ),
                                          const Spacer(),
                                          Checkbox(
                                            activeColor: kAppbarColor,
                                            checkColor: Colors.white,
                                            hoverColor: kbgColor,
                                            value: monthlyPaymentMade,
                                            onChanged: null,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (weeksOfMonth.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 15.0, right: 15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kbgColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: kBoxShadow,
                                  ),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          'Monthly Attendance',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'JosefinSans',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 15.0),
                                        child: Column(
                                          children: weeksOfMonth
                                              .map((week) => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        week,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'JosefinSans',
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Icon(
                                                        Icons.check_box_rounded,
                                                        color: kAppbarColor,
                                                      ),
                                                    ],
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Container(
                                    height: 28.0,
                                    decoration: BoxDecoration(
                                      color: kbgColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: kBoxShadow,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 15.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Participation today',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'JosefinSans',
                                            ),
                                          ),
                                          const Spacer(),
                                          Checkbox(
                                              activeColor: kAppbarColor,
                                              checkColor: Colors.white,
                                              hoverColor: kbgColor,
                                              value: today,
                                              onChanged: (value) {
                                                setState(() {
                                                  today = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 65.0, right: 65.0, top: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (textID.text.trim().isNotEmpty) {
                                    dbRef
                                        .where('id',
                                            isEqualTo: textID.text.trim())
                                        .get()
                                        .then((snapshot) {
                                      if (snapshot.docs.isNotEmpty) {
                                        if (today) {
                                          _submitAttendance();
                                          _SuccessfullMessage(context);
                                          textID.text = "";
                                          today = false;
                                          monthlyPaymentMade = false;
                                        } else {
                                          _checkboxNotSelect(context);
                                        }
                                      } else {
                                        _studentIdNotMatch(context);
                                      }
                                    });
                                  } else {
                                    _enterStudentId(context);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: kbgColor,
                                    boxShadow: kBoxShadow,
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontFamily: 'JosefinSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (textID.text.trim().isNotEmpty) {
                                    dbRef
                                        .where('id',
                                            isEqualTo: textID.text.trim())
                                        .get()
                                        .then((snapshot) {
                                      if (snapshot.docs.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Report(
                                                    studentID:
                                                        textID.text.trim())));
                                      } else {
                                        _studentIdNotMatch(context);
                                      }
                                    });
                                  } else {
                                    _enterStudentId(context);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 25.0,
                                  decoration: const BoxDecoration(
                                    color: kbgColor,
                                    boxShadow: kBoxShadow,
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Payment Details',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JosefinSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  _checkboxNotSelect(BuildContext context) {
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
                  'No checkbox Selected',
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

  _SuccessfullMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  'Attendance marking Successfull',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      behavior: SnackBarBehavior.values.first,
      backgroundColor: Colors.transparent,
      elevation: 3,
    ));
  }
}
