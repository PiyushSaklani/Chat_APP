import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/New/Setup_ProfilePic.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Constants/Constants.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  late String _user;
  late String _email;
  late String _imageURL;

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
                height: size.width / 1.3,
                width: size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/B3.png"),
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width / 5.87714,
                          bottom: size.height / 5.85285),
                      child: const Text(
                        "Setup your",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width / 5.87714, bottom: size.height / 12),
                      child: const Text(
                        "Profile",
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
                height: size.height / 20.97,
              ),
              SizedBox(
                height: size.height / 13.82834,
                width: size.width / 1.17548,
                child: TextFormField(
                  cursorColor: kSecondaryColor,
                  controller: _name,
                  decoration: const InputDecoration(
                    focusColor: kSecondaryColor,
                    labelStyle: TextStyle(color: kSecondaryColor),
                    labelText: "Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: kSecondaryColor,
                    ),
                    prefixIconColor: kSecondaryColor,
                    hintText: "Name",
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
                  controller: _nickname,
                  decoration: const InputDecoration(
                    focusColor: kSecondaryColor,
                    labelStyle: TextStyle(color: kSecondaryColor),
                    labelText: "Nickname",
                    prefixIcon: Icon(
                      Icons.face,
                      color: kSecondaryColor,
                    ),
                    prefixIconColor: kSecondaryColor,
                    hintText: "Nikename",
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
                  controller: _dob,
                  decoration: const InputDecoration(
                    focusColor: kSecondaryColor,
                    labelStyle: TextStyle(color: kSecondaryColor),
                    labelText: "DOB",
                    prefixIcon: Icon(
                      Icons.cake,
                      color: kSecondaryColor,
                    ),
                    prefixIconColor: kSecondaryColor,
                    hintText: "DOB",
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
                  controller: _gender,
                  decoration: const InputDecoration(
                    focusColor: kSecondaryColor,
                    labelStyle: TextStyle(color: kSecondaryColor),
                    labelText: "Gender",
                    prefixIcon: Icon(
                      Icons.people,
                      color: kSecondaryColor,
                    ),
                    prefixIconColor: kSecondaryColor,
                    hintText: "Gender",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 8.7425,
              ),
              //! new
              GestureDetector(
                onTap: () async {
                  //?
                  await FirebaseFirestore.instance
                      .collection("users")
                      .where("nickname", isEqualTo: _nickname.text)
                      .get()
                      .then((value) async {
                    if (value.docs.isEmpty) {
                      FirebaseAuth.instance.authStateChanges().listen(
                        (User? user) {
                          if (user != null) {
                            log(user.uid);
                            _user = user.uid;
                            _email = user.email!;
                            _imageURL = user.photoURL!;
                          }
                        },
                      );
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(_user)
                          .set({
                        "name": _name.text,
                        "date": DateTime.now(),
                        "nickname": _nickname.text,
                        "dob": _dob.text,
                        "gender": _gender.text,
                        "email": _email,
                        "uid": _user,
                        "image":
                            "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=20&m=1223671392&s=612x612&w=0&h=lGpj2vWAI3WUT1JeJWm1PRoHT3V15_1pdcTn2szdwQ0=",
                      });
                      log("work done");
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePicScreen()));
                      return;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Nickname already taken."),
                        ),
                      );
                    }
                  });
                },
                child: Container(
                  height: size.height / 14,
                  width: size.width / 2.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kSecondaryColor),
                  alignment: Alignment.center,
                  child: const Text(
                    "Next",
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
              SizedBox(
                height: size.height / 25.47,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
