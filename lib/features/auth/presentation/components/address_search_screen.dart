import 'package:flutter/material.dart';
import '../../data/models/SearchAddressModel.dart';
import '../components/address_service.dart'; // Adjust path
import 'dart:async'; // Required for Timer


class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final _service = AddressService();
  List<SearchAddressModel> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  void _onSearch(String query) {
    // Cancel the previous timer if user types again
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length < 3) {
        setState(() => _results = []);
        return;
      }

      setState(() => _isLoading = true);
      final results = await _service.searchAddress(query);

      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    });
  }


  @override
  void dispose() {
    _debounce?.cancel(); // Clean up the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Address", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search city, area or street...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _onSearch,
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(item.fullAddress, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text("${item.city}, ${item.state}"),
                  onTap: () => Navigator.pop(context, item), // Return the model
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}