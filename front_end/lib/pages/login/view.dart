import 'package:flutter/material.dart';
import 'package:front_end/components/form-component/view.dart';
import 'package:front_end/components/text-button-component/view.dart';
import 'package:front_end/components/wave-component/view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isEmailValid = false;
  bool isPasswordVisible = false;

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
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login',
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
                  suffixIcon: isEmailValid ? const Icon(Icons.check) : null,
                  onChanged: (value) {
                    setState(() {
                      isEmailValid = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}",
                      ).hasMatch(value);
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
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
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      onChanged: (value) {
                        // Handle password changes if needed
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextButtonComponent(
                  text: 'Login',
                  onPressed: () {},
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextButtonComponent(
                  text: 'Sign Up',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
