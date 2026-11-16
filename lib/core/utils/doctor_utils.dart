class DoctorUtils {
  static String formatDoctorName(String? name, {String fallback = "Veterinarian Specialist"}) {
    if (name == null || name.trim().isEmpty) return fallback;

    String cleanName = name.trim();

    // Remove existing Dr. / Dr prefix if present to normalize
    if (cleanName.toLowerCase().startsWith("dr.")) {
      cleanName = cleanName.substring(3).trim();
    } else if (cleanName.toLowerCase().startsWith("dr ")) {
      cleanName = cleanName.substring(3).trim();
    }

    if (cleanName.isEmpty) return fallback;

    // Capitalize the first letter of each word
    final capitalized = cleanName
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() +
              (word.length > 1 ? word.substring(1).toLowerCase() : "");
        })
        .join(' ');

    return "Dr. $capitalized";
  }

  static String capitalize(String? text) {
    if (text == null || text.trim().isEmpty) return "";
    final trimmed = text.trim();
    return trimmed
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() +
              (word.length > 1 ? word.substring(1).toLowerCase() : "");
        })
        .join(' ');
  }
}
