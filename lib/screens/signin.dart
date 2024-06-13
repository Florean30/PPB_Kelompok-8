import 'package:flutter/material.dart';
import 'package:lun/components/button.dart';
import 'package:lun/components/textfield.dart';
import 'package:lun/screens/register.dart';

import '../services/auth_service.dart';

class Signin extends StatelessWidget {
  Signin({super.key});

  final userControl = TextEditingController();
  final passControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 72),
                const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('images/icon.png'),
                      Text('Login',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(238, 136, 185, 1))),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                InputText(
                    controller: userControl,
                    hintText: "Type your username or email",
                    obsecureText: false,
                    fontSize: 14,
                    label: "Email"),
                const SizedBox(height: 16),
                InputText(
                    controller: passControl,
                    hintText: "Type your password",
                    obsecureText: true,
                    fontSize: 14,
                    label: "Password"),
                const SizedBox(height: 16),
                const Text('Forget Password?',
                    style: TextStyle(
                        fontSize: 14, decoration: TextDecoration.underline)),
                const SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Button(
                      text: 'Login',
                      width: double.infinity,
                      onPressed: () async {
                        await AuthService().signin(
                            email: userControl.text,
                            password: passControl.text,
                            context: context);
                      },
                    ),
                    // const SizedBox(height: 16),
                    // const Text('OR',
                    //     style: TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.grey)),
                    // const SizedBox(height: 16),
                    // Button(
                    //   text: 'Login with Google',
                    //   width: double.infinity,
                    //   backgroundColor: Colors.white,
                    //   textColor: Colors.black,
                    //   onPressed: () async {},
                    // ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Text('Don’t have an account?',
                        style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => Register()));
                      },
                      child: const Text('Sign Up',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(238, 136, 185, 1),
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
