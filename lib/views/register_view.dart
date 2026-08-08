import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // You created those text editing controller and you in charge of disposing of them
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),

      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: InputDecoration(hintText: 'Enter your email here'),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: InputDecoration(hintText: 'Enter your password here'),
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
          ),
          TextButton(
            onPressed: () async {
              final password = _password.text;
              final email = _email.text;

              // this function is future type so we awit it to let the function bring the results we want
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  devtools.log('Weak password');
                } else if (e.code == 'email-already-in-use') {
                  devtools.log('flafel');
                } else if (e.code == 'invalid-email') {
                  devtools.log('invalid email');
                }
              }
            },
            child: Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: const Text('Already have an account? Login here'),
          ),
        ],
      ),
    );
  }
}
