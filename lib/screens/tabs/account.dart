import 'package:flutter/material.dart';
import 'package:lun/components/textfield.dart';
import 'package:lun/components/button.dart';
import 'package:lun/services/auth_service.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Account(),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class Account extends StatefulWidget {
  const Account({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map<String, dynamic>? userData;

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
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? data = await AuthService().getUserData();
    setState(() {
      userData = data;
      controllers[0].text = userData != null ? userData!['name']! : "";
      controllers[1].text = userData != null ? userData!['email']! : "";
      controllers[2].text = userData != null ? userData!['age']! : "";
      controllers[3].text = userData != null ? userData!['about']! : "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
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
                label: "Email",
                enabled: false,
              ),
              const SizedBox(height: 16),
              InputText(
                controller: controllers[2],
                hintText: "Type your age",
                fontSize: 14,
                label: "Age",
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              InputText(
                controller: controllers[3],
                hintText: "I am women productive",
                fontSize: 14,
                label: "About Your Self",
                maxLines: 3,
                inputType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              Button(
                text: 'Update',
                width: double.infinity,
                onPressed: () async {
                  await AuthService().updateUser(
                      name: controllers[0].text,
                      email: controllers[1].text,
                      age: controllers[2].text,
                      about: controllers[3].text);
                },
              ),
              const SizedBox(height: 16),
              Button(
                text: 'Signout',
                backgroundColor: Colors.white,
                width: double.infinity,
                textColor: Colors.black54,
                onPressed: () {
                  AuthService().signout(context: context);
                },
              ),
            ],
          )),
    );
  }
}
