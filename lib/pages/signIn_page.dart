import 'package:flutter/material.dart';
import 'package:voting_dapp/services/firebase_service.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:voting_dapp/utils/shared_prefs.dart';
import 'package:voting_dapp/widgets/snackbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  // const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _aadharController = TextEditingController();
  final _walletController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _privateKeyController = TextEditingController();
  bool _obsecureText = true;

  void toogleButton() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _aadharController.dispose();
    _walletController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _privateKeyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Welcome Voters !',
                  style: TextStyle(fontSize: 20),
                  textScaleFactor: 1.2,
                ),
                const SizedBox(
                  height: 50,
                ),
                // Voter Name
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name should not be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Voter Name',
                    hintText: 'Enter Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // AadharCard
                TextFormField(
                  controller: _aadharController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Aadhar number should not be empty";
                    } else if (value.length != 12) {
                      return "Enter Valid Aadhar Number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Voter AadharCard',
                    hintText: 'Enter Your Aadhar Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ), // wallet Address
                TextFormField(
                  controller: _walletController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Address should not be empty";
                    } else if (value.length != 42) {
                      return "Enter Valid Wallet Address";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Wallet Address',
                    hintText: 'Enter Your Wallet Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // private key
                TextFormField(
                  controller: _privateKeyController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Private Key should not be empty";
                    } else if (value.length != 64) {
                      return "Enter Valid Private Key";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Private key',
                    hintText: 'Enter Your private key',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // email
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email should not be empty";
                    } else if (!value.contains("@gmail.com")) {
                      return "Enter Valid Email";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // password
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password should not be empty";
                    } else if (value.length < 6) {
                      return "Password length should be 6 or more";
                    }
                    return null;
                  },
                  obscureText: _obsecureText,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            toogleButton();
                          },
                          icon: Icon(!_obsecureText
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
                // elevated button Login
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        int textValue = int.parse(_aadharController.text);

                        var response = await signUpFunction(
                            _emailController.text.trim(),
                            _passwordController.text.trim());

                        var response1 = await storeUserData(
                            response.toString(),
                            _nameController.text.trim(),
                            _walletController.text.trim(),
                            int.parse(_aadharController.text));

                        setState(() {
                          voterPrivateKey = _privateKeyController.text;
                        });

                        await SharedPref()
                            .savePrivateKey(_privateKeyController.text.trim());

                        await registerVoter(
                            ethClient, _nameController.text.trim(), textValue);

                        showSnackBar(context, response1.toString());
                        if (response1 == 'success') {
                          Navigator.pushNamed(context, '/instruction');
                        }
                      } else {
                        showSnackBar(context, 'Failed to load');
                      }
                    },
                    child: const Text(
                      "SignIn",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have account ?",
                        style: TextStyle(fontSize: 18)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('LogIn here !',
                          style: TextStyle(fontSize: 18)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
