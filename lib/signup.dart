import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_aqua_01/LandingPage.dart';
import 'package:just_aqua_01/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignupPage(),
  ));
}

// ignore: must_be_immutable
class SignupPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black, // Set app bar color to black
        iconTheme: IconThemeData(
            color: const Color.fromARGB(
                255, 39, 37, 37)), // Set icon color to white
        actionsIconTheme:
            IconThemeData(color: const Color.fromARGB(255, 44, 42, 42)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white, // Set text color to white
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  inputFile(
                      label: "Username",
                      onChanged: (value) {
                        username = value;
                      }),
                  inputFile(
                      label: "Email",
                      onChanged: (value) {
                        email = value;
                      }),
                  inputFile(
                      label: "Password",
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      }),
                  inputFile(
                      label: "Confirm Password",
                      obscureText: true,
                      onChanged: (value) {
                        confirmPassword = value;
                      }),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async {
                    if (password == confirmPassword) {
                      // Passwords match, proceed with signup
                      try {
                        UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // Store additional user data in Firestore
                        await _firestore
                            .collection('users')
                            .doc(userCredential.user!.uid)
                            .set({
                          'username': username,
                          'email': email,
                        });

                        // Navigate to the login page or another screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingPage(),
                          ),
                        );
                      } catch (e) {
                        // Handle registration errors
                        print('Error during registration: $e');
                      }
                    } else {
                      // Passwords do not match, show an error or handle as needed
                      print('Passwords do not match');
                    }
                  },
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?",
                        style: TextStyle(
                            color: Colors.white)), // Set text color to white
                    Text(
                      " Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for text field
Widget inputFile({label, obscureText = false, onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.white, // Set text color to white
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        style: TextStyle(color: Colors.white), // Set text color to white
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(13), // Set border radius
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
