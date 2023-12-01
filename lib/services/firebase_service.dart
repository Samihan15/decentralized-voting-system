import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voting_dapp/utils/shared_prefs.dart';

User? user = FirebaseAuth.instance.currentUser;

Future<void> loginFunction(String email, String password) async {
  try {
    final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    print(e.message);
  }
}

Future<String?> signUpFunction(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return credential.user?.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    } else {
      return e.toString();
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String?> storeUserData(
    String userId, String name, String walletAddress, int aadharCard) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': name,
      'wallet_address': walletAddress,
      'aadhar_card': aadharCard,
      'agreed': false,
    });

    return 'success';
  } on FirebaseException catch (e) {
    // Handle Firestore errors if needed
    print("Error storing user data: $e");
    return e.toString();
  }
}

Future<bool> setAgreed() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not signed in, handle this case if needed
      return false;
    }

    final String? docId = user.uid;
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(docId);
    await documentReference.update({'agreed': true});

    return true;
  } on FirebaseException catch (e) {
    print(e.message);
    return false;
  }
}

Future<Object?> getData() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    final DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = documentSnapshot.data();
    return data;
  } on FirebaseException catch (e) {
    print(e.message);
  }
  return null;
}

Future<void> logout() async {
  final auth = FirebaseAuth.instance;
  await auth.signOut();
  await SharedPref().removeData();
  
}
