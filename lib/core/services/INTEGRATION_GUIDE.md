# VetNow Offline Data System - Integration Guide

## Overview
This comprehensive offline data system allows your VetNow app to function seamlessly even when internet connectivity is lost. The system automatically detects connectivity status and switches between online and offline modes.

## Features
- **Automatic Connectivity Detection**: Monitors internet status in real-time
- **Offline Data Storage**: Uses Hive for local data persistence
- **Dummy Data Generation**: Provides realistic sample data for testing
- **Seamless Fallback**: Automatically switches to cached/dummy data when offline
- **Data Caching**: Caches API responses for offline access
- **Real-time Updates**: Listens to connectivity changes and updates UI accordingly

## Quick Start

### 1. Initialize the System
In your `main.dart` or app initialization:

```dart
import 'package:vetnow_user/core/services/offline_data_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the offline data manager
  await OfflineDataManager().initialize();
  
  runApp(MyApp());
}
```

### 2. Use in Your Screens
```dart
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final OfflineDataManager _offlineDataManager = OfflineDataManager();
  DashBoardResponseModal? _dashboardData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final data = await _offlineDataManager.getDashboardData();
      setState(() {
        _dashboardData = data;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
        ? CircularProgressIndicator()
        : _buildDashboardContent(),
    );
  }
}
```

## Available Data Types

### Dashboard Data
```dart
final dashboard = await _offlineDataManager.getDashboardData();
// Contains: User, Pets, Doctor Profile, Appointments
```

### Pets Data
```dart
final pets = await _offlineDataManager.getPetsData();
// Returns List<Pets> with complete pet profiles
```

### Appointments Data
```dart
final appointments = await _offlineDataManager.getAppointmentsData();
// Returns List<AppointmentResponse> with appointment details
```

## Connectivity Monitoring

### Check Current Status
```dart
bool isConnected = _offlineDataManager.isConnected;
```

### Listen to Connectivity Changes
```dart
_offlineDataManager.connectivityStream.listen((isConnected) {
  if (isConnected) {
    print("Device is online");
    // Sync data, refresh UI, etc.
  } else {
    print("Device is offline");
    // Show offline indicator, use cached data
  }
});
```

## Data Management

### Cache Data
```dart
// Cache dashboard data
await _offlineDataManager.cacheDashboardData(dashboardData);

// Cache pets data
await _offlineDataManager.cachePetsData(petsList);

// Cache appointments data
await _offlineDataManager.cacheAppointmentsData(appointmentsList);
```

### Check Cache Status
```dart
// Check if data exists offline
bool hasData = _offlineDataManager.hasOfflineData('dashboard_data');

// Get last updated timestamp
DateTime? lastUpdated = _offlineDataManager.getLastUpdated('dashboard_data');
```

### Clear Cache
```dart
await _offlineDataManager.clearAllData();
```

## Dummy Data Structure

### User Profile
- Name: John Doe
- Email: john.doe@example.com
- Phone: +1234567890
- Role: pet_owner

### Pets
1. **Max** - Golden Retriever (Male, 3 years, 30.5kg)
2. **Luna** - Persian Cat (Female, 2 years, 4.2kg)
3. **Charlie** - Beagle (Male, 4 years, 15.3kg)

### Appointments
1. **Upcoming** - Max with Dr. Sarah Johnson (Annual checkup)
2. **Upcoming** - Luna with Dr. Michael Chen (Grooming)
3. **Completed** - Max with Dr. Sarah Johnson (Vaccination)

### Doctors
1. **Dr. Sarah Johnson** - General Veterinary Medicine
2. **Dr. Michael Chen** - Surgery
3. **Dr. Emily Rodriguez** - Dentistry

## UI Integration Tips

### Connectivity Indicator
```dart
StreamBuilder<bool>(
  stream: _offlineDataManager.connectivityStream,
  builder: (context, snapshot) {
    final isConnected = snapshot.data ?? true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            isConnected ? 'Online' : 'Offline',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  },
)
```

### Offline Banner
```dart
StreamBuilder<bool>(
  stream: _offlineDataManager.connectivityStream,
  builder: (context, snapshot) {
    final isConnected = snapshot.data ?? true;
    if (isConnected) return SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      color: Colors.orange,
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'You\'re offline. Showing cached data.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  },
)
```

## Error Handling

The system automatically falls back to offline data when:
- Internet connectivity is lost
- API calls fail
- Server is unreachable

Always wrap your data calls in try-catch blocks:

```dart
try {
  final data = await _offlineDataManager.getDashboardData();
  // Use data
} catch (e) {
  // Show error message or use cached data
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error loading data: $e')),
  );
}
```

## Testing Offline Mode

### 1. Enable Airplane Mode
Turn on airplane mode on your device to test offline functionality.

### 2. Disable WiFi/Mobile Data
Turn off WiFi and mobile data to simulate connectivity loss.

### 3. Use Development Tools
In Flutter development, you can use the connectivity settings to simulate different network conditions.

## Performance Considerations

- **Initialization**: The system initializes asynchronously and won't block your app startup
- **Memory Usage**: Data is cached efficiently using Hive's optimized storage
- **Battery**: Connectivity checks run every 5 seconds to balance battery usage and responsiveness
- **Storage**: All data is stored locally using Hive, providing fast access even offline

## Troubleshooting

### Common Issues

1. **Data Not Loading**: Ensure you've called `initialize()` before using the service
2. **Connectivity Not Updating**: Check that the connectivity service is properly initialized
3. **Cache Issues**: Use `clearAllData()` to reset the cache if needed
4. **Model Errors**: Ensure all model imports are correct and match your API responses

### Debug Tips

```dart
// Enable debug logging
debugPrint('Offline data initialized: ${_offlineDataManager.isConnected}');
debugPrint('Cache status: ${_offlineDataManager.hasOfflineData('dashboard_data')}');
debugPrint('Last updated: ${_offlineDataManager.getLastUpdated('dashboard_data')}');
```

## Best Practices

1. **Initialize Early**: Call `initialize()` as early as possible in your app lifecycle
2. **Handle Connectivity Changes**: Always listen to connectivity stream for real-time updates
3. **Cache Strategically**: Cache important data when online to ensure offline availability
4. **Provide Feedback**: Show clear indicators when the app is in offline mode
5. **Test Thoroughly**: Test both online and offline scenarios

## Support

For issues or questions about the offline data system:
1. Check this integration guide
2. Review the example implementation in `usage_example.dart`
3. Enable debug logging to troubleshoot specific issues
4. Test with different connectivity scenarios

---

This offline data system ensures your VetNow app provides a consistent, reliable experience regardless of internet connectivity, keeping your users engaged and productive at all times.
