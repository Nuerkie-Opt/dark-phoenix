import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotusadmin/constants.dart';
import 'package:lotusadmin/models/user.dart';
import 'package:lotusadmin/screens/main/main_screen.dart';
import 'package:lotusadmin/services/auth.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset(
              "assets/images/logo_transparent.png",
            ),
            Center(
              child: Container(
                width: 500,
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null) return "Please enter email address";
                            return null;
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: obscurePassword ? Colors.white : Colors.blue,
                                  ))),
                          validator: (value) {
                            if (value == null) return "Please enter password";
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic user =
                                    await _auth.logIn(emailController.text, passwordController.text, context);
                                if (user != null) {
                                  var output = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                                  var value = output.data();
                                  User newUser = User.fromMap(value!);
                                  if (newUser.userType == "admin") {
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => MainScreen(user: newUser)));
                                  }
                                }
                              }
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: secondaryColor),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ));
  }
}
