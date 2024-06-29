import 'package:flutter/material.dart';

class TransactionWidget extends StatelessWidget {
  bool? isIncrease;
  int? amount;
  String? specification;

  TransactionWidget(
      {super.key, required this.isIncrease,
      required this.amount,
      required this.specification});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: isIncrease!
            ? const Icon(Icons.arrow_circle_up, color: Colors.green)
            : const Icon(Icons.arrow_circle_down, color: Colors.red),
        title: Text(amount!.toString()),
        subtitle: Text(specification!),
      ),
    );
  }
}

class TransactionDetail extends StatelessWidget {
  bool? isSpent;
  int? amount;
  String? specification;
  String? detail;
  String? date;

  TransactionDetail(
      {super.key, required this.isSpent,
      required this.amount,
      required this.specification,
      required this.detail,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(specification!),
        subtitle: Text(detail!),
        trailing: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: amount.toString(),
                  style:
                      TextStyle(color: isSpent! ? Colors.red : Colors.green)),
              TextSpan(text: '\n\n${date!}'),
            ],
          ),
        ),
      ),
    );
  }
}
