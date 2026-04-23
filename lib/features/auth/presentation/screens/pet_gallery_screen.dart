import 'package:flutter/material.dart';

import '../../domain/entities/gallery_item.dart';
import './gallery_view_screen.dart';

// --- Main Gallery List Screen ---
class PetGalleryScreen extends StatelessWidget {
  const PetGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<GalleryItem> decItems = [
      GalleryItem(
        title: "Morning Walk",
        description:
            "Beautiful morning walk in the park. Max was very energetic...",
        time: "05:30 AM",
        date: "December 1, 2025",
        imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d",
      ),
      GalleryItem(
        title: "Playing with Toy",
        description: "Playing fetch in the park.",
        time: "02:30 PM",
        date: "December 1, 2025",
        imageUrl:
            "https://images.unsplash.com/photo-1583511655857-d19b40a7a54e",
      ),
      GalleryItem(
        title: "Meal Time",
        description: "Kristal is eating a bone.",
        time: "02:30 PM",
        date: "December 1, 2025",
        imageUrl:
            "https://images.unsplash.com/photo-1517849845537-4d257902454a",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Pet Gallery",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Your pet's memorable moments",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView(
                  children: [
                    _sectionHeader("December 1, 2025"),
                    ...decItems.map((item) => _buildGalleryCard(context, item)),
                    _sectionHeader("November 30, 2025"),
                    _buildGalleryCard(
                      context,
                      GalleryItem(
                        title: "Medicine Time",
                        description: "Zara took medicine and looked at...",
                        time: "02:30 PM",
                        date: "November 30, 2025",
                        imageUrl:
                            "https://images.unsplash.com/photo-1543466835-00a7907e9de1",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        date,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, GalleryItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryViewScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, "Home", false),
          _navItem(Icons.calendar_month_outlined, "Booking", false),
          const SizedBox(width: 40),
          _navItem(Icons.image, "Gallery", true),
          _navItem(Icons.settings_outlined, "Settings", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? Colors.black : Colors.grey),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontSize: 10,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 2),
            height: 4,
            width: 4,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
