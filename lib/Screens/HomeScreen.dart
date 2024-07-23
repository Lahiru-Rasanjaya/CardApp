import 'package:cardapp/Screens/AttendenceScreen.dart';
import 'package:cardapp/Screens/PaymentDetailsScreen.dart';
import 'package:cardapp/Screens/PaymentScreen.dart';
import 'package:cardapp/Screens/RegistrationScreen.dart';
import 'package:cardapp/Screens/StudentDetailsScreen.dart';
import 'package:cardapp/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  kAppbarColor,
        title: const Row(
          children: [
            Text('CardApp',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert,color: Colors.white,),
            onPressed: (){},
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: kWhiteColor,
          child: ListView(
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) => const Registration()),
                      );
                    },
                     child: Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 26.0),
                            child: Container(
                              alignment: Alignment.center,
                               height: 132.0,
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kbgColor, 
                                  boxShadow: kBoxShadow,        
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/registration.png'),   
                                    const Text('Student Registration',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JosefinSans',
                                      fontSize: 16.0
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                   ),
                  GestureDetector(
                    onTap: (){
                       Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) => const Payment()),
                      );
                    },
                     child: Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 26.0),
                            child: Container(
                              alignment: Alignment.center,
                               height: 132.0,
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kbgColor, 
                                  boxShadow: kBoxShadow,        
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/payment.png'),
                                    const Text('Payment of class fees',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JosefinSans',
                                      fontSize: 16.0
                                    ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                   ),
                  GestureDetector(
                    onTap: (){
                       Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) => const Attendance()),
                      );
                    },
                     child: Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 26.0),
                            child: Container(
                              alignment: Alignment.center,
                               height: 132.0,
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kbgColor, 
                                  boxShadow: kBoxShadow,        
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/Attendence.png'),
                                    const Text('Attendance Marking',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JosefinSans',
                                      fontSize: 16.0
                                    ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                   ),
                   GestureDetector(
                    onTap: (){
                           Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) => const studentDetails()),
                      );
                    },
                     child: Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 26.0),
                            child: Container(
                              alignment: Alignment.center,
                               height: 132.0,
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kbgColor, 
                                  boxShadow: kBoxShadow,        
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/StudentDetails.png'),
                                    const Text('Student Details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JosefinSans',
                                      fontSize: 16.0
                                    ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                   ),
                    GestureDetector(
                    onTap: (){
                           Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context) =>   const PaymentDetails()),
                      );
                    },
                     child: Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 26.0,bottom: 10.0),
                            child: Container(
                              alignment: Alignment.center,
                               height: 132.0,
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: kbgColor, 
                                  boxShadow: kBoxShadow,        
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/paymentDetails.png'),
                                    const Text('Payment Details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JosefinSans',
                                      fontSize: 16.0
                                    ),
                                    ),
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
    );
  }
}