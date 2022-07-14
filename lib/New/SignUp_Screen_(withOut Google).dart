import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/New/Update_Profile_Detail.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Constants/Constants.dart';

class SignUpScreen_ extends StatefulWidget {
  @override
  State<SignUpScreen_> createState() => _SignUpScreen_State();
}

class _SignUpScreen_State extends State<SignUpScreen_> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  late String _user;

//! Google SignIn
  Future signInbyGOOGLE() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return log("NO");
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist = await _firestore
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();

    if (userExist.exists) {
      log("User already exists!😊");
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
    }
    
    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProfileScreen()));
    
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.width,
                width: size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/B2_1.png"),
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width / 4.87714,
                          bottom: size.height / 18.85285),
                      child: const Text(
                        "Create",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width / 4.87714, top: size.height / 40),
                      child: const Text(
                        "Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 13.82834,
                width: size.width / 1.17548,
                child: TextFormField(
                  cursorColor: kSecondaryColor,
                  controller: _email,
                  decoration: const InputDecoration(
                    focusColor: kSecondaryColor,
                    labelStyle: TextStyle(color: kSecondaryColor),
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.mail,
                      color: kSecondaryColor,
                    ),
                    prefixIconColor: kSecondaryColor,
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 82.97,
              ),
              SizedBox(
                height: size.height / 13.82834,
                width: size.width / 1.17548,
                child: TextFormField(
                  cursorColor: kSecondaryColor,
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(
                    focusColor: kSecondaryColor,
                    labelStyle: TextStyle(color: kSecondaryColor),
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.key,
                      color: kSecondaryColor,
                    ),
                    prefixIconColor: kSecondaryColor,
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 20.7425,
              ),
              //! new
              GestureDetector(
                onTap: () async {
                  //? Google SignUp
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _email.text, password: _password.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProfileScreen()));
                },
                child: Container(
                  height: size.height / 14,
                  width: size.width / 1.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kSecondaryColor),
                  alignment: Alignment.center,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 55.31334,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 30),
                      height: 1,
                      width: size.width / 3.425,
                      color: Colors.grey,
                    ),
                    const Text("Or"),
                    Container(
                      margin: const EdgeInsets.only(right: 30, left: 20),
                      height: 1,
                      width: size.width / 3.425,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 55.31334,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: size.height / 14,
                  width: size.width / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1.5, color: kSecondaryColor),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kSecondaryColor,
                        fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 82.94,
              ),
              ElevatedButton(
                onPressed: () async {
                  log("Button Pressed");
                  await signInbyGOOGLE();
                  log("Work Done!😍");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side:
                          const BorderSide(color: kSecondaryColor, width: 1.5),
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: size.height / 14,
                  width: size.width / 1.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                          "https://www.freepnglogos.com/uploads/google-logo-png/file-google-logo-svg-wikimedia-commons-23.png")
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 21.47,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
