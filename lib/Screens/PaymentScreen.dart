import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cardapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _RegistrationState();
}

final _formkey = GlobalKey<FormState>();

class _RegistrationState extends State<Payment> {
  final TextEditingController textID = TextEditingController();
  final CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('student_details');
  final CollectionReference<Map<String, dynamic>> paymentRef =
      FirebaseFirestore.instance.collection('payment');

  StreamSubscription<QuerySnapshot>? _subscription;

  String? name;
  String? email;
  String? phoneNumber;
  String? batch;

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
            email = snapshot.docs.first.data()['email'];
            phoneNumber = snapshot.docs.first.data()['phone'];
            batch = snapshot.docs.first.data()['batch'];
          });
        } else {
          setState(() {
            name = null;
            email = null;
            phoneNumber = null;
            batch = null;
          });
        }
      });
    } else {
      setState(() {
        name = null;
        email = null;
        phoneNumber = null;
        batch = null;
      });
    }
  }

  bool theory = false;
  bool paper = false;
  bool revision = false;

  void _submitPayment() {
    final List<String> selectedPayments = [];
    if (theory) selectedPayments.add('Theory');
    if (paper) selectedPayments.add('Paper');
    if (revision) selectedPayments.add('Revision');

    if (selectedPayments.isNotEmpty) {
      final DateTime now = DateTime.now();
      final String dateString = '${now.year}-${now.month}-${now.day}';
      final String timeString = DateFormat('hh:mm:ss a').format(now);
      final String monthString = '${now.month}';
      final String yearString = '${now.year}';

      paymentRef.add({
        'studentID': textID.text.trim(),
        'payments': selectedPayments,
        'date': dateString,
        'time': timeString,
        'month': monthString,
        'year': yearString,
        'btch': batch,
      });
    }
  }

  Future<void> sendEmail(
      String recipientEmail, String name, List<String> selectedPayments) async {
    const String username = 'leave4584@gmail.com'; // Your Gmail email address
    const String password = 'qjnbabylawtthaze'; // Your Gmail password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = const Address(username, 'CardApp')
      ..recipients.add(recipientEmail) // Student's email address
      ..subject = 'Payment Successful' // Subject of the email
      ..html = '''
        <p>Dear $name,Your payment has been successfully made for the following classes:</p>
        <ul>${selectedPayments.map((payment) => '<li>$payment</li>').join('')}</ul>
        <p>Thank you for your payment.</p>
      ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error sending email: $e');
    }
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
              'Payment of class fees',
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
              padding:
                  const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
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
                          left: 25.0, right: 25.0, top: 10.0),
                      child: Container(
                        height: 50.0,
                        alignment: Alignment.center,
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
                    if (name != null)
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
                            controller: TextEditingController(text: name),
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
                    if (email != null)
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
                            controller: TextEditingController(text: email),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 12.0),
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
                    if (phoneNumber != null)
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
                            controller:
                                TextEditingController(text: phoneNumber),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 12.0),
                              prefixIcon: Icon(Icons.call, color: kAppbarColor),
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
                          left: 25.0, right: 25.0, top: 15.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: kbgColor,
                          boxShadow: kBoxShadow,
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Monthly Payment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '     Theory    ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JosefinSans',
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Checkbox(
                                            activeColor: kAppbarColor,
                                            checkColor: Colors.white,
                                            hoverColor: kbgColor,
                                            value: theory,
                                            onChanged: (value) {
                                              setState(() {
                                                theory = value!;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            right: 25.0,
                                            left: 25.0),
                                        child: Text(
                                          'Paper',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'JosefinSans',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Checkbox(
                                            activeColor: kAppbarColor,
                                            checkColor: Colors.white,
                                            hoverColor: kbgColor,
                                            value: paper,
                                            onChanged: (value) {
                                              setState(() {
                                                paper = value!;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '     Revision   ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JosefinSans',
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Checkbox(
                                            activeColor: kAppbarColor,
                                            checkColor: Colors.white,
                                            hoverColor: kbgColor,
                                            value: revision,
                                            onChanged: (value) {
                                              setState(() {
                                                revision = value!;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 75.0, right: 75.0, top: 15.0, bottom: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          if (textID.text.trim().isNotEmpty) {
                            dbRef
                                .where('id', isEqualTo: textID.text.trim())
                                .get()
                                .then((snapshot) async {
                              if (snapshot.docs.isNotEmpty) {
                                if (theory || paper || revision) {
                                  _submitPayment();

                                  sendEmail(email!,name!, [
                                    if (theory) 'Theory class',
                                    if (paper) 'Paper class',
                                    if (revision) 'Revision class'
                                  ]);

                                  _SuccessfullMessage(context);
                                  textID.text = "";
                                  theory = false;
                                  paper = false;
                                  revision = false;
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
                  'Monthly Payment Successfull',
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
