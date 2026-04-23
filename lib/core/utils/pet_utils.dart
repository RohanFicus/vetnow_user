import 'package:flutter/material.dart';

class PetUtils {
  static String getSpeciesImage(String? speciesName) {
    final name = speciesName?.toLowerCase() ?? "";
    if (name.contains("dog")) {
      return "https://images.unsplash.com/photo-1517849845537-4d257902454a?q=80&w=1000&auto=format&fit=crop";
    }
    if (name.contains("cat")) {
      return "https://images.unsplash.com/photo-1574158622682-e40e69881006?q=80&w=1000&auto=format&fit=crop";
    }
    if (name.contains("cow")) {
      return "https://images.unsplash.com/photo-1546445317-29f4545e9d53?q=80&w=1000&auto=format&fit=crop";
    }
    if (name.contains("buffalo")) {
      return "https://images.unsplash.com/photo-1626569706439-59455ae2d68f?q=80&w=1000&auto=format&fit=crop";
    }
    return "https://placedog.net/500/500?id=3"; // Default fallback
  }

  static IconData getSpeciesIcon(String? speciesName) {
    final name = speciesName?.toLowerCase() ?? "";
    if (name.contains("dog")) {
      return Icons.pets;
    }
    if (name.contains("cat")) {
      return Icons.pets; // Or a specific cat icon if available
    }
    if (name.contains("cow") || name.contains("buffalo")) {
      return Icons.agriculture;
    }
    return Icons.pets;
  }
}
