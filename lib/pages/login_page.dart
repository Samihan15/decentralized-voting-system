import 'package:flutter/material.dart';
import 'package:voting_dapp/services/firebase_service.dart';
import 'package:voting_dapp/utils/shared_prefs.dart';
import 'package:voting_dapp/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  // const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  bool _obsecureText = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _privateKey = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
    _privateKey.dispose();
  }

  void toogleButton() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Material(
            child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome Again Voters !',
                style: TextStyle(fontSize: 20),
                textScaleFactor: 1.2,
              ),
              const SizedBox(
                height: 50,
              ),
              // private key
              TextFormField(
                controller: _privateKey,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Private key should not be empty';
                  } else if (value.length != 64) {
                    return 'Enter valid private key';
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
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email should not be empty';
                  } else if (!value.contains('@gmail.com')) {
                    return 'Enter valid email';
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
                controller: _password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password lenght should be 6 or more';
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
                      if (_email.text.isEmpty &&
                          _password.text.isEmpty &&
                          _privateKey.text.isEmpty) {
                        print('Null');
                      } else {
                        try {
                          await SharedPref()
                              .savePrivateKey(_privateKey.text.trim());

                          await loginFunction(
                              _email.text.trim(), _password.text.trim());
                          showSnackBar(context, 'Login Successfuly');
                        } catch (e) {
                          showSnackBar(context, 'Error while logging in');
                        }
                      }
                    }
                  },
                  child: const Text(
                    "Login",
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
                  const Text("Don't have account ?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/singIn');
                    },
                    child: const Text('Sign Up here !',
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}


// 0x5D738CE78ded0505122Fc90d1e1108Cc1D65300D