import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var optionsForTransactions = ["This Week", "This Month", "This Year"];
DateTime dateToday = DateTime.now();

DateTime firstDayOfWeek(DateTime date) =>
    DateTime(date.year, date.month, date.day - date.weekday % 7);

DateTime firstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

DateTime firstDayOfYear(DateTime date) {
  return DateTime(date.year, 1, 1);
}

String toDate(DateTime dateToday) {
  String date = dateToday.toString().substring(0, 10);
  return date;
}

Map<String, String> greaterThanDates = {
  "This Week": toDate(firstDayOfWeek(dateToday)),
  "This Month": toDate(firstDayOfMonth(dateToday)),
  "This Year": toDate(firstDayOfYear(dateToday)),
};

const List<Widget> options = <Widget>[
  Padding(
    padding: EdgeInsets.all(8.0),
    child: Text("Expense",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: Colors.red)),
  ),
  Padding(
    padding: EdgeInsets.all(8.0),
    child: Text("Income",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: Colors.green)),
  )
];

List<bool> isSelected = <bool>[
  false,
  false,
];

var categories = [
  "Food",
  "Transport",
  "Personal",
  "Shopping",
  "Medical",
  "Rent",
  "Movie",
  "Salary"
];

void resetValues() {
  for (var category in categories) {
    categoryWiseExpense[category] = 0.0;
  }
}

void resetIncomeValues() {
  for (var category in categories) {
    categoryWiseIncome[category] = 0.0;
  }
}

Map<String, double> categoryWiseExpense = {
  "Food": 0.0,
  "Transport": 0.0,
  "Personal": 0.0,
  "Shopping": 0.0,
  "Medical": 0.0,
  "Rent": 0.0,
  "Movie": 0.0,
  "Salary": 0.0,
};

Map<String, double> categoryWiseIncome = {
  "Food": 0.0,
  "Transport": 0.0,
  "Personal": 0.0,
  "Shopping": 0.0,
  "Medical": 0.0,
  "Rent": 0.0,
  "Movie": 0.0,
  "Salary": 0.0,
};

void updateValueHelper() async {
  await updateValues();
}

Future<void> updateValues() async {
  final auth = FirebaseAuth.instance;
  String email = auth.currentUser!.email!;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection("transactions")
      .where('is_spent', isEqualTo: true)
      .get()
      .then(
    (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        categoryWiseExpense[docSnapshot['desc_short']] =
            (categoryWiseExpense[docSnapshot['desc_short']]! +
                docSnapshot['amount']);
      }
    },
  );
}

Future<void> updateValuesIncome() async {
  final auth = FirebaseAuth.instance;
  String email = auth.currentUser!.email!;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection("transactions")
      .where('is_spent', isEqualTo: false)
      .get()
      .then(
    (querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        categoryWiseIncome[docSnapshot['desc_short']] =
            (categoryWiseIncome[docSnapshot['desc_short']]! +
                docSnapshot['amount']);
      }
    },
  );
}
