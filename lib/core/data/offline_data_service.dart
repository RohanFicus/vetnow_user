import 'dart:convert';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';
import '../../features/auth/data/models/dashboard_response_model.dart';

class OfflineDataService {
  static final OfflineDataService _instance = OfflineDataService._internal();
  factory OfflineDataService() => _instance;
  OfflineDataService._internal();

  late Box _offlineDataBox;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        _offlineDataBox = await Hive.openBox(AppConstants.offlineDataBoxName);
        _isInitialized = true;
        print('OfflineDataService initialized successfully');
      } catch (e) {
        print('Error initializing OfflineDataService: $e');
      }
    }
  }

  // Initialize dummy data if empty
  Future<void> initializeDummyData() async {
    await initialize();

    if (_offlineDataBox.isEmpty) {
      print('Initializing dummy data...');
      await _populateDummyData();
    }
  }

  // Dashboard data
  Future<DashBoardResponseModal?> getDashboardData() async {
    await initialize();

    try {
      final cachedData = _offlineDataBox.get(AppConstants.dashboardDataKey);
      if (cachedData != null) {
        return DashBoardResponseModal.fromJson(jsonDecode(cachedData));
      }

      // Return dummy data if no cached data
      return _getDummyDashboardData();
    } catch (e) {
      print('Error getting dashboard data: $e');
      return _getDummyDashboardData();
    }
  }

  Future<void> cacheDashboardData(DashBoardResponseModal data) async {
    await initialize();

    try {
      await _offlineDataBox.put(
        AppConstants.dashboardDataKey,
        jsonEncode(data.toJson()),
      );
      print('Dashboard data cached successfully');
    } catch (e) {
      print('Error caching dashboard data: $e');
    }
  }

  // Pet data
  Future<List<Pets>> getPetsData() async {
    await initialize();

    try {
      final cachedData = _offlineDataBox.get(AppConstants.petsDataKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        return jsonList.map((json) => Pets.fromJson(json)).toList();
      }

      return _getDummyPetsData();
    } catch (e) {
      print('Error getting pets data: $e');
      return _getDummyPetsData();
    }
  }

  Future<void> cachePetsData(List<Pets> pets) async {
    await initialize();

    try {
      await _offlineDataBox.put(
        AppConstants.petsDataKey,
        jsonEncode(pets.map((pet) => pet.toJson()).toList()),
      );
      print('Pets data cached successfully');
    } catch (e) {
      print('Error caching pets data: $e');
    }
  }

  // Appointments data
  Future<List<AppointmentResponse>> getAppointmentsData() async {
    await initialize();

    try {
      final cachedData = _offlineDataBox.get(AppConstants.appointmentsDataKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        return jsonList
            .map((json) => AppointmentResponse.fromJson(json))
            .toList();
      }

      return _getDummyAppointmentsData();
    } catch (e) {
      print('Error getting appointments data: $e');
      return _getDummyAppointmentsData();
    }
  }

  Future<void> cacheAppointmentsData(
    List<AppointmentResponse> appointments,
  ) async {
    await initialize();

    try {
      await _offlineDataBox.put(
        AppConstants.appointmentsDataKey,
        jsonEncode(appointments.map((apt) => apt.toJson()).toList()),
      );
      print('Appointments data cached successfully');
    } catch (e) {
      print('Error caching appointments data: $e');
    }
  }

  // Clear all cached data
  Future<void> clearAllData() async {
    await initialize();

    try {
      await _offlineDataBox.clear();
      print('All offline data cleared');
    } catch (e) {
      print('Error clearing offline data: $e');
    }
  }

  // Check if data is available offline
  bool hasOfflineData(String key) {
    return _offlineDataBox.containsKey(key);
  }

  // Get last updated timestamp
  DateTime? getLastUpdated(String key) {
    final timestamp = _offlineDataBox.get('${key}_timestamp');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  // Set last updated timestamp
  Future<void> setLastUpdated(String key) async {
    await initialize();
    await _offlineDataBox.put(
      '${key}_timestamp',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Dummy Data Generation Methods
  Future<void> _populateDummyData() async {
    // Cache dummy dashboard data
    await cacheDashboardData(_getDummyDashboardData());
    await setLastUpdated(AppConstants.dashboardDataKey);

    // Cache dummy pets data
    await cachePetsData(_getDummyPetsData());
    await setLastUpdated(AppConstants.petsDataKey);

    // Cache dummy appointments data
    await cacheAppointmentsData(_getDummyAppointmentsData());
    await setLastUpdated(AppConstants.appointmentsDataKey);

    print('Dummy data populated successfully');
  }

  DashBoardResponseModal _getDummyDashboardData() {
    return DashBoardResponseModal(
      user: _getDummyUser(),
      pets: _getDummyPetsData(),
      doctorProfileResponse: _getDummyDoctorProfile(),
      appointmentResponseList: _getDummyAppointmentsData(),
    );
  }

  User _getDummyUser() {
    return User(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      mobile: '+1234567890',
      role: 'pet_owner',
      address: '123 Main St, City, State 12345',
      profileImage: 'https://picsum.photos/seed/user1/200/200.jpg',
      isActive: true,
    );
  }

  List<Pets> _getDummyPetsData() {
    return [
      Pets(
        profile: Profile(
          id: '1',
          petUniqueId: 'PET001',
          speciesId: '1',
          speciesName: 'Dog',
          breedId: '1',
          breedName: 'Golden Retriever',
          name: 'Max',
          dateOfBirth: '2021-01-15',
          ageMonths: 36,
          sex: 'Male',
          isNeutered: true,
          isSpayed: false,
          isMilking: false,
          isPregnant: false,
          weightKg: 30.5,
          color: 'Golden',
          profileCompleted: true,
          isActive: true,
          createdAt: '2023-01-01',
          updatedAt: '2024-01-01',
        ),
        vaccinations: [],
        documents: [],
        latestAssessment: LatestAssessment(
          assessmentId: '1',
          assessmentType: 'health',
          totalScore: 85,
          overallRisk: OverallRisk(
            level: 'Low',
            severity: 1,
            labelEn: 'Healthy',
            descriptionEn: 'Your pet is in good health.',
          ),
          assessedAt: '2024-05-01T10:00:00Z',
        ),
      ),
      Pets(
        profile: Profile(
          id: '2',
          petUniqueId: 'PET002',
          speciesId: '2',
          speciesName: 'Cat',
          breedId: '2',
          breedName: 'Persian',
          name: 'Luna',
          dateOfBirth: '2022-03-20',
          ageMonths: 24,
          sex: 'Female',
          isNeutered: false,
          isSpayed: true,
          isMilking: false,
          isPregnant: false,
          weightKg: 4.2,
          color: 'White',
          profileCompleted: true,
          isActive: true,
          createdAt: '2023-03-01',
          updatedAt: '2024-01-01',
        ),
        vaccinations: [],
        documents: [],
        latestAssessment: LatestAssessment(
          assessmentId: '2',
          assessmentType: 'health',
          totalScore: 70,
          overallRisk: OverallRisk(
            level: 'Moderate',
            severity: 2,
            labelEn: 'Attention Needed',
            descriptionEn: 'Monitor your pet closely.',
          ),
          assessedAt: '2024-05-15T14:30:00Z',
        ),
      ),
      Pets(
        profile: Profile(
          id: '3',
          petUniqueId: 'PET003',
          speciesId: '1',
          speciesName: 'Dog',
          breedId: '3',
          breedName: 'Beagle',
          name: 'Charlie',
          dateOfBirth: '2020-05-10',
          ageMonths: 48,
          sex: 'Male',
          isNeutered: true,
          isSpayed: false,
          isMilking: false,
          isPregnant: false,
          weightKg: 15.3,
          color: 'Tricolor',
          profileCompleted: true,
          isActive: true,
          createdAt: '2023-05-01',
          updatedAt: '2024-01-01',
        ),
        vaccinations: [],
        documents: [],
        latestAssessment: null,
      ),
    ];
  }

  List<AppointmentResponse> _getDummyAppointmentsData() {
    final now = DateTime.now();
    return [
      AppointmentResponse(
        id: '1',
        doctor: _getDummyAppointmentDoctor(
          '1',
          'Dr. Sarah Johnson',
          'General Veterinary Medicine',
        ),
        petOwner: _getDummyAppointmentPetOwner('1', 'John Doe', '+1234567890'),
        pet: _getDummyAppointmentPet('1', 'Max', '1', '1', 'Dog', 'Golden Retriever'),
        species: _getDummySpecies('1', 'Dog'),
        appointmentDate: now
            .add(const Duration(days: 2))
            .toString()
            .split(' ')[0],
        appointmentTime: '10:00',
        bookedBy: '1',
        status: 'scheduled',
        amount: 500,
        paymentStatus: 'pending',
        isExpired: false,
        dashboardStatus: 'upcoming',
        notes: 'Annual health examination and vaccination update',
        consultationType: 'in_person',
        createdAt: now.subtract(const Duration(days: 1)).toString(),
        updatedAt: now.toString(),
        appointmentAttachmentResponse: [],
      ),
      AppointmentResponse(
        id: '2',
        doctor: _getDummyAppointmentDoctor('2', 'Dr. Michael Chen', 'Surgery'),
        petOwner: _getDummyAppointmentPetOwner('1', 'John Doe', '+1234567890'),
        pet: _getDummyAppointmentPet('2', 'Luna', '2', '2', 'Cat', 'Persian'),
        species: _getDummySpecies('2', 'Cat'),
        appointmentDate: now
            .add(const Duration(days: 5))
            .toString()
            .split(' ')[0],
        appointmentTime: '14:30',
        bookedBy: '1',
        status: 'scheduled',
        amount: 800,
        paymentStatus: 'pending',
        isExpired: false,
        dashboardStatus: 'upcoming',
        notes: 'Full grooming and nail trimming',
        consultationType: 'in_person',
        createdAt: now.subtract(const Duration(days: 3)).toString(),
        updatedAt: now.toString(),
        appointmentAttachmentResponse: [],
      ),
      AppointmentResponse(
        id: '3',
        doctor: _getDummyAppointmentDoctor(
          '1',
          'Dr. Sarah Johnson',
          'General Veterinary Medicine',
        ),
        petOwner: _getDummyAppointmentPetOwner('1', 'John Doe', '+1234567890'),
        pet: _getDummyAppointmentPet('1', 'Max', '1', '1', 'Dog', 'Golden Retriever'),
        species: _getDummySpecies('1', 'Dog'),
        appointmentDate: now
            .subtract(const Duration(days: 7))
            .toString()
            .split(' ')[0],
        appointmentTime: '11:00',
        bookedBy: '1',
        status: 'completed',
        amount: 500,
        paymentStatus: 'paid',
        isExpired: false,
        dashboardStatus: 'completed',
        notes: 'Rabies vaccine administered',
        consultationType: 'in_person',
        createdAt: now.subtract(const Duration(days: 8)).toString(),
        updatedAt: now.subtract(const Duration(days: 7)).toString(),
        appointmentAttachmentResponse: [],
      ),
    ];
  }


  DoctorProfileResponse _getDummyDoctorProfile() {
    return DoctorProfileResponse(
      doctorId: '1',
      userId: '1',
      fullName: 'Dr. Sarah Johnson',
      email: 'sarah.johnson@vetclinic.com',
      mobile: '+1234567891',
      profileImage: 'https://picsum.photos/seed/doctor1/200/200.jpg',
      approvalStatus: 'approved',
      consultationFee: 150,
      commissionPercent: 10.0,
      isEnabled: true,
      createdAt: '2022-01-01',
      updatedAt: '2024-01-01',
      doctorAvailabilityResponse: DoctorAvailabilityResponse(
        id: '1',
        doctorId: '1',
        workingDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        slotDurationMinutes: 30,
        morningActive: true,
        morningStart: '09:00',
        morningEnd: '12:00',
        afternoonActive: true,
        afternoonStart: '14:00',
        afternoonEnd: '18:00',
        eveningActive: false,
        eveningStart: '18:00',
        eveningEnd: '20:00',
        isActive: true,
      ),
    );
  }

  // Helper methods for creating dummy nested objects
  AppointmentDoctor _getDummyAppointmentDoctor(
    String doctorId,
    String name,
    String specialization,
  ) {
    return AppointmentDoctor(
      doctorId: doctorId,
      userId: doctorId,
      fullName: name,
      email: '${name.toLowerCase().replaceAll(' ', '.')}@vetclinic.com',
      mobile: '+123456789${doctorId}',
      approvalStatus: 'approved',
      consultationFee: 150,
      commissionPercent: 10.0,
      isEnabled: true,
      createdAt: '2022-01-01',
      updatedAt: '2024-01-01',
    );
  }

  AppointmentPetOwner _getDummyAppointmentPetOwner(
    String id,
    String name,
    String mobile,
  ) {
    return AppointmentPetOwner(
      id: id,
      firstName: name.split(' ')[0],
      lastName: name.split(' ')[1],
      email: '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
      mobile: mobile,
      countryCode: '+1',
      address: '123 Main St, City, State 12345',
      role: 'pet_owner',
      profileImage: 'https://picsum.photos/seed/owner$id/200/200.jpg',
      isActive: true,
    );
  }

  AppointmentPet _getDummyAppointmentPet(
    String id,
    String name,
    String speciesId,
    String breedId,
    String speciesName,
    String breedName,
  ) {
    return AppointmentPet(
      id: id,
      name: name,
      speciesId: speciesId,
      breedId: breedId,
      speciesName: speciesName,
      breedName: breedName,
      isActive: true,
    );
  }

  Species _getDummySpecies(String id, String name) {
    return Species(id: id, nameEn: name, isActive: true);
  }
}
