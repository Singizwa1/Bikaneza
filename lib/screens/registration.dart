import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management/services/authentication.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  String _username = '', _email = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final Authentication _authService = Authentication();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _submitForm() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      // Final check
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      // Proceed with registration
      bool success = await _authService.register(
        _username,
        _email,
        _passwordController.text,
      );
if(!mounted)return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration successful! Please login."),
        ));
        Navigator.of(context).maybePop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration failed. Try again."),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SizedBox(
              width: 400,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: GoogleFonts.pacifico(
                        fontSize: 30,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Username
                    TextFormField(
                      decoration: _inputDecoration("Username"),
                      onSaved: (val) => _username = val ?? '',
                      validator: (val) => val == null || val.length < 3
                          ? 'Enter valid username'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Email
                    TextFormField(
                      decoration: _inputDecoration("Email"),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => _email = val ?? '',
                      validator: (val) => val == null || !val.contains('@')
                          ? 'Enter valid email'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: _inputDecoration("Create Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (val) => val == null || val.length < 8
                          ? 'Minimum 8 characters'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: _inputDecoration("Confirm Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: (val) =>
                          val != _passwordController.text
                              ? 'Passwords do not match'
                              : null,
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}