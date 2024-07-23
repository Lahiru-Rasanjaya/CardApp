import 'dart:async';
import 'package:cardapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final String studentID;

  const Report({super.key, required this.studentID});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('student_details');
  final CollectionReference<Map<String, dynamic>> paymentRef =
      FirebaseFirestore.instance.collection('payment');

  StreamSubscription<QuerySnapshot>? _subscription;
  String? date;
  String? name;
  String? time;
  bool monthlyPaymentMadeT = false;
  bool monthlyPaymentMadeP = false;
  bool monthlyPaymentMadeR = false;

  @override
  void initState() {
    super.initState();
    _fetchStudentDetails(widget.studentID);
    _checkMonthlyPayment(widget.studentID);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _fetchStudentDetails(String studentID) {
    _subscription?.cancel();
    if (studentID.isNotEmpty) {
      _subscription = paymentRef
          .where('studentID', isEqualTo: studentID)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            date = snapshot.docs.first.data()['date'];
            time = snapshot.docs.first.data()['time'];
          });
        } else {
          setState(() {
            date = null;
            time = null;
          });
        }
      });
    }
    if (studentID.isNotEmpty) {
      _subscription = dbRef
          .where('id', isEqualTo: studentID)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            name = snapshot.docs.first.data()['name'];
          });
        } else {
          setState(() {
            name = null;
          });
        }
      });
    } else {
      setState(() {
        date = null;
        time = null;
      });
    }
  }

  void _checkMonthlyPayment(String studentID) {
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    paymentRef.where('studentID', isEqualTo: studentID).get().then((snapshot) {
      // for Theory
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final paymentDate = (doc.data()['date'] as String).split('-');
          final int paymentYear = int.parse(paymentDate[0]);
          final int paymentMonth = int.parse(paymentDate[1]);

          if (paymentYear == currentYear && paymentMonth == currentMonth) {
            if ((doc.data()['payments'] as List).contains('Theory')) {
              setState(() {
                monthlyPaymentMadeT = true;
              });
            }
            break;
          }
        }
      } else {
        setState(() {
          monthlyPaymentMadeT = false;
        });
      }
      // for paper
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final paymentDate = (doc.data()['date'] as String).split('-');
          final int paymentYear = int.parse(paymentDate[0]);
          final int paymentMonth = int.parse(paymentDate[1]);

          if (paymentYear == currentYear && paymentMonth == currentMonth) {
            if ((doc.data()['payments'] as List).contains('Paper')) {
              setState(() {
                monthlyPaymentMadeP = true;
              });
            }
            break;
          }
        }
      } else {
        setState(() {
          monthlyPaymentMadeP = false;
        });
      }
      // for Revision
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final paymentDate = (doc.data()['date'] as String).split('-');
          final int paymentYear = int.parse(paymentDate[0]);
          final int paymentMonth = int.parse(paymentDate[1]);

          if (paymentYear == currentYear && paymentMonth == currentMonth) {
            if ((doc.data()['payments'] as List).contains('Revision')) {
              setState(() {
                monthlyPaymentMadeR = true;
              });
            }
            break;
          }
        }
      } else {
        setState(() {
          monthlyPaymentMadeR = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: kAppbarColor,
        title: const Text(
          'Payment Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: kWhiteColor,
          child: ListView(
            children: [
              Container(
                height: 70.0,
                decoration: const BoxDecoration(
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: Container(
                      height: 45.0,
                      decoration: const BoxDecoration(
                        color: kbgColor,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            enabled: false,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.person_search,
                                    color: kAppbarColor),
                              ),
                              border: InputBorder.none,
                              hintText: widget.studentID,
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 221, 221, 221),
                                fontSize: 16.0,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                 padding:
                  const EdgeInsets.only( left: 25.0, right: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: kWhiteColor,
                    boxShadow: kBoxShadow,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0,top: 15.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kbgColor,
                            boxShadow: kBoxShadow,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(text: name),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.person, color: kAppbarColor),
                                ),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kbgColor,
                            boxShadow: kBoxShadow,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(text: date),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child:
                                      Icon(Icons.date_range, color: kAppbarColor),
                                ),
                                border: InputBorder.none,
                                hintText: 'Date',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 221, 221, 221),
                                  fontSize: 16.0,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kbgColor,
                            boxShadow: kBoxShadow,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              enabled: false,
                              controller: TextEditingController(text: time),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.access_time,
                                      color: kAppbarColor),
                                ),
                                border: InputBorder.none,
                                hintText: 'Time',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 221, 221, 221),
                                  fontSize: 16.0,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 20.0),
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
                                      'Payment for Theory Class',
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
                                      value: monthlyPaymentMadeT,
                                      onChanged: null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 20.0),
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
                                      'Payment for Paper Class',
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
                                      value: monthlyPaymentMadeP,
                                      onChanged: null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 20.0,bottom: 25.0),
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
                                      'Payment for Revision Class',
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
                                      value: monthlyPaymentMadeR,
                                      onChanged: null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
