import 'dart:io';
import 'dart:math';
import 'package:cardapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

final _formkey = GlobalKey<FormState>();

String uniqueFileName = DateTime.now().day.toString();
String randomNumber = Random().nextInt(1000).toString().padLeft(4, '0');
String primaryKey = uniqueFileName + randomNumber;

final DateTime now = DateTime.now();
final String dateString = '${now.year}-${now.month}-${now.day}';
final String timeString = DateFormat('hh:mm:ss a').format(now);

class _RegistrationState extends State<Registration> {
  File? _selectedImage;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final batchController = TextEditingController();

  late CollectionReference<Map<String, dynamic>> dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseFirestore.instance.collection('student_details');
  }

// name validation
  String? validateName(String? name) {
    if (name == null ||
        name.isEmpty ||
        !RegExp(r'^[a-zA-Z ]+$').hasMatch(name) ||
        name.length < 3 ||
        name.length > 50) {
      return _nameValidate(context);
    }
    return null;
  }

// email validation
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return _emailNotValid(context);
    }
    return null;
  }

// phone number
  String? validatePhoneNumber(String? phoneNumber) {
    RegExp phoneRegex = RegExp(r'^\d{10}$');

    if (!phoneRegex.hasMatch(phoneNumber ?? '')) {
      return _phoneNumberValidate(context);
    }
    return null;
  }

// batch validate
  String? validatebatch(String? phoneNumber) {
    RegExp phoneRegex = RegExp(r'^\d{4}$');

    if (!phoneRegex.hasMatch(phoneNumber ?? '')) {
      return _batchValidate(context);
    }
    return null;
  }

  String imageUrl = '';

  Future<void> sendEmail(String recipientEmail, String studentID) async {
    const String username = 'leave4584@gmail.com'; // Your Gmail email address
    const String password = 'qjnbabylawtthaze'; // Your Gmail password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = const Address(username, 'CardApp')
      ..recipients.add(recipientEmail) // Student's email address
      ..subject = 'Your Student ID' // Subject of the email
      ..html = '''
      <p><strong style="color: black;">Welcome to our Institute of Education. Your registration is successful.</strong></p>
      <p>Your student ID is: <strong style="color: red;">$studentID</strong></p>
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
              'Student Registration',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: kWhiteColor,
        child: Form(
          key: _formkey,
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
                          child: TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.only(left: 15.0, right: 10.0),
                                child: Icon(Icons.person, color: kAppbarColor),
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter Student Name',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 221, 221, 221),
                                fontSize: 16.0,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            validator: validateName,
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
                          child: TextFormField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Icon(Icons.email, color: kAppbarColor),
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter Student Email',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 221, 221, 221),
                                fontSize: 16.0,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            validator: validateEmail,
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
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: numberController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Icon(Icons.call, color: kAppbarColor),
                              ),
                              border: InputBorder.none,
                              hintText: 'Student Phone Number',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 221, 221, 221),
                                fontSize: 16.0,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            validator: validatePhoneNumber,
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
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: batchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Icon(Icons.batch_prediction,
                                    color: kAppbarColor),
                              ),
                              border: InputBorder.none,
                              hintText: 'OL/AL batch',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 221, 221, 221),
                                fontSize: 16.0,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            validator: validatebatch,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: _selectedImage != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Image.file(_selectedImage!),
                                      )
                                    : Image.asset('assets/camera.png'),
                                onPressed: () async {
                                  final returnedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  if (returnedImage == null) {
                                    return;
                                  }

                                  final File pickedImage =
                                      File(returnedImage.path);
                                  final img.Image? image = img.decodeImage(
                                      pickedImage.readAsBytesSync());

                                  if (image == null) {
                                    // Handle error when decoding image
                                    return;
                                  }

                                  // Resize image
                                  final img.Image resizedImage = img.copyResize(
                                      image,
                                      width: 150,
                                      height: 150);

                                  // Save resized image to file
                                  final Directory tempDir =
                                      await getTemporaryDirectory();
                                  final String tempPath = tempDir.path;
                                  final File resizedFile =
                                      File('$tempPath/temp_image.jpg');
                                  await resizedFile.writeAsBytes(img.encodeJpg(
                                      resizedImage,
                                      quality: 80)); // Adjust quality as needed

                                  setState(() {
                                    _selectedImage = resizedFile;
                                  });
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Student photo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'JosefinSans',
                                  ),
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
                            if (_selectedImage == null) {
                              _photoValidate(context);
                            } else if (_formkey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                    ),
                                  );
                                },
                              );

                              Map<String, String> studentDetails = {
                                'name': nameController.text,
                                'email': emailController.text,
                                'phone': numberController.text,
                                'batch': batchController.text,
                                'id': primaryKey,
                                'date': dateString,
                                'time': timeString,
                              };
                              dbRef
                                  .add(studentDetails)
                                  .then((DocumentReference document) async {
                                final ref = FirebaseStorage.instance.ref().child(
                                    'studentPhoto/${DateTime.now()}$primaryKey.png');
                                await ref.putFile(_selectedImage!);
                                String imageUrl = await ref.getDownloadURL();
                                await document.update({'imageUrl': imageUrl});
                                try {
                                  // Send email with student ID
                                  await sendEmail(
                                      emailController.text, primaryKey);
                                } catch (error) {
                                  print('Error sending email: $error');
                                }
                                Navigator.of(context).pop();
                                _SuccessfullMessage(context);
                                nameController.text = "";
                                emailController.text = "";
                                numberController.text = "";
                                batchController.text = "";
                                setState(() {
                                  _selectedImage = null;
                                });
                              }).catchError((error) {
                                print("Failed to add student details: $error");
                              });
                            } else {
                              _formkey.currentState!.validate();
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
                                  'Registration',
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
      ),
    );
  }

  _emailNotValid(BuildContext context) {
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
                  'Please enter a valid Email',
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
                  'Student Registration Successfull',
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

  _phoneNumberValidate(BuildContext context) {
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
                  'Please enter a valid phone number',
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

  _batchValidate(BuildContext context) {
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
                  'Please enter a valid Year',
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

  _nameValidate(BuildContext context) {
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
                  'Please enter a valid name',
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

  _photoValidate(BuildContext context) {
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
                  'Please select a photo to upload',
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
