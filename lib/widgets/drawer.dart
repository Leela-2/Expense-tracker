import 'package:accounts/screens/emi.dart';
import 'package:accounts/screens/split.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/sign_up_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 246, 229).withOpacity(1),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 250, 229, 181),
                  const Color.fromARGB(255, 250, 229, 181).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.track_changes,
                  size: 60,
                  color: Colors.black54,
                ),
                SizedBox(width: 18),
                Text(
                  'More !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.receipt_sharp,
              size: 30,
              color: Colors.black54,
            ),
            title: const Text(
              'Splits',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Splits()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.back_hand,
              size: 30,
              color: Colors.black54,
            ),
            title: const Text(
              'EMI/Loans',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: Colors.black54,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EmiLoans()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.black54,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: Colors.black54,
              ),
            ),
            onTap: () async {
              await auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            },
          ),
        ],
      ),
    );
  }
}
