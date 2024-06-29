import 'dart:math';

import 'package:flutter/material.dart';
import 'package:accounts/components/text_form_field.dart';
import 'package:accounts/components/buttons.dart';

class EmiLoans extends StatefulWidget {
  const EmiLoans({super.key});

  @override
  State<EmiLoans> createState() => _EmiLoansState();
}

class _EmiLoansState extends State<EmiLoans> {
  TextEditingController transactionDescription = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController totalBill = TextEditingController();
  TextEditingController share = TextEditingController();
  TextEditingController contibution = TextEditingController();
  final TextEditingController _loanAmount = TextEditingController();
  final TextEditingController _annualInterestRate = TextEditingController();
  final TextEditingController _repaymentPeriod = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final db = FirebaseFirestore.instance;
    //DateTime dateToday = DateTime.now();
    //String date = dateToday.toString().substring(0, 10);
    // final auth = FirebaseAuth.instance;
    // String email = auth.currentUser!.email!;

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
            const SizedBox(
              height: 30,
            ),
            CustomTextFormField(
              controller: _loanAmount,
              labelText: "Loan Amount",
              hintText: "Enter Loan Amount",
              inputType: TextInputType.number,
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // CustomTextFormField(
            //   //controller: transactionDescription,
            //   controller: loanAmount,
            //   labelText: "Total bill",
            //   hintText: "Enter total bill",
            //   inputType: TextInputType.number,
            // ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              //controller: amount,
              controller: _annualInterestRate,
              hintText: "Enter annual interest rate",
              labelText: "Annual interest rate",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              //controller: transactionDescription,
              controller: _repaymentPeriod,
              labelText: "Number of monthly installments",
              hintText: "Enter the number of monthly installments",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
                text: "Continue",
                action: () {
                  double loanAmount =
                      double.parse(_loanAmount.text); // Loan amount
                  double annualInterestRate = double.parse(
                      _annualInterestRate.text); //Annual interest rate
                  int repaymentPeriod = int.parse(
                      _repaymentPeriod.text); // Repayment period in months
                  double monthlyInterestRate =
                      (annualInterestRate / 12) / 100; // Monthly interest rate
                  double calculateEMI(double loanAmount,
                      double monthlyInterestRate, int repaymentPeriod) {
                    double emi = loanAmount *
                        monthlyInterestRate *
                        pow(1 + monthlyInterestRate, repaymentPeriod) /
                        (pow(1 + monthlyInterestRate, repaymentPeriod) - 1);
                    return emi;
                  }

                  double emi = calculateEMI(
                      loanAmount, monthlyInterestRate, repaymentPeriod);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Calculated EMI'),
                        content: Text('The EMI comes out to be: $emi'),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 250, 228, 181)),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.black,
                                // backgroundColor:
                                //     Color.fromARGB(255, 255, 246, 229),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
