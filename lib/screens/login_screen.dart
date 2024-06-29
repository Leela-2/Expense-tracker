import 'package:accounts/screens/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:accounts/components/buttons.dart';
import 'package:accounts/components/text_form_field.dart';
import 'package:accounts/screens/home_page.dart';
import 'package:accounts/components/firebase_functions.dart';

TextEditingController userEmail = TextEditingController();
TextEditingController userPassword = TextEditingController();

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {

    final db = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E5),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 140,
            ),
            const SizedBox(
              height: 70,
            ),
            CustomTextFormField(
                controller: userEmail,
                hintText: "Enter Email",
                labelText: "Email",
                inputType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined),
            const SizedBox(
              height: 30,
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
            Button(
              text: "Login",
              action: () async {
                await signIn(auth, userEmail.text, userPassword.text);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account ?",
                    style: TextStyle(fontSize: 15)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    child: const Text("Sign Up !")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
