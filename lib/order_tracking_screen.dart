import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps; // Alias for Google Maps
import 'theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Track Order",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🛵 MAP PLACEHOLDER (or Live Map)
            // 🛵 LIVE MAP implementation using FlutterMap (OpenStreetMap)
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                   // The Map
                   Positioned.fill(
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(20),
                       child: kIsWeb 
                         ? google_maps.GoogleMap(
                             initialCameraPosition: const google_maps.CameraPosition(
                               target: google_maps.LatLng(17.4486, 78.3908),
                               zoom: 15.0,
                             ),
                             markers: {
                               google_maps.Marker(
                                 markerId: const google_maps.MarkerId('user_location'),
                                 position: const google_maps.LatLng(17.4486, 78.3908),
                                 infoWindow: const google_maps.InfoWindow(title: 'You'),
                                 icon: google_maps.BitmapDescriptor.defaultMarker, 
                               ),
                               google_maps.Marker(
                                 markerId: const google_maps.MarkerId('driver_location'),
                                 position: const google_maps.LatLng(17.4520, 78.3950),
                                 infoWindow: const google_maps.InfoWindow(title: 'Delivery Driver'),
                                 icon: google_maps.BitmapDescriptor.defaultMarker, // Using default marker for now
                               ),
                             },
                           )
                         : FlutterMap(
                          options: const MapOptions(
                            initialCenter: LatLng(17.4486, 78.3908), // Example: Hitech City, Hyderabad
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.worthit.app',
                            ),
                            const MarkerLayer(
                              markers: [
                                 Marker(
                                    point: LatLng(17.4486, 78.3908),
                                    width: 40,
                                    height: 40,
                                    child: Icon(Icons.location_on, color: Colors.blue, size: 40),
                                 ),
                                 Marker(
                                    point: LatLng(17.4520, 78.3950), // Delivery driver
                                    width: 40,
                                    height: 40,
                                    child: Icon(Icons.delivery_dining, color: AppTheme.primaryColor, size: 40),
                                 ),
                              ],
                            ),
                          ],
                       ),
                     ),
                   ),
                   
                   // Gradient Overlay & Info Card
                   Positioned(
                     bottom: 0,
                     left: 0,
                     right: 0,
                     child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.delivery_dining, color: AppTheme.primaryColor),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Arriving in 15 mins",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Your order is on the way!",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                     ),
                   ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // 📦 ORDER STATUS CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #19283",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fresh Mart Store",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹450",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  
                  // TIMELINE
                  _buildTimelineItem(
                    title: "Order Placed",
                    time: "10:30 AM",
                    isActive: true,
                    isFirst: true,
                  ),
                  _buildTimelineItem(
                    title: "Order Confirmed",
                    time: "10:32 AM",
                    isActive: true,
                  ),
                  _buildTimelineItem(
                    title: "Out for Delivery",
                    time: "10:45 AM",
                    isActive: true,
                    isHighlights: true,
                  ),
                  _buildTimelineItem(
                    title: "Delivered",
                    time: "Est. 11:00 AM",
                    isActive: false,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🍔 ITEMS PREVIEW
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text("Items in this order", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                   const SizedBox(height: 10),
                   _buildOrderItem("Milk (1L)", "2"),
                   _buildOrderItem("Bread", "1"),
                   _buildOrderItem("Eggs (1 Dozen)", "1"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ❌ CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Cancel Order?"),
                      content: const Text("Are you sure you want to cancel this order? This action cannot be undone."),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("No, Keep it"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Order Cancelled successfully")),
                            );
                            Navigator.pop(context); // Go back
                          },
                          child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Cancel Order", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String time,
    bool isActive = false,
    bool isHighlights = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure children stretch to fill height
        children: [
          // Line & Dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isActive ? Colors.green : Colors.grey[200],
                    ),
                  ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isActive ? (isHighlights ? Colors.orange : Colors.green) : Colors.grey[200],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      if (isActive)
                        BoxShadow(
                          color: (isHighlights ? Colors.orange : Colors.green).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isActive && !isHighlights ? Colors.green : Colors.grey[200],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppTheme.darkText : Colors.grey,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String qty) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.poppins(fontSize: 14)),
          Text("x$qty", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
