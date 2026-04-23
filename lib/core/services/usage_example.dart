import 'package:flutter/material.dart';
import 'offline_data_manager.dart';
import '../../features/auth/data/models/dashboard_response_model.dart';

/// Example usage of the Offline Data System for VetNow App
/// 
/// This file demonstrates how to use the offline data system in your Flutter app
/// to provide a seamless experience even when internet connectivity is lost.
class OfflineDataExample extends StatefulWidget {
  const OfflineDataExample({super.key});

  @override
  State<OfflineDataExample> createState() => _OfflineDataExampleState();
}

class _OfflineDataExampleState extends State<OfflineDataExample> {
  final OfflineDataManager _offlineDataManager = OfflineDataManager();
  
  DashBoardResponseModal? _dashboardData;
  List<Pets>? _pets;
  List<AppointmentResponse>? _appointments;
  bool _isLoading = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    
    try {
      // Initialize the offline data manager
      await _offlineDataManager.initialize();
      
      // Load all data
      await _loadAllData();
      
      // Listen to connectivity changes
      _offlineDataManager.connectivityStream.listen((isConnected) {
        setState(() {
          _isConnected = isConnected;
        });
      });
      
      setState(() => _isConnected = _offlineDataManager.isConnected);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initializing: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAllData() async {
    try {
      // Load dashboard data
      final dashboard = await _offlineDataManager.getDashboardData();
      final pets = await _offlineDataManager.getPetsData();
      final appointments = await _offlineDataManager.getAppointmentsData();
      
      setState(() {
        _dashboardData = dashboard;
        _pets = pets;
        _appointments = appointments;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _refreshData() async {
    await _loadAllData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data refreshed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _clearCache() async {
    await _offlineDataManager.clearAllData();
    await _loadAllData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared and reloaded'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VetNow - Offline Data Example'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          // Connectivity indicator
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isConnected ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _isConnected ? 'Online' : 'Offline',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Section
                    if (_dashboardData?.user != null) ...[
                      _buildUserProfileSection(_dashboardData!.user!),
                      const SizedBox(height: 24),
                    ],
                    
                    // Pets Section
                    if (_pets != null && _pets!.isNotEmpty) ...[
                      _buildPetsSection(_pets!),
                      const SizedBox(height: 24),
                    ],
                    
                    // Appointments Section
                    if (_appointments != null && _appointments!.isNotEmpty) ...[
                      _buildAppointmentsSection(_appointments!),
                      const SizedBox(height: 24),
                    ],
                    
                    // Actions Section
                    _buildActionsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUserProfileSection(User user) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.profileImage ?? ''),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(user.email ?? ''),
                      Text(user.mobile ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetsSection(List<Pets> pets) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Pets (${pets.length})',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            ...pets.map((pet) => _buildPetCard(pet)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Pets pet) {
    final profile = pet.profile;
    if (profile == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.pets, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text('${profile.speciesName} - ${profile.breedName}'),
                Text('Age: ${profile.ageMonths ?? 0} months'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection(List<AppointmentResponse> appointments) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointments (${appointments.length})',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            ...appointments.map((apt) => _buildAppointmentCard(apt)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentResponse appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                appointment.appointmentDate ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  appointment.status ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Time: ${appointment.appointmentTime ?? ''}'),
          Text('Pet: ${appointment.pet?.name ?? ''}'),
          Text('Doctor: ${appointment.doctor?.fullName ?? ''}'),
          if (appointment.notes?.isNotEmpty == true)
            Text('Notes: ${appointment.notes}'),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActionsSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearCache,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Cache'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
