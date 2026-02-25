import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // Mock Data
  List<Map<String, dynamic>> savedCards = [
    {
      "type": "Mastercard",
      "number": "**** **** **** 5432",
      "expiry": "12/25",
      "color": const Color(0xFF1E1E1E), // Dark Card
    }
  ];

  List<Map<String, String>> savedUPIs = [
    {"id": "saiteja@okhdfcbank", "app": "Google Pay"},
    {"id": "saiteja@ybl", "app": "PhonePe"},
  ];

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCardSheet(),
    );
  }

  void _showAddUPISheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddUPISheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Payment Methods", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💳 CARDS SECTION
            _buildSectionHeader("Credit & Debit Cards"),
            const SizedBox(height: 12),
            ...savedCards.map((card) => _buildCreditCard(card)),
            _buildAddButton("Add New Card", Icons.credit_card, _showAddCardSheet),

            const SizedBox(height: 30),

            // 💠 UPI SECTION
            _buildSectionHeader("UPI"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  ...savedUPIs.map((upi) => Column(
                        children: [
                          _buildUPIItem(upi),
                          if (upi != savedUPIs.last)
                            Divider(height: 1, thickness: 1, color: Colors.grey[100], indent: 60),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildAddButton("Add New UPI ID", Icons.qr_code_rounded, _showAddUPISheet),

            const SizedBox(height: 40),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 16, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Text(
                    "100% Secure Payment",
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildCreditCard(Map<String, dynamic> card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: card['color'],
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            card['color'],
            card['color'].withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: (card['color'] as Color).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chip & Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.credit_card, color: Colors.white70, size: 30), // Placeholder for Chip
              Text(
                card['type'],
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Number
          Text(
            card['number'],
            style: GoogleFonts.sourceCodePro(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 20),
          // Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Card Holder", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
                  Text("SAITHEJA", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Expires", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
                  Text(card['expiry'], style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUPIItem(Map<String, String> upi) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor),
      ),
      title: Text(upi['app']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      subtitle: Text(upi['id']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () {}),
    );
  }

  Widget _buildAddButton(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.primaryColor.withOpacity(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(text, style: GoogleFonts.poppins(color: AppTheme.primaryColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// 📌 Add Card Bottom Sheet
class AddCardSheet extends StatelessWidget {
  const AddCardSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add New Card", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _input("Card Number", Icons.credit_card_outlined),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _input("Expiry (MM/YY)", Icons.calendar_today)),
              const SizedBox(width: 16),
              Expanded(child: _input("CVV", Icons.lock_outline)),
            ],
          ),
          const SizedBox(height: 16),
          _input("Card Holder Name", Icons.person_outline),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Verify & Save Card", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// 📌 Add UPI Bottom Sheet
class AddUPISheet extends StatelessWidget {
  const AddUPISheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add UPI ID", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: "Enter UPI ID (e.g. name@upi)",
              prefixIcon: const Icon(Icons.qr_code, color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Verify & Save UPI", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
