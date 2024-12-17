import 'package:flutter/material.dart';
import 'package:front_end/components/form-component/view.dart';
import 'package:front_end/components/text-button-component/view.dart';
import 'package:front_end/components/wave-component/view.dart';
import 'package:front_end/pages/login/view.dart';
import 'package:front_end/pages/register/view-model.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final RegisterViewModel _viewModel = RegisterViewModel();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height - 200,
            color: Colors.blue,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.0,
              color: Colors.white,
            ),
          ),
          const Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FormComponent(
                  hintText: 'Email',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.mail_outline),
                  controller: _viewModel.emailController,
                ),
                FormComponent(
                  hintText: 'Username',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.person_outline),
                  controller: _viewModel.usernameController
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FormComponent(
                      hintText: 'Password',
                      obscureText: !isPasswordVisible,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      controller: _viewModel.passwordController,
                    ),
                  ],
                ),
                TextButtonComponent(
                  text: 'Register',
                  onPressed: () async {
                    await _viewModel.register(context);
                  },
                ),
                TextButtonComponent(
                  text: 'Login',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Login()
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
