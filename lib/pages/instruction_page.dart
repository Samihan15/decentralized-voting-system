import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voting_dapp/pages/registration_page.dart';
import 'package:voting_dapp/services/firebase_service.dart';
import 'package:voting_dapp/widgets/snackbar.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key}) : super(key: key);

  // const InstructionPage({super.key});

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  bool _isChecked = false;

  void toogleChecked(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error : ${snapshot.error}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final userData = snapshot.data?.data();
          if (userData?['agreed'] == true) {
            return const RegistrationPage();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Instruction Page',
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Instruction For Voters.",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "1.In registration phase provide your name, Aadhar card number, and Ethereum address (hex address) to register as a voter.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "2.Click the 'Register' button to submit your details.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "3.Wait for the admin to verify your registration.Once you are verified you are able to vote.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "4.During the voting phase, you can navigate to the 'Voting' section in the app.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "5.You will see a list of candidates along with their information (name, party, age, etc.).",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "6.To vote for a candidate, click on the 'Vote' button next to the candidate's name.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "7.A confirmation pop-up will appear, asking you to confirm your vote. Click 'Confirm' to cast your vote.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "8.Once you've voted, you cannot change your vote, so make sure to choose carefully.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "9.After the voting phase is over, the app will automatically move to the 'Results' section.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "10.You can view the winner and the number of votes they received in this section.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Important Notes !",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Only registered voters can participate in the voting process. If you haven't registered yet, you won't be able to vote.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Make sure to keep your Ethereum address (hex address) and private key secure and do not share it with anyone. This is essential for authentication purposes during the registration process.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "The voting app will adhere to the specified phases, and you won't be able to register or vote outside the designated phase.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Ensure that you have a stable internet connection while using the app to ensure a smooth voting experience.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Confirm if you read all the instructions",
                            style: TextStyle(fontSize: 18),
                          ),
                          Checkbox(
                            value: _isChecked,
                            onChanged: toogleChecked,
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              !_isChecked ? Colors.grey : Colors.deepPurple),
                        ),
                        onPressed: () async {
                          if (_isChecked) {
                            final response = await setAgreed();
                            if (response == true) {
                              Navigator.pushReplacementNamed(
                                  context, '/registration');
                              showSnackBar(context,
                                  'Thank you for reading the instructions carefully !');
                            } else {
                              showSnackBar(context, 'Something wrong happened');
                            }
                          } else {
                            showSnackBar(context, 'Please check the box');
                          }
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
