import 'package:flutter/material.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: context.appBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration (Network Image for demo)
              Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    // Using a placeholder that looks similar to the flat illustration style
                    image: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/7486/7486747.png',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                "No Internet Connection!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.appText,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "Please check your internet settings and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: context.appMutedText,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to dashboard on retry
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.isDarkMode ? Colors.white : Colors.black,
                    foregroundColor: context.isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Try Again",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
