import 'package:flutter/material.dart';
import 'package:lun/components/button.dart';
import 'package:lun/components/button_icon.dart';
import 'package:lun/components/textfield.dart';
import 'package:lun/screens/signin.dart';

import '../services/auth_service.dart';

class Register extends StatelessWidget {
  Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: RegisterPage(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

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
                Row(
                  children: [
                    ButtonIcon(
                        iconData: Icons.chevron_left,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => Signin()));
                        }),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text('Sign Up',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(238, 136, 185, 1),
                        ))
                  ],
                ),
                const SizedBox(height: 72),
                InputText(
                    controller: controllers[0],
                    hintText: "Type your name",
                    fontSize: 14,
                    label: "Name"),
                const SizedBox(height: 16),
                InputText(
                    controller: controllers[1],
                    hintText: "Type your username or email",
                    fontSize: 14,
                    label: "Email"),
                const SizedBox(height: 16),
                InputText(
                    controller: controllers[2],
                    hintText: "Type your password",
                    obsecureText: true,
                    fontSize: 14,
                    label: "Password"),
                const SizedBox(height: 16),
                InputText(
                  controller: controllers[3],
                  hintText: "Type your age",
                  fontSize: 14,
                  label: "Age",
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                InputText(
                  controller: controllers[4],
                  hintText: "I am women productive",
                  fontSize: 14,
                  label: "About Your Self",
                  maxLines: 3,
                  inputType: TextInputType.multiline,
                ),
                const SizedBox(height: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Button(
                      text: 'Register',
                      width: double.infinity,
                      onPressed: () async {
                        await AuthService().signup(
                            name: controllers[0].text,
                            email: controllers[1].text,
                            password: controllers[2].text,
                            age: controllers[3].text,
                            about: controllers[4].text,
                            context: context
                          );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Text('Already have an account?',
                        style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => Signin()));
                      },
                      child: const Text('Signin',
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
