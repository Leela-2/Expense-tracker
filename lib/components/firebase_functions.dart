import 'package:firebase_auth/firebase_auth.dart';
import 'package:accounts/screens/sign_up_screen.dart';

Future<void> signUp(
  FirebaseAuth auth,
  String email,
  String password,
) async {
  await auth.createUserWithEmailAndPassword(email: email, password: password);
  final user = <String, dynamic>{
    "user_name": userName.text,
  };
  await db.collection('user_email_to_username').doc(userEmail.text).set(user);

  await db
      .collection('users')
      .doc(userEmail.text)
      .collection('net_expenses')
      .doc('expense')
      .set({'amount': 0});
  await db
      .collection('users')
      .doc(userEmail.text)
      .collection('net_expenses')
      .doc('income')
      .set({'amount': 0});
  await db
      .collection('users')
      .doc(userEmail.text)
      .collection('net_expenses')
      .doc('balance')
      .set({'amount': 0});
  await db
      .collection('users')
      .doc(userEmail.text)
      .collection('net_expenses')
      .doc('expense')
      .set({'amount': 0});
  await db
      .collection('users')
      .doc(userEmail.text)
      .collection('transactions')
      .add({
    "amount": 0,
    "desc_short": "Food",
    "desc_long": "Sample Transaction",
    'is_spent': true,
    'date': date,
  });
}

Future<void> signIn(FirebaseAuth auth, String email, String password) async {
  await auth.signInWithEmailAndPassword(email: email, password: password);
}
