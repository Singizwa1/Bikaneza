import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management/navigationbar/bottom_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _obscurePassword = true;
  String _passwordStrengthMessage = '';
  Color _passwordStrengthColor = Colors.red;
  bool _rememberMe=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  ' Sign in to Bikaneza',
                  style: GoogleFonts.pacifico(
                    fontSize: 30,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
  
                      TextFormField(
                        decoration: InputDecoration(
                             labelText: 'Email',
                             filled: true,
                             fillColor:Colors.white,
                          
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                            
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => _email = val?.trim() ?? '',
                        validator: (val) => (val == null || !val.contains('@'))
                            ? 'Enter valid email'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
            
                             filled: true,
                             fillColor:Colors.white,
            
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                            
                          ),
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
                        onChanged: (val) {
                          _checkPasswordStrength(val);
                        },
                        onSaved: (val) => _password = val ?? '',
                        validator: (val) =>
                            (val == null || val.length < 8)
                                ? 'Enter valid password'
                                : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _passwordStrengthMessage,
                        style: TextStyle(color: _passwordStrengthColor),
                      ),
                    
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (val) {
                                  setState(() {
                                    _rememberMe = val ?? false;
                                  });
                                },
                              ),
                              Text(
                                'Remember me',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                           Navigator.pushReplacement(
                            context, 
                           MaterialPageRoute(builder:(context)=>BarScreen()),
                           );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.poppins(color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Sign Up now',
                        style: GoogleFonts.poppins(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),

            
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length < 8 ||
          !RegExp(r'(?=.*[0-9])').hasMatch(password)) {
        _passwordStrengthMessage = 'Weak (add numbers & more characters)';
        _passwordStrengthColor = Colors.red;
      }
       else {
        _passwordStrengthMessage = 'Strong password';
        _passwordStrengthColor = Colors.green;
      }
    });
  }
}
