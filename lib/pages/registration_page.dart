import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting_dapp/services/firebase_service.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:voting_dapp/utils/shared_prefs.dart';
import 'package:voting_dapp/widgets/drawer.dart';
import 'package:web3dart/web3dart.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  // const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formkey = GlobalKey<FormState>();
  bool verified = false;
  String? private;

  @override
  void initState() {
    super.initState();
    fetchPrivateKey();
    checkVoterVerification();
  }

  Future<void> fetchPrivateKey() async {
    final privateKey = await SharedPref().getPrivateKey();
    setState(() {
      private = privateKey;
      voterPrivateKey = privateKey;
    });

    getCandidateList();
  }

  Future<void> checkVoterVerification() async {
    final user = FirebaseAuth.instance;
    final users = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.currentUser!.uid)
        .get();
    final check = await isVoterAllow(
        ethClient, EthereumAddress.fromHex(users['wallet_address']));

    print(check);
    setState(() {
      verified = check!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error ${snapshot.error}',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final Map<String, dynamic>? userData =
                snapshot.data as Map<String, dynamic>?;

            if (userData == null) {
              return const Center(child: Text('No user data found !'));
            } else {
              return Form(
                key: _formkey,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Welcome,',
                            style: TextStyle(fontSize: 35),
                            softWrap: true,
                          ),
                          Text(
                            userData['name'].split(' ')[0],
                            style: TextStyle(fontSize: 35),
                            softWrap: true,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Voter Name : ${userData['name']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Voter Aadhar Card: ${userData['aadhar_card']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Wallet Address: ${userData['wallet_address']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      private == null
                          ? const SizedBox(
                              height: 30,
                            )
                          : Center(
                              child: Text(
                                "Private key: $private!",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                      Text(
                        !verified
                            ? "Your information is verifying.Once it gets verified then you will able to vote"
                            : "Your information has been verified.Now, you're able to vote !",
                        style: TextStyle(
                            color: !verified ? Colors.red : Colors.green,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
      drawer: const MyDrawer(),
    );
  }
}
