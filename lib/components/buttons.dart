import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String? text;
  Function? action;

  Button({super.key, this.text, this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 42,
        width: 194,
        child: ElevatedButton(
            onPressed: () {
              if (action != null) {
                action!();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.black,
              elevation: 3,
            ),
            child: Text(text!, style: const TextStyle(fontSize: 20))));
  }
}
