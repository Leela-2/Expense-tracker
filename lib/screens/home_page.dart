import 'package:accounts/components/transaction_widget.dart';
import 'package:accounts/screens/add_new_transaction.dart';
import 'package:accounts/screens/all_transactions_screen.dart';
import 'package:accounts/screens/profile.dart';
import 'package:accounts/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:accounts/components/constants.dart';

import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    updateValues();
    updateValuesIncome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;

    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    String email = auth.currentUser!.email!;

    int selectedIndex = 0;
    void _onItemTapped(int index) {
      if (index == 0) {
      } else if (index == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AllTransactionsPage()));
      } else if (index == 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StatisticsPage()));
      } else if (index == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                      child: Row(children: [
                        Expanded(
                            child: Text(date,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400))),
                        FutureBuilder(
                          future: db
                              .collection("user_email_to_username")
                              .doc(email)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!['user_name'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400));
                            } else {
                              return const Text("Loading",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400));
                            }
                          },
                        ),
                      ]),
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 40),
                    const Text("Account Balance",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    FutureBuilder(
                        future: db
                            .collection('users')
                            .doc(email)
                            .collection('net_expenses')
                            .doc('balance')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!['amount'].toString(),
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w700));
                          } else {
                            return const Text('Loading..',
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w700));
                          }
                        }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 80,
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A86B),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: FutureBuilder(
                                future: db
                                    .collection('users')
                                    .doc(email)
                                    .collection('net_expenses')
                                    .doc('income')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        textAlign: TextAlign.center,
                                        "Income \n${snapshot.data!['amount']}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white));
                                  } else {
                                    return const Text('Loading..',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white));
                                  }
                                }),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: FutureBuilder(
                                future: db
                                    .collection('users')
                                    .doc(email)
                                    .collection('net_expenses')
                                    .doc('expense')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        textAlign: TextAlign.center,
                                        "Expense \n${snapshot.data!['amount']}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white));
                                  } else {
                                    return const Text('Loading..',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white));
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                const Expanded(
                  child: Text("Today's Transactions",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AllTransactionsPage()));
                        },
                        child: const Text("View All",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)))),
              ],
            ),
            const Divider(color: Colors.black),
            SizedBox(
              height: 250.0,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Material(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(email)
                        .collection("transactions")
                        .where('date', isEqualTo: date)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return GestureDetector(
                              child: TransactionWidget(
                                isIncrease: !data['is_spent'],
                                specification: data['desc_short'],
                                amount: data['amount'],
                              ),
                              onTap: () {});
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFFF6E5),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewTransactions()));
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          foregroundColor: const Color.fromARGB(255, 7, 9, 7),
          backgroundColor: const Color.fromARGB(255, 250, 229, 181),
          title: const Text(
            'Hisaab',
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.currency_rupee_rounded),
            )
          ]),
      drawer: const MainDrawer(),
    );
  }
}
