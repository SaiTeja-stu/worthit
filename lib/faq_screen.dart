import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqs = const [
    {
      "question": "How do I track my order?",
      "answer": "You can track your active orders by navigating to the 'Profile' tab and selecting 'Track Order'. You will see real-time updates on the map."
    },
    {
      "question": "What payment methods do you accept?",
      "answer": "We accept all major Credit/Debit cards, UPI (Google Pay, PhonePe), and Net Banking. Cash on Delivery is also available for select locations."
    },
    {
      "question": "How can I return an item?",
      "answer": "Go to 'Your Orders', select the order with the item you want to return, and click on 'Return/Exchange'. Returns are accepted within 7 days of delivery."
    },
    {
      "question": "Do you deliver to my location?",
      "answer": "We currently serve the greater metro area. You can check serviceability by entering your pincode in the 'Address Book' section."
    },
    {
      "question": "How do I contact customer support?",
      "answer": "You can chat with our virtual assistant 24/7 using the 'Chat with Us' button below, or email us at support@worthit.com."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Frequently Asked Questions",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ExpansionTile(
              title: Text(
                faqs[index]["question"]!,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    faqs[index]["answer"]!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.lightText,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
