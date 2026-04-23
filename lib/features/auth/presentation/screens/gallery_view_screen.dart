import 'package:flutter/material.dart';

import '../../domain/entities/gallery_item.dart';

class GalleryViewScreen extends StatefulWidget {
  const GalleryViewScreen({super.key});

  @override
  State<GalleryViewScreen> createState() => _GalleryViewScreenState();
}

class _GalleryViewScreenState extends State<GalleryViewScreen> {
  // 2. The list of different photos and texts
  final List<GalleryItem> items = [
    GalleryItem(
      title: "Morning Walk",
      description:
          "Beautiful morning walk in the park. Max was very energetic...",
      date: "December 1, 2025",
      time: "05:30 AM",
      imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d",
    ),
    GalleryItem(
      title: "Pug Portrait",
      description: "Looking sharp! Our little pug posing for the camera today.",
      date: "December 5, 2025",
      time: "11:15 AM",
      imageUrl: "https://images.unsplash.com/photo-1517423440428-a5a00ad493e8",
    ),
    GalleryItem(
      title: "Happy Beagle",
      description: "Found a new friend at the dog park. Non-stop tail wagging!",
      date: "December 10, 2025",
      time: "04:45 PM",
      imageUrl: "https://images.unsplash.com/photo-1537151608828-ea2b11777ee8",
    ),
  ];

  // 3. Variable to track the currently selected photo
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Current active item based on the index
    final currentItem = items[_selectedIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // MAIN IMAGE VIEW
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Image.network(
                currentItem.imageUrl,
                key: ValueKey(
                  currentItem.imageUrl,
                ), // Key helps AnimatedSwitcher recognize change
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // Gradient Overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // TOP ACTIONS (Back, Share, Download, Delete)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circularBtn(Icons.chevron_left, () => Navigator.pop(context)),
                Row(
                  children: [
                    _circularBtn(Icons.share_outlined, () {}),
                    const SizedBox(width: 12),
                    _circularBtn(Icons.download_outlined, () {}),
                    const SizedBox(width: 12),
                    _circularBtn(Icons.delete_outline, () {
                      _showDeleteDialog(context);
                    }),
                  ],
                ),
              ],
            ),
          ),

          // BOTTOM CONTENT (Text and Thumbnails)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentItem.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentItem.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "${currentItem.date}  ${currentItem.time}",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 25),

                // THUMBNAIL ROW
                Row(
                  children: List.generate(items.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        // UPDATE STATE WHEN CLICKED
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            items[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Top Buttons
  Widget _circularBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white.withOpacity(0.15),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Are you sure you want to delete this activity",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "This action can not be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Yes, Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
