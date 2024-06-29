import 'package:flutter/material.dart';
import 'package:accounts/components/text_form_field.dart';
import 'package:accounts/components/buttons.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:accounts/components/constants.dart';

class NewTransactions extends StatefulWidget {
  const NewTransactions({super.key});

  @override
  State<NewTransactions> createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {

  TextEditingController transactionDescription = TextEditingController();
  TextEditingController amount = TextEditingController();
  String _category = "Food";


  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    DateTime dateToday =DateTime.now();
    String date = dateToday.toString().substring(0,10);
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
                    child: SizedBox(width: 250,child: Text(category, style: const TextStyle(fontSize: 22)))
                );
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
              hintText: "Enter Description",
              inputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: amount,
              hintText: "Enter Amount",
              labelText: "Amount",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            ToggleButtons(
              isSelected: isSelected,
              selectedColor: Colors.black,
              splashColor: Colors.white,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              children: options,
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              text: "Continue",
              action: () async {
                final transaction = <String, dynamic>{
                  "amount": int.parse(amount.text),
                  "desc_short": _category,
                  "desc_long": transactionDescription.text,
                  'is_spent' : isSelected[0],
                  'date' : date,
                };
                await db.collection("users").doc(email).collection("transactions").add(transaction);

                if(isSelected[0]) {
                  var netExpenseRef = db.collection("users").doc(email).collection('net_expenses').doc(
                      'expense');
                  await netExpenseRef.update(
                    {"amount": FieldValue.increment(double.parse(amount.text))},
                  );
                  var netBalanceRef = db.collection("users").doc(email).collection('net_expenses').doc('balance');
                  await netBalanceRef.update( {"amount": FieldValue.increment(-double.parse(amount.text))},);
                }else{
                  var netIncomeRef = db.collection("users").doc(email).collection('net_expenses').doc(
                      'income');
                  var netBalanceRef = db.collection("users").doc(email).collection('net_expenses').doc('balance');
                  await netIncomeRef.update(
                    {"amount": FieldValue.increment(double.parse(amount.text))},
                  );
                  await netBalanceRef.update( {"amount": FieldValue.increment(double.parse(amount.text))},);
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
