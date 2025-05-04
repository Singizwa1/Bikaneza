import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management/screens/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
backgroundColor: Colors.black12,     
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          // Center everything vertically
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // "Logo" text centered
            Text(
              "BikaNeza",
              textAlign: TextAlign.center,
              style: GoogleFonts.pacifico(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),

            const SizedBox(height: 40),

            // Subtext
            Text(
              "Keep your stock under control.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.deepOrangeAccent,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 60),

            // Get Started button
            InkWell(
              onTap: () {
                 Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
    );
              
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.pacifico(
                    color: Colors.deepOrangeAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
