import 'package:flutter/material.dart';
import '../components/buttons.dart';
import 'package:accounts/components/text_form_field.dart';
import 'login_screen.dart';
import 'package:accounts/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:accounts/components/firebase_functions.dart';

final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
TextEditingController userEmail = TextEditingController();
TextEditingController userPassword = TextEditingController();
TextEditingController confirmUserPassword = TextEditingController();
TextEditingController userName = TextEditingController();
DateTime dateToday =DateTime.now();
String date = dateToday.toString().substring(0,10);

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E5),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 90,
            ),
            const SizedBox(
              height: 60,
            ),
            CustomTextFormField(
              controller: userName,
              hintText: "Enter User Name",
              labelText: "User Name",
              prefixIcon: Icons.person,
              inputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: userEmail,
              labelText: "Email",
              hintText: "Enter Email",
              prefixIcon: Icons.email_outlined,
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: userPassword,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.password),
                labelText: "Password",
                hintText: "Enter Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: confirmUserPassword,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.password),
                labelText: "Confirm Password",
                hintText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              text: "Sign Up",
              action: () async {
                await signUp(auth, userEmail.text, userPassword.text);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account ?", style: TextStyle(fontSize: 15)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()));
                    },
                    child: const Text("Sign In !")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
