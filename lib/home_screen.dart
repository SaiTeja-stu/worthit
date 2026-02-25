import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'stores_screen.dart';
import 'profile_screen.dart';
import 'cart_provider.dart';
import 'group_invite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showTooltip = true;

  final Color brandOrange = const Color(0xFFFF5200);
  final Color brandGreen = const Color(0xFF1CB919);
  final Color softGray = const Color(0xFFF3F4F6);
  final Color textDark = const Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildOffersSlider(),
              const SizedBox(height: 24),
              _buildCategoriesGrid(),
              const SizedBox(height: 24),
              _buildTopBrands(),
              const SizedBox(height: 24),
              _buildPointsBanner(),
              const SizedBox(height: 24),
              _buildHandpickedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: brandOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(child: Text("Delivery to Home", style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: textDark), overflow: TextOverflow.ellipsis)),
                                  Icon(Icons.expand_more, size: 16, color: brandOrange),
                                ],
                              ),
                              Text("123 Maple St, Green Valley Estate...", style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const GroupInviteScreen()));
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            shape: BoxShape.circle,
                            border: Border.all(color: brandGreen.withValues(alpha: 0.2)),
                          ),
                          child: Icon(Icons.group_add, color: brandGreen),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: softGray,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: softGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: brandOrange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "What are you looking for?",
                          hintStyle: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onSubmitted: (value) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => StoresScreen(initialQuery: value)));
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Icon(Icons.mic, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showTooltip)
            Positioned(
              top: 48,
            right: 52,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GroupInviteScreen()));
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: brandGreen,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: brandGreen.withValues(alpha: 0.3),
                          blurRadius: 15,
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("ORDER WITH FRIENDS", style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showTooltip = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 10, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: 16,
                    child: Transform.rotate(
                      angle: 0.785398,
                      child: Container(
                        width: 10,
                        height: 10,
                        color: brandGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSlider() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildOfferCard(
            title: "UP TO 50% OFF",
            subtitle: "On Fresh Groceries",
            badge: "Flash Sale",
            badgeColor: brandOrange,
            imageUrl: "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80",
          ),
          const SizedBox(width: 16),
          _buildOfferCard(
            title: "DINNER SPECIAL",
            subtitle: "Best Local Restaurants",
            badge: "Free Delivery",
            badgeColor: brandGreen,
            imageUrl: "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80",
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard({required String title, required String subtitle, required String badge, required Color badgeColor, required String imageUrl}) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.7), Colors.black.withValues(alpha: 0.1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
              child: Text(badge.toUpperCase(), style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
            Text(subtitle, style: GoogleFonts.manrope(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen())),
                  child: _buildLargeCategory(
                    title: "Insta-Groceries",
                    badge: "10 MINS",
                    badgeColor: Colors.green.shade600,
                    bgColor: Colors.green.shade50,
                    titleColor: Colors.green.shade900,
                    imageUrl: "https://cdn-icons-png.flaticon.com/512/3081/3081840.png", // Fallback icon
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen())),
                   child: _buildLargeCategory(
                    title: "Food Delivery",
                    badge: "HOT & FRESH",
                    badgeColor: Colors.orange.shade600,
                    bgColor: Colors.orange.shade50,
                    titleColor: Colors.orange.shade900,
                    imageUrl: "https://cdn-icons-png.flaticon.com/512/3081/3081966.png", // Fallback icon
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen())),
                   child: _buildSmallCategory(
                    title: "Pharmacy",
                    subtitle: "Medications",
                    bgColor: Colors.blue.shade50,
                    titleColor: Colors.blue.shade900,
                    subColor: Colors.blue.shade600,
                    imageUrl: "https://cdn-icons-png.flaticon.com/512/2966/2966334.png", // Fallback icon
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen())),
                   child: _buildSmallCategory(
                    title: "Fresh Meat",
                    subtitle: "Prime Cuts",
                    bgColor: Colors.red.shade50,
                    titleColor: Colors.red.shade900,
                    subColor: Colors.red.shade600,
                    imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046771.png", // Fallback icon
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeCategory({required String title, required String badge, required Color badgeColor, required Color bgColor, required Color titleColor, required String imageUrl}) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w900, color: titleColor, height: 1.1)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Text(badge, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor)),
              ),
            ],
          ),
          Positioned(
            bottom: -5,
            right: -5,
            child: Image.network(imageUrl, width: 70, height: 70, fit: BoxFit.contain, errorBuilder: (_,_,_) => const SizedBox(width:70, height:70)),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCategory({required String title, required String subtitle, required Color bgColor, required Color titleColor, required Color subColor, required String imageUrl}) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: titleColor), overflow: TextOverflow.ellipsis, maxLines: 1),
                Text(subtitle, style: GoogleFonts.manrope(fontSize: 10, color: subColor), overflow: TextOverflow.ellipsis, maxLines: 1),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Image.network(imageUrl, width: 35, height: 35, fit: BoxFit.contain, errorBuilder: (_,_,_) => const SizedBox(width: 35, height:35)),
        ],
      ),
    );
  }

  Widget _buildTopBrands() {
    final brands = [
      {"name": "Bakery Hub", "img": "BH"},
      {"name": "Milk Co.", "img": "MC"},
      {"name": "Cookie Box", "img": "CB"},
      {"name": "HealthPlus", "img": "HP"},
      {"name": "FreshMart", "img": "FM"},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Top Brands", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: textDark)),
              Text("View More", style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: brandOrange)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                      child: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        // Note: Using a regular Container with color for initials fallback 
                        child: CircleAvatar(
                           backgroundColor: Colors.primaries[index % Colors.primaries.length].shade100,
                           child: Text(brands[index]["img"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(brands[index]["name"]!, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPointsBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: brandOrange, shape: BoxShape.circle, boxShadow: [BoxShadow(color: brandOrange.withValues(alpha: 0.4), blurRadius: 10)]),
                    child: const Icon(Icons.stars, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Claim your 500 points!", style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1),
                        Text("Use them for free delivery today", style: GoogleFonts.manrope(fontSize: 10, color: Colors.white70), overflow: TextOverflow.ellipsis, maxLines: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildHandpickedProducts() {
    final products = [
      {"name": "Organic Whole Milk 1L", "price": "₹375", "oldPrice": "₹435", "save": "SAVE ₹60", "img": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&q=80"},
      {"name": "Choco-chip Cookies", "price": "₹499", "save": "", "oldPrice": "", "img": "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?auto=format&fit=crop&w=400&q=80"},
      {"name": "Daily Multivitamins", "price": "₹1099", "save": "", "oldPrice": "", "img": "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Handpicked for You", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, color: textDark)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final p = products[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: softGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(16),
                               child: Image.network(p["img"]!, fit: BoxFit.cover),
                             ),
                          ),
                          if (p["save"]!.isNotEmpty)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: brandGreen, borderRadius: BorderRadius.circular(4)),
                                child: Text(p["save"]!, style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          Positioned(
                            bottom: -10,
                            right: 8,
                            child: InkWell(
                              onTap: () {
                                 context.read<CartProvider>().addItem(
                                   id: p['name']!,
                                   name: p['name']!,
                                   price: double.tryParse(p['price']!.replaceAll('₹', '').replaceAll(',', '')) ?? 0.0,
                                   image: p['img'],
                                 );
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart"), duration: Duration(seconds: 1)));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: brandOrange.withValues(alpha: 0.2)),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                                ),
                                child: Text("ADD", style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w900, color: brandOrange)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(p["name"]!, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(p["price"]!, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800)),
                        if (p["oldPrice"]!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(p["oldPrice"]!, style: GoogleFonts.manrope(fontSize: 10, decoration: TextDecoration.lineThrough, color: Colors.grey.shade400)),
                        ]
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
