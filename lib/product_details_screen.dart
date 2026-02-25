import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'cart_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  int _currentImageIndex = 0;
  final ScrollController _scrollController = ScrollController();
  
  // Mock multiple images for carousel
  late List<String> _productImages;

  @override
  void initState() {
    super.initState();
    // Use the single image as a list or mock more
    _productImages = [
      widget.product['imageUrl'] ?? widget.product['image'],
      // Add placeholders for demo carousel
      "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=800&q=80",
    ];
  }

  void _addToCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(
      id: widget.product['name'],
      name: widget.product['name'],
      price: double.tryParse(widget.product['price'].replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
      image: widget.product['imageUrl'] ?? widget.product['image'],
    );
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.product['name']} added to cart!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                  onPressed: () {}, // Navigate to cart
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎠 IMAGE CAROUSEL
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() => _currentImageIndex = index);
                      },
                      itemCount: _productImages.length,
                      itemBuilder: (context, index) {
                        return Hero(
                           tag: index == 0 ? widget.product['name'] : 'img$index',
                           child: Image.network(
                            _productImages[index],
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _productImages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? AppTheme.primaryColor
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand / Category
                        Text(
                          "Fresh Valley Farms", // Mock Brand
                          style: GoogleFonts.poppins(
                             color: AppTheme.primaryColor,
                             fontWeight: FontWeight.w600,
                             fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Product Name
                        Text(
                          widget.product['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),
                        
                        // Rating
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const Icon(Icons.star_half, color: Colors.amber, size: 18),
                            const SizedBox(width: 8),
                            Text("4.5", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            Text("(128 reviews)", style: GoogleFonts.poppins(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Price
                        Row(
                          children: [
                            Text(
                              widget.product['price'],
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "₹${(double.parse(widget.product['price'].replaceAll(RegExp(r'[^0-9.]'), '')) * 1.2).toStringAsFixed(0)}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "20% OFF",
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Inclusive of all taxes",
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                        ),
                        
                        const Divider(height: 30),
                        
                        // Stock Status
                        Row(
                           children: [
                             Icon(Icons.check_circle, color: Colors.green[600], size: 16),
                             const SizedBox(width: 8),
                             Text("In Stock", style: GoogleFonts.poppins(color: Colors.green[600], fontWeight: FontWeight.w600)),
                           ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                        Text(
                          "Description",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         const SizedBox(height: 8),
                        Text(
                          "Premium quality ${widget.product['name']} sourced directly from top-rated farms. 100% organic and fresh. Carefully packed to ensure maximum freshness upon delivery. Perfect for your daily nutritional needs.",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        // Features / Specs
                        Text("Features", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        _buildFeatureRow("Organic", "100% Certified"),
                        _buildFeatureRow("Origin", "Local Farms"),
                        _buildFeatureRow("Shelf Life", "3-5 Days"),
                        _buildFeatureRow("Storage", "Cool & Dry place"),

                        const Divider(height: 30),
                        
                        // Reviews Preview
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Customer Reviews", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("View all", style: GoogleFonts.poppins(color: AppTheme.primaryColor)),
                            ),
                          ],
                        ),
                         const SizedBox(height: 16),
                        _buildReviewItem("John Doe", 5, "Excellent quality! Very fresh."),
                        _buildReviewItem("Jane Smith", 4, "Good packaging, timely delivery."),
                        
                        const SizedBox(height: 80), // Approx BottomSheet height
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 🛑 BOTTOM ACTIONS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                   color: Colors.black.withOpacity(0.05),
                   blurRadius: 10,
                   offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Quantity
                 Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () { if(_quantity > 1) setState(() => _quantity--); },
                        ),
                        Text('$_quantity', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () { setState(() => _quantity++); },
                        ),
                      ],
                    ),
                 ),
                 const SizedBox(width: 16),
                 
                 // Add to Cart
                 Expanded(
                   child: ElevatedButton(
                     onPressed: _addToCart,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.white,
                       foregroundColor: AppTheme.primaryColor,
                       side: const BorderSide(color: AppTheme.primaryColor),
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       elevation: 0,
                     ),
                     child: Text("Add to Cart", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                   ),
                 ),
                 const SizedBox(width: 12),
                 
                 // Buy Now
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                       _addToCart();
                       // Navigate to checkout
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: AppTheme.primaryColor,
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       elevation: 0,
                     ),
                     child: Text("Buy Now", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                   ),
                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.grey[600])),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String user, int rating, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             children: [
               CircleAvatar(
                 radius: 12,
                 backgroundColor: Colors.grey[300],
                 child: Text(user[0], style: const TextStyle(fontSize: 12, color: Colors.black)),
               ),
               const SizedBox(width: 8),
               Text(user, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
               const Spacer(),
               Row(
                 children: List.generate(5, (index) => Icon(
                   index < rating ? Icons.star : Icons.star_border,
                   size: 14,
                   color: Colors.amber,
                 )),
               )
             ],
           ),
           const SizedBox(height: 8),
           Text(comment, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
