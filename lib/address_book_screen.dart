import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

import 'responsive_helper.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  // Mock List of Addresses
  List<Map<String, String>> addresses = [
    {
      "type": "Home",
      "address": "Flat 402, Sunshine Apartments, Hitech City",
      "pincode": "500081",
      "phone": "9876543210"
    }
  ];

  void _addNewAddress(Map<String, String> newAddress) {
    setState(() {
      addresses.add(newAddress);
    });
  }

  void _showAddAddressSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddAddressSheet(onSave: _addNewAddress),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Address Book", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        actions: [
          // On Desktop, show "Add Address" button inline
          if (ResponsiveLayout.isDesktop(context))
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: ElevatedButton.icon(
                onPressed: _showAddAddressSheet,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Add New"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.add, color: AppTheme.primaryColor),
              onPressed: _showAddAddressSheet,
            )
        ],
      ),
      body: BootstrapContainer(
        child: addresses.isEmpty
            ? Center(child: Text("No addresses saved", style: GoogleFonts.poppins(color: Colors.grey)))
            : ResponsiveLayout(
                mobile: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) => _buildAddressCard(index),
                ),
                desktop: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 Columns for larger screens
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.8, // Rectangular cards
                  ),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) => _buildAddressCard(index),
                ),
                tablet: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 Columns for tablets
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) => _buildAddressCard(index),
                ),
              ),
      ),
      floatingActionButton: !ResponsiveLayout.isDesktop(context) 
        ? FloatingActionButton.extended(
            onPressed: _showAddAddressSheet,
            backgroundColor: AppTheme.primaryColor,
            label: const Text("Add New Address"),
            icon: const Icon(Icons.add),
          )
        : null, // Hide FAB on desktop where we have the AppBar button
    );
  }

  Widget _buildAddressCard(int index) {
    final addr = addresses[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                Row(
                  children: [
                    Icon(
                      addr['type'] == 'Home' ? Icons.home_rounded : Icons.work_rounded,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      addr['type']!,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      addresses.removeAt(index);
                    });
                  },
                ),
             ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              addr['address']!,
              style: GoogleFonts.poppins(color: Colors.grey[700], height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.pin_drop_outlined, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                "${addr['pincode']}",
                style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              Icon(Icons.phone_outlined, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                 "${addr['phone']}",
                 style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AddAddressSheet extends StatefulWidget {
  final Function(Map<String, String>) onSave;

  const AddAddressSheet({super.key, required this.onSave});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _phoneController = TextEditingController();
  String _addressType = "Home"; // Home or Work
  final String _addressLabel = "Home";

  @override
  Widget build(BuildContext context) {
    // Responsive Modal Width
    final isDesktop = ResponsiveLayout.isDesktop(context);
    
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        margin: isDesktop ? const EdgeInsets.all(40) : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add Address", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildInput(
                  controller: _addressController,
                  label: "Full Address (House No, Street, Landmark)",
                  maxLines: 2,
                   validator: (value) => value!.isEmpty ? "Enter Address" : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: _pincodeController,
                        label: "Pincode",
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.length != 6 ? "Invalid Pincode" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInput(
                        controller: _phoneController,
                        label: "Mobile Number",
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.length != 10 ? "Invalid Mobile" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Type Selector
                Row(
                  children: [
                    _buildTypeChip("Home", Icons.home),
                    const SizedBox(width: 12),
                    _buildTypeChip("Work", Icons.work),
                  ],
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSave({
                          "type": _addressType,
                          "address": _addressController.text,
                          "pincode": _pincodeController.text,
                          "phone": _phoneController.text,
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Save Address", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    final isSelected = _addressType == label;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      selectedColor: AppTheme.primaryColor,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (bool selected) {
        setState(() => _addressType = label);
      },
    );
  }
}
