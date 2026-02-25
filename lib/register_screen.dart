import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'bottom_nav_screen.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Color primaryYellow = const Color(0xFFFFD700);
  final Color accentOrange = const Color(0xFFFF4500);
  final Color brandDark = const Color(0xFF1A1A1A);

  bool _isPasswordVisible = false;
  bool _isCaptchaVerified = false;

  bool isOtpSent = false;
  bool isLoading = false;
  String? serverGeneratedOTP;
  final TextEditingController _otpController = TextEditingController();
  
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  void _validatePasswords() {
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    if (pass.isEmpty && confirm.isEmpty) {
      setState(() {
        passwordError = null;
        confirmPasswordError = null;
      });
      return;
    }
    
    setState(() {
      if (pass.isNotEmpty && pass.length < 6) {
        passwordError = "Password must be at least 6 characters";
      } else {
        passwordError = null;
      }
      
      if (confirm.isNotEmpty && pass != confirm) {
        confirmPasswordError = "Passwords do not match";
      } else {
        confirmPasswordError = null;
      }
    });
  }

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
    if (recipientEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter an email address first.")));
      return;
    }
    
    setState(() => isLoading = true);
    try {
      try {
        final userQuery = await FirebaseFirestore.instance.collection('users')
            .where('email', isEqualTo: recipientEmail).limit(1).get();
            
        if (userQuery.docs.isNotEmpty) {
          if (!mounted) return;
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Account already exists! Please login instead."), 
            backgroundColor: Colors.red
          ));
          return;
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Database Error: Could not verify if user exists. [cloud_firestore/permission-denied] Missing or insufficient permissions."), 
          backgroundColor: Colors.red
        ));
        return;
      }

      final random = Random();
      serverGeneratedOTP = (100000 + random.nextInt(900000)).toString();

      bool emailActuallySent = false;
      try {
        if (!kIsWeb) {
            String username = 'saitejagadu21@gmail.com'; 
            String password = 'jzxngsgijebmfdoe';    
            final smtpServer = gmail(username, password); 

            final message = Message()
              ..from = Address(username, 'WorthIt App')
              ..recipients.add(recipientEmail)
              ..subject = 'Your WorthIt Registration OTP'
              ..text = 'Your One Time Password is: $serverGeneratedOTP. Do not share this code.';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Faded icons in background
                      Positioned(
                        top: 20,
                        left: 32,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Opacity(
                            opacity: 0.2,
                            child: Icon(Icons.lunch_dining, size: 60, color: brandDark),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 40,
                        child: Transform.rotate(
                          angle: 0.2,
                          child: Opacity(
                            opacity: 0.2,
                            child: Icon(Icons.shopping_bag, size: 70, color: brandDark),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 48,
                        child: Transform.rotate(
                          angle: 0.1,
                          child: Opacity(
                            opacity: 0.15,
                            child: Icon(Icons.local_pharmacy, size: 50, color: brandDark),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 56,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Opacity(
                            opacity: 0.15,
                            child: Icon(Icons.local_grocery_store, size: 60, color: brandDark),
                          ),
                        ),
                      ),
                      
                      // Main Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Icon(Icons.person_add, size: 40, color: accentOrange),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Join ",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: brandDark,
                                  letterSpacing: -1,
                                ),
                              ),
                              Text(
                                "WorthIt",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: accentOrange,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Get everything you need\ndelivered right to your doorstep.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: brandDark.withValues(alpha: 0.7),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // BOTTOM HALF: Create Account Card
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
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
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Text(
                        "Create Account",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: brandDark,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Form Fields
                      _buildLabel("Full Name"),
                      _buildTextField(
                        controller: _nameController,
                        icon: Icons.person,
                        hintText: "John Doe",
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildLabel("Email Address"),
                      _buildTextField(
                        controller: _emailController,
                        icon: Icons.mail,
                        hintText: "name@example.com",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),


                      
                      _buildLabel("Password"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: passwordError != null ? Colors.red.shade400 : Colors.grey[100]!, width: passwordError != null ? 1.5 : 1),
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: Colors.grey[400], size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                hintText: "••••••••",
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                          if (passwordError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 4),
                              child: Text(passwordError!, style: GoogleFonts.plusJakartaSans(color: Colors.red.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Confirm Password"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: confirmPasswordError != null ? Colors.red.shade400 : Colors.grey[100]!, width: confirmPasswordError != null ? 1.5 : 1),
                            ),
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_reset, color: Colors.grey[400], size: 20),
                                hintText: "••••••••",
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                          if (confirmPasswordError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 4),
                              child: Text(confirmPasswordError!, style: GoogleFonts.plusJakartaSans(color: Colors.red.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Fake reCAPTCHA
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isCaptchaVerified = !_isCaptchaVerified;
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: _isCaptchaVerified ? accentOrange : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: _isCaptchaVerified
                                        ? Icon(Icons.check, size: 18, color: accentOrange)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "I'm not a robot",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.autorenew, size: 28, color: Colors.blue[600]!.withValues(alpha: 0.7)),
                                const SizedBox(height: 4),
                                Text(
                                  "reCAPTCHA",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (isOtpSent)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Verification OTP"),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[100]!),
                              ),
                              child: TextField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 8),
                                decoration: InputDecoration(
                                  counterText: "",
                                  prefixIcon: Icon(Icons.dialpad, color: Colors.grey[400], size: 20),
                                  hintText: "Enter 6-digit OTP",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),

                      // Create Account Button
                      if (isLoading)
                        const Center(child: CircularProgressIndicator(color: Color(0xFFFF4500)))
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_isCaptchaVerified) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please verify you are not a robot.")),
                                );
                                return;
                              }
                              
                              if (!isOtpSent) {
                                final pass = _passwordController.text.trim();
                                final confirmPass = _confirmPasswordController.text.trim();
                                
                                if (pass.isEmpty || pass.length < 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Password must be at least 6 characters long."), backgroundColor: Colors.orange),
                                  );
                                  return;
                                }
                                
                                if (pass != confirmPass) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Passwords do not match! Please check and try again."), backgroundColor: Colors.red),
                                  );
                                  return;
                                }
                                
                                _sendOTP(_emailController.text.trim());
                              } else {
                                if (_otpController.text.trim() == serverGeneratedOTP) {
                                    _createAccount();
                                } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Invalid OTP code. Please try again."), backgroundColor: Colors.red),
                                    );
                                }
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
                              !isOtpSent ? "Send OTP" : "Verify & Create Account",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      
                      const Spacer(),
                      const SizedBox(height: 24),
                      
                      // Footer
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(color: brandDark, fontSize: 14, fontWeight: FontWeight.w500),
                            children: [
                              const TextSpan(text: "Already have an account? "),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.plusJakartaSans(color: accentOrange, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "By signing up, you agree to our Terms of Service\nand Privacy Policy",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey[400],
                            fontSize: 10,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  Future<void> _createAccount() async {
    setState(() => isLoading = true);
    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );
      
      await userCred.user?.updateDisplayName(_nameController.text.trim());
      
      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNavScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          hintText: hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
            color: Colors.grey[300],
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
