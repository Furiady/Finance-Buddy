import 'package:flutter/material.dart';
import 'package:front_end/components/form-component/view.dart';
import 'package:front_end/components/text-button-component/view.dart';
import 'package:front_end/components/wave-component/view.dart';
import 'package:front_end/pages/login/view.dart';
import 'package:front_end/pages/register/view-model.dart';
import 'package:front_end/constant/colors.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // Background container
          Container(
            height: size.height,
            decoration: BoxDecoration(gradient: blueNavyGradient),
          ),

          // Wave widget
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
            top: 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.25,
              color: Colors.white, // Make wave subtle
            ),
          ),

          // Header text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150.0, left: 35, right: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    Text(
                      'Create your BudgetBuddy account!',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Registration form and buttons
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Email field
                    FormComponent(
                      hintText: 'Email',
                      obscureText: false,
                      prefixIcon: const Icon(Icons.mail_outline),
                      controller: _viewModel.emailController,
                    ),
                    const SizedBox(height: 25),

                    // Username field
                    FormComponent(
                      hintText: 'Username',
                      obscureText: false,
                      prefixIcon: const Icon(Icons.person_outline),
                      controller: _viewModel.usernameController,
                    ),
                    const SizedBox(height: 25),

                    // Password field
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
                    const SizedBox(height: 30),

                    // Register button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue,
                      ),
                      child: TextButtonComponent(
                        text: 'Register',
                        textColor: Colors.white,
                        onPressed: () async {
                          await _viewModel.register(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Login button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account? Login here',
                        style: TextStyle(
                          color: blueNavyColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Image.asset(
                      "assets/moneytracing_person.png",
                      height: 250,
                      width: 250,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
