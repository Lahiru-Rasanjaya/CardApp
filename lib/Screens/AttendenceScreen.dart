import 'package:cardapp/Screens/PaperScreen.dart';
import 'package:cardapp/Screens/RevisionScreen.dart';
import 'package:cardapp/Screens/TheoryScreen.dart';
import 'package:cardapp/constants.dart';
import 'package:flutter/material.dart';

class Attendance extends StatelessWidget {
  const Attendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor:  kAppbarColor,
        title: const Row(
          children: [
            Text('Attendance Marking',style: TextStyle(
              color: Colors.white,),
              ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          color: kWhiteColor,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: kBoxShadow,
                        ),
                   
                  child: Column(
                    children: [                     
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                              MaterialPageRoute(builder: (context) => const Theory()),
                              );
                            },
                             child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                       height: 132.0,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: kbgColor,      
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset('assets/T.png'),   
                                            const Text('Theory Class',
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
                              MaterialPageRoute(builder: (context) => const Paper()),
                              );
                            },
                             child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 26.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                       height: 132.0,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: kbgColor,      
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset('assets/P.png'),
                                            const Text('Paper Class',
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
                              MaterialPageRoute(builder: (context) => const Revision()),
                              );
                            },
                             child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 26.0,bottom: 26.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                       height: 132.0,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: kbgColor,        
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset('assets/R.png'),
                                            const Text('Revision Class',
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
            ],
          ),
        ),
      ),
    );
  }
}