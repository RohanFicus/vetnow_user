import 'package:flutter/material.dart';
import 'package:vetnow_user/core/localization/app_strings.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';

import './medical_consent_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  List<Map<String, String>> _getPages(BuildContext context) => [
    {
      "image":
          "https://images.unsplash.com/photo-1623387641168-d9803ddd3f35?q=80&w=1000&auto=format&fit=crop", // Dog & Cat
      "title": context.strings.onboardingTitle1,
      "desc": context.strings.onboardingDesc1,
    },
    {
      "image":
          "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=1000&auto=format&fit=crop", // Dog & Owner
      "title": context.strings.onboardingTitle2,
      "desc": context.strings.onboardingDesc2,
    },
    {
      "image":
          "https://images.unsplash.com/photo-1552053831-71594a27632d?q=80&w=1000&auto=format&fit=crop", // Older person with pet
      "title": context.strings.onboardingTitle3,
      "desc": context.strings.onboardingDesc3,
    },
  ];

  void _nextPage(int pageCount) {
    if (_currentIndex < pageCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Medical Consent
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MedicalConsentScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPages(context);

    return Scaffold(
      body: Stack(
        children: [
          // 1. The PageView (Images + Text)
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingContent(
                      image: pages[index]["image"]!,
                      title: pages[index]["title"]!,
                      desc: pages[index]["desc"]!,
                    );
                  },
                ),
              ),

              // Bottom spacing to accommodate fixed button area
              const SizedBox(height: 140),
            ],
          ),

          // 2. Skip Button (Top Right Overlay)
          Positioned(
            top: 50,
            right: 20,
            child: _currentIndex != pages.length - 1
                ? TextButton(
                    onPressed: () {
                      _controller.jumpToPage(pages.length - 1);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      context.strings.skip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // 3. Floating Bottom Controls (Dots + Button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              color: Theme.of(context).colorScheme.surface, // Ensures background adapts to theme
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pagination Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Main Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _nextPage(pages.length),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0061CE), // Brand Blue
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentIndex == pages.length - 1
                            ? context.strings.getStarted
                            : context.strings.next,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Safe Area spacer for iPhone home indicator
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the animated dots
  Widget buildDot(int index, BuildContext context) {
    bool isActive = index == _currentIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: isActive ? 30 : 6, // Active is wide, inactive is circle
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF0061CE)
            : (context.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Image Section (Flex 3)
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
              // Optional: Add rounded corners at the bottom of the image if desired
              // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),
        ),

        // Text Content Section (Flex 2)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: context.appMutedText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
