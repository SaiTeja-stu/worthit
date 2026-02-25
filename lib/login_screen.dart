import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'bottom_nav_screen.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;
  
  // OTP States
  bool isOtpSent = false;
  String? serverGeneratedOTP;

  final Color primaryYellow = const Color(0xFFFFD700);
  final Color accentOrange = const Color(0xFFFF4500);
  final Color brandDark = const Color(0xFF1A1A1A);

  String _maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) {
      return "${name[0]}***@$domain";
    }
    return "${name.substring(0, 2)}${'*' * 8}${name.substring(name.length - 1)}@$domain";
  }

  Future<void> _sendOTP(String recipientEmail) async {
    setState(() => isLoading = true);
    try {
      try {
        final userQuery = await FirebaseFirestore.instance.collection('users')
            .where('email', isEqualTo: recipientEmail).limit(1).get();
            
        if (userQuery.docs.isEmpty) {
          if (!mounted) return;
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("User not existed. Please create an account first!"), 
            backgroundColor: Colors.red
          ));
          return;
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Database Error: Could not verify user. [cloud_firestore/permission-denied] Missing or insufficient permissions."), 
          backgroundColor: Colors.red
        ));
        return;
      }

      // 1. Generate 6-digit OTP
      final random = Random();
      serverGeneratedOTP = (100000 + random.nextInt(900000)).toString();

      // 2. Effortless Native SMTP Delivery! Try to send securely via Gmail SMTP on mobile apps.
      //    This removes the need for checking localhost/backend node servers!
      bool emailActuallySent = false;
      try {
        if (!kIsWeb) {
            String username = 'saitejagadu21@gmail.com'; 
            String password = 'jzxngsgijebmfdoe';    
            final smtpServer = gmail(username, password); 

            final message = Message()
              ..from = Address(username, 'WorthIt App')
              ..recipients.add(recipientEmail)
              ..subject = 'Your WorthIt Login OTP'
              ..text = '''Your WorthIt Login One-Time Password (OTP) is $serverGeneratedOTP
Use the verification code sent in this email to securely access your account. This code is valid for a limited time to ensure your safety and privacy.Do not share this code.''';

            await send(message, smtpServer);
            emailActuallySent = true;
        } else {
            final response = await http.post(
              Uri.parse('http://127.0.0.1:3000/'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'to': recipientEmail, 'otp': serverGeneratedOTP}),
            );
            if (response.statusCode == 200 || response.statusCode == 201) {
              emailActuallySent = true;
            } else {
              throw Exception("Local email server responded with error: ${response.statusCode}");
            }
        }
      } catch (e) {
          print("Email Engine Error: $e");
          throw Exception("Could not connect to email server. Did you run local_email_server.dart?");
      }
      
      setState(() => isOtpSent = true);
      final maskedEmail = _maskEmail(recipientEmail);
      
      // If deployed without SMTP server or fails, we unblock the user by printing OTP
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("OTP Sent to $maskedEmail"), 
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
      ));
    } catch (e) {
      print("System Flow Failed: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Service Failed. Reason: $e", style: const TextStyle(color: Colors.white)), 
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      // Evaluate OTP Flow if OTP has been sent
      if (isOtpSent) {
         if (_otpController.text.trim() == serverGeneratedOTP) {
            // Successfully validated OTP via custom SMTP
            print("OTP Verify Success");
         } else {
            throw Exception("Invalid OTP. Please try again.");
         }
      } else {
        // You can leave fallback standard password login here or force OTP
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
      );
    } catch (e) {
      if (mounted) {
        String msg = e.toString();
        if (e is FirebaseAuthException) msg = e.message ?? e.code;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryYellow,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFFF9E0), primaryYellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              // TOP HALF: Branding & Illustrations
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 32),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background icons
                          Positioned(
                            top: 16,
                            left: 40,
                            child: Opacity(
                              opacity: 0.2,
                              child: Icon(Icons.fastfood, size: 48, color: brandDark),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            right: 48,
                            child: Transform.rotate(
                              angle: 0.2,
                              child: Opacity(
                                opacity: 0.2,
                                child: Icon(Icons.shopping_bag, size: 60, color: brandDark),
                              ),
                            ),
                          ),
                          
                          // Main Content
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: Icon(Icons.bolt, size: 48, color: accentOrange),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Worth",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 30, // text-3xl
                                      fontWeight: FontWeight.w800,
                                      color: brandDark,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  Text(
                                    "It",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: accentOrange,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 220,
                                child: Text(
                                  "Groceries, food, and essentials delivered in minutes.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: brandDark.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.moped, size: 36, color: brandDark.withValues(alpha: 0.9)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SUPER FAST",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: accentOrange,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                "Delivery Partner",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: brandDark,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              // BOTTOM HALF: Login Card
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 40,
                        offset: Offset(0, -10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      Text(
                        "Login to WorthIt",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: brandDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Please enter your details to continue",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Form Fields
                        // Email Input
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail_outline, color: Colors.grey.shade400, size: 20),
                              hintText: "Email Address",
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Secondary Field (Password or OTP)
                      if (isOtpSent)
                        // OTP Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 8),
                            decoration: InputDecoration(
                              counterText: "",
                              prefixIcon: Icon(Icons.dialpad, color: Colors.grey.shade400, size: 20),
                              hintText: "Enter 6-digit OTP",
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        )
                      else  
                        // Password Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !isPasswordVisible,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              hintText: "Password",
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: GestureDetector(
                            onTap: _resetPassword,
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Login Button
                      const SizedBox(height: 8),
                      if (isLoading)
                         const Center(child: CircularProgressIndicator(color: Color(0xFFFF4500)))
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!isOtpSent && _passwordController.text.isEmpty && _emailController.text.isNotEmpty) {
                                // Demo trigger: if they type an email but leave password blank, try to send an OTP
                                _sendOTP(_emailController.text.trim());
                              } else {
                                _login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: accentOrange.withValues(alpha: 0.2),
                            ),
                            child: Text(
                              (!isOtpSent && _passwordController.text.isEmpty) ? "Send OTP" : "Login",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      const SizedBox(height: 32),
                      
                      // Footer
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(color: brandDark, fontSize: 14, fontWeight: FontWeight.w500),
                            children: [
                              const TextSpan(text: "New here? "),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                    );
                                  },
                                  child: Text(
                                    "Create account",
                                    style: GoogleFonts.plusJakartaSans(color: accentOrange, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "By logging in, you agree to our Terms of Service\nand Privacy Policy",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey.shade400,
                            fontSize: 10,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Container(height: MediaQuery.of(context).padding.bottom + 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
