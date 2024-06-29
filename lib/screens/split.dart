import 'package:flutter/material.dart';
import 'package:accounts/components/text_form_field.dart';
import 'package:accounts/components/buttons.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:accounts/components/constants.dart';

class Splits extends StatefulWidget {
  const Splits({super.key});

  @override
  State<Splits> createState() => _SplitsState();
}

class _SplitsState extends State<Splits> {
  TextEditingController transactionDescription = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController _totalBill = TextEditingController();
  TextEditingController _share = TextEditingController();
  TextEditingController _contibution = TextEditingController();
  String _category = "Food";

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);
    final auth = FirebaseAuth.instance;
    String email = auth.currentUser!.email!;

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
            const SizedBox(height: 20),
            DropdownButton(
              dropdownColor: const Color(0xFFFFF6E5),
              items: categories.map((String category) {
                return DropdownMenuItem(
                    value: category,
                    child: SizedBox(
                        width: 250,
                        child: Text(category,
                            style: const TextStyle(fontSize: 22))));
              }).toList(),
              onChanged: (newValue) {
                // do other stuff with _category
                setState(() => _category = newValue!);
              },
              value: _category,
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextFormField(
              controller: transactionDescription,
              labelText: "Description",
              hintText: "Enter description",
              inputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              //controller: transactionDescription,
              controller: _totalBill,
              labelText: "Total bill",
              hintText: "Enter total bill",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              //controller: amount,
              controller: _share,
              hintText: "Enter your share (in percentage)",
              labelText: "Share(in percentage)",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              //controller: transactionDescription,
              controller: _contibution,
              labelText: "Contribution",
              hintText: "Enter your contribution",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Continue",
              action: () async {
                int totalBill = int.parse(_totalBill.text);
                double share = double.parse(_share.text);
                int contribution = int.parse(_contibution.text);
                final int amount =
                    (contribution - ((share * totalBill) / 100.0)).toInt();
                if (amount >= 0) {
                  isSelected[0] = false;
                  isSelected[1] = true;
                } else {
                  isSelected[1] = false;
                  isSelected[0] = true;
                }

                final transaction = <String, dynamic>{
                  //"amount": int.parse(amount.text),
                  "amount": (amount).abs(),
                  "desc_short": _category,
                  "desc_long": transactionDescription.text,
                  'is_spent': isSelected[0],
                  'date': date,
                };
                await db
                    .collection("users")
                    .doc(email)
                    .collection("transactions")
                    .add(transaction);

                if (isSelected[0]) {
                  var netExpenseRef = db
                      .collection("users")
                      .doc(email)
                      .collection('net_expenses')
                      .doc('expense');
                  await netExpenseRef.update(
                    {"amount": FieldValue.increment((amount).abs())},
                  );
                  var netBalanceRef = db
                      .collection("users")
                      .doc(email)
                      .collection('net_expenses')
                      .doc('balance');
                  await netBalanceRef.update(
                    {
                      "amount": FieldValue.increment(-(amount).abs()),
                    },
                  );
                } else {
                  var netIncomeRef = db
                      .collection("users")
                      .doc(email)
                      .collection('net_expenses')
                      .doc('income');
                  var netBalanceRef = db
                      .collection("users")
                      .doc(email)
                      .collection('net_expenses')
                      .doc('balance');
                  await netIncomeRef.update(
                    {"amount": FieldValue.increment((amount).abs())},
                  );
                  await netBalanceRef.update(
                    {"amount": FieldValue.increment((amount).abs())},
                  );
                }
                resetValues();
                resetIncomeValues();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
