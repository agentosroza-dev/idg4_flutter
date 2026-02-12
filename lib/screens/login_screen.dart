import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/student_logic.dart';
import '../logics/user_logic.dart';
import '../services/user_service.dart';
import '../utils/my_message.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  final _formKey = GlobalKey<FormState>();

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 8),
                _buildEmailTextField(),
                SizedBox(height: 8),
                _buildPasswordTextField(),
                SizedBox(height: 8),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final pic1 =
      "https://static.wikia.nocookie.net/marvel_dc/images/a/a2/Batman_Vol_3_124_Textless.jpg/revision/latest?cb=20220608034122";

  Widget _buildLogo() {
    return CircleAvatar(
      radius: 64,
      backgroundImage: CachedNetworkImageProvider(pic1),
    );
  }

  final _emailCtrl = TextEditingController();

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _emailCtrl,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: "Enter Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (text) {
        if (text!.isEmpty) {
          return "Please fill in the Email.";
        }

        if (EmailValidator.validate(text) == false) {
          return "Email format is incorrect.";
        }

        return null; // no error
      },
    );
  }

  bool _hidePassword = true;
  final _passCtrl = TextEditingController();

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passCtrl,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: "Enter Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: _hidePassword,
      keyboardType: TextInputType.text,
      validator: (text) {
        if (text!.isEmpty) {
          return "Please fill in the Password.";
        }
        if (text!.length < 6) {
          return "Password must be at least 6 characters.";
        }
        return null; // no error
      },
    );
  }

  final _service = UserService();

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.maxFinite,
      child: FilledButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _service
                .login(_emailCtrl.text.trim(), _passCtrl.text)
                .then((successUser) async {
                  await context.read<UserLogic>().saveUser(successUser);
                  await context.read<StudentLogic>().readStudents(context);
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => MainScreen()));
                })
                .onError((e, s) {
                  debugPrint(e.toString());
                  MyMessage(context, "Login Failed");
                });
          }
        },
        child: Text("LOGIN"),
      ),
    );
  }
}
