import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'email_sent_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final Color primaryYellow = const Color(0xFFFFD700);
  final Color softYellow = const Color(0xFFFFF9E0);
  final Color accentOrange = const Color(0xFFFF4500);
  final Color brandDark = const Color(0xFF1A1A1A);
  final Color verifyBlue = const Color(0xFF007AFF);

  final TextEditingController _contactController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());

  bool isLoading = false;
  String serverGeneratedOTP = "";
  String? emailError;
  bool showOtpError = false;

  @override
  void initState() {
    super.initState();
    _contactController.addListener(() {
      if (emailError != null && _contactController.text.isNotEmpty) {
        setState(() => emailError = null);
      }
    });
  }

  @override
  void dispose() {
    _contactController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (showOtpError) setState(() => showOtpError = false);
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _sendOTP() async {
    final String contact = _contactController.text.trim();
    if (contact.isEmpty) {
      setState(() => emailError = "This field is mandatory");
      return;
    }
    
    setState(() => isLoading = true);
    try {
      try {
        final userQuery = await FirebaseFirestore.instance.collection('users')
            .where('email', isEqualTo: contact).limit(1).get();
            
        if (userQuery.docs.isEmpty) {
          if (!mounted) return;
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Account not found! Please check your email and try again."), 
            backgroundColor: Colors.red
          ));
          return;
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Database Error: [cloud_firestore/permission-denied] Missing or insufficient permissions."), 
          backgroundColor: Colors.red
        ));
        return;
      }

      // Generate and Send OTP
      final random = Random();
      serverGeneratedOTP = (100000 + random.nextInt(900000)).toString();

      final url = Uri.parse('http://127.0.0.1:3000/');
      final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'to': contact,
            'otp': serverGeneratedOTP,
          })
      ).timeout(const Duration(seconds: 15)); 

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Local SMTP API Server rejected the mail request: ${response.statusCode}");
      }
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verification Code sent to your email!"), backgroundColor: Colors.green));
    } catch (e) {
      print("Email Failed: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email Service Failed. Reason: $e", style: const TextStyle(color: Colors.white)), 
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ));
      return;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _processVerify() async {
    setState(() => showOtpError = false);

    String enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp.length != 6) {
      setState(() => showOtpError = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter the full 6-digit OTP."), backgroundColor: Colors.orange));
      return;
    }
    if (enteredOtp != serverGeneratedOTP) {
      setState(() => showOtpError = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP code. Please try again."), backgroundColor: Colors.red));
      return;
    }

    // Trigger Firebase Reset
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _contactController.text.trim());
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailSentScreen(email: _contactController.text.trim()),
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _buildOtpBox(int index, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: index == 5 ? 0 : 6),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: showOtpError ? Colors.red.shade400 : Colors.grey.shade100, width: showOtpError ? 1.5 : 1),
            ),
            child: Center(
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brandDark,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "•",
                  hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey.shade300),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onChanged: (value) => _onOtpChanged(value, index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softYellow,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [softYellow, primaryYellow],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_back_ios_new, color: brandDark, size: 20),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 0),
                              ],
                            ),
                            child: Icon(Icons.verified_user, color: accentOrange, size: 48),
                          ),
                          Text(
                            "Verify Identity",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: brandDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Verify your details to proceed with\nresetting your password",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
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
                
                Expanded(
                  flex: 65,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 40, offset: Offset(0, -10)),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 48,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.only(bottom: 32),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                                    child: Text(
                                      "Email Address",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: emailError != null ? Colors.red.shade400 : Colors.grey.shade100, width: emailError != null ? 1.5 : 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        Icon(Icons.email_outlined, color: Colors.grey.shade400, size: 20),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: TextField(
                                            controller: _contactController,
                                            keyboardType: TextInputType.emailAddress,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade800,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "e.g. name@example.com",
                                              hintStyle: GoogleFonts.plusJakartaSans(
                                                color: Colors.grey.shade400,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 20),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: SizedBox(
                                            height: 40,
                                            child: ElevatedButton(
                                              onPressed: isLoading ? null : _sendOTP,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: accentOrange,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                              ),
                                              child: Text(
                                                "SEND",
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (emailError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, top: 4),
                                      child: Text(emailError!, style: GoogleFonts.plusJakartaSans(color: Colors.red.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Enter 6-Digit OTP",
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: isLoading ? null : _sendOTP,
                                          child: Text(
                                            "Resend OTP",
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: accentOrange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate(6, (index) => _buildOtpBox(index, context)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        height: 44,
                                        child: OutlinedButton(
                                          onPressed: _processVerify,
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: verifyBlue,
                                            side: BorderSide(color: verifyBlue, width: 2),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                          ),
                                          child: Text(
                                            "VERIFY",
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (showOtpError)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, top: 4),
                                      child: Text("Please fill all OTP fields correctly.", style: GoogleFonts.plusJakartaSans(color: Colors.red.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _processVerify,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: accentOrange,
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shadowColor: accentOrange.withValues(alpha: 0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Verify & Proceed",
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.arrow_forward, size: 20),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 8),
                            child: Text(
                              "For security purposes, do not share this code with anyone.\nStandard messaging rates may apply.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: Colors.grey.shade400,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
