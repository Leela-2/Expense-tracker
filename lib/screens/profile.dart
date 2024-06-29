import 'package:accounts/components/buttons.dart';
import 'package:accounts/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;

    String email = auth.currentUser!.email!;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E5),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: CircleAvatar(
                    radius: 65.0,
                    child: Icon(Icons.person, size : 80),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: db
                          .collection('user_email_to_username')
                          .doc(email)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!['user_name'],
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700));
                        } else {
                          return const Text("Loading...",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700));
                        }
                      }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0, 0.0),
              child: Button(
                text: 'Logout',
                action: () async {
                  await auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const MyApp()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
