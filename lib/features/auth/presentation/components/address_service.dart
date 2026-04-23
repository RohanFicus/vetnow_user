import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/models/SearchAddressModel.dart';

class AddressService {
  // Photon is better for autocomplete/search-as-you-type
  static const String photonUrl = "https://photon.komoot.io/api/";

  Future<List<SearchAddressModel>> searchAddress(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      "https://photon.komoot.io/api/?q=${Uri.encodeComponent(query)}&limit=10",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          // This identifies your app to the server. Replace 'VetNow' with your actual app name.
          'User-Agent': 'VetNowApp_Flutter_Client_v1.0',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List features = data['features'];

        // Inside AddressService.searchAddress mapping logic
        return features.map((item) {
          final props = item['properties'];

          // Try to find the most specific local area name
          String city = props['city'] ??
              props['town'] ??
              props['village'] ??
              props['district'] ??  // Very common in India
              props['suburb'] ??
              props['locality'] ??
              "";

          String state = props['state'] ?? "";
          String country = props['country'] ?? "";

          // If city is still empty, use the name of the place itself
          if (city.isEmpty && props['name'] != state && props['name'] != country) {
            city = props['name'] ?? "";
          }

          // Generate a clean full address
          String full = [city, state, country]
              .where((s) => s != null && s.toString().isNotEmpty)
              .join(", ");

          return SearchAddressModel(
            fullAddress: full,
            city: city,
            state: state,
            country: country,
          );
        }).toList();
      } else {
        // Log the error to see if it's still 403
        print("Search API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Search Catch Error: $e");
      return [];
    }
  }
}
