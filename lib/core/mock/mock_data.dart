import 'package:vetnow_user/features/auth/data/models/assessment_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/assessment_success_model.dart' as success;
import 'package:vetnow_user/features/auth/data/models/complete_profile_response.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/otp_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/owner_profile_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/pet_profile_1_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/meta_model.dart';
import 'package:vetnow_user/features/auth/data/models/symptoms_response_model.dart';

class MockData {
  static Future<void> latency() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  static List<SymptomsResponseModel> symptoms({String speciesId = ''}) {
    return [
      SymptomsResponseModel(
        id: 's1',
        nameEn: 'Fever',
        nameHi: 'बुखार',
        description: 'Elevated body temperature',
        isActive: true,
      ),
      SymptomsResponseModel(
        id: 's2',
        nameEn: 'Vomiting',
        nameHi: 'उल्टी',
        description: 'Frequent vomiting',
        isActive: true,
      ),
      SymptomsResponseModel(
        id: 's3',
        nameEn: 'Diarrhea',
        nameHi: 'दस्त',
        description: 'Loose stools',
        isActive: true,
      ),
      SymptomsResponseModel(
        id: 's4',
        nameEn: 'Loss of Appetite',
        nameHi: 'भूख न लगना',
        description: 'Refusal to eat',
        isActive: true,
      ),
    ];
  }

  static OtpResponseModel otpResponse() {
    return OtpResponseModel(requestId: 'mock-request-id', expiresIn: 120);
  }

  static MetaModel tokenMeta() {
    return MetaModel(
      token: TokenModel(
        accessToken: 'mock-access-token',
        expiresIn: 3600,
        refreshToken: 'mock-refresh-token',
      ),
    );
  }

  static OwnerProfileResponseModel ownerProfile({
    String firstName = 'Rohan',
    String lastName = 'Singh',
    String email = 'rohan@example.com',
    String address = 'Bandra, Mumbai, India',
  }) {
    return OwnerProfileResponseModel(
      id: 'owner-001',
      firstName: firstName,
      lastName: lastName,
      email: email,
      mobile: '+91 9876543210',
      address: address,
      role: 'PET_OWNER',
      profileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80',
      isActive: true,
    );
  }

  static DashBoardResponseModal dashboard() {
    return DashBoardResponseModal(
      user: User(
        id: 'owner-001',
        firstName: 'Rohan',
        lastName: 'Singh',
        email: 'rohan@example.com',
        mobile: '+91 9876543210',
        role: 'PET_OWNER',
        address: 'Bandra, Mumbai, India',
        profileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80',
        isActive: true,
      ),
      pets: [
        Pets(
          profile: Profile(
            id: 'pet-001',
            petUniqueId: 'VET-PET-001',
            speciesId: 'species-dog',
            speciesName: 'Dog',
            breedId: 'breed-lab',
            breedName: 'Labrador Retriever',
            name: 'Bruno',
            dateOfBirth: '2022-01-15',
            ageMonths: 26,
            sex: 'MALE',
            isNeutered: true,
            isSpayed: false,
            isMilking: false,
            isPregnant: false,
            weightKg: 24.5,
            color: 'Golden',
            qrCodeFileName: 'bruno-qr.png',
            profileCompleted: true,
            isActive: true,
            createdAt: '2025-01-01T10:00:00Z',
            updatedAt: '2025-02-01T10:00:00Z',
          ),
          vaccinations: [
            Vaccinations(
              vaccineId: 'vac-rabies',
              vaccineName: 'Rabies',
              vaccineCode: 'RAB',
              status: 'DONE',
              vaccinationDate: '2025-01-03',
            ),
            Vaccinations(
              vaccineId: 'vac-dhlpp',
              vaccineName: 'DHLPP',
              vaccineCode: 'DHLPP',
              status: 'DUE',
              vaccinationDate: '2025-07-03',
            ),
          ],
          documents: [
            DocumentsDetail(
              id: 'doc-001',
              petId: 'pet-001',
              documentType: 'VACCINATION',
              fileUrl: 'https://example.com/mock-vaccination-card.pdf',
              fileName: 'vaccination-card.pdf',
              fileSizeKb: 320,
              createdAt: '2025-01-03T10:00:00Z',
            ),
          ],
          latestAssessment: LatestAssessment(
            assessmentId: 'mock-assessment-001',
            totalScore: 950,
            overallRisk: OverallRisk(
              level: 'LOW',
              severity: 1,
              labelEn: 'Low Risk',
              descriptionEn: 'Bruno looks healthy overall.',
            ),
            warningMessage: WarningMessage(
              textEn: 'Pet appears healthy.',
            ),
          ),
        ),
        Pets(
          profile: Profile(
            id: 'pet-002',
            petUniqueId: 'VET-PET-002',
            speciesId: 'species-cat',
            speciesName: 'Cat',
            breedId: 'breed-persian',
            breedName: 'Persian',
            name: 'Milo',
            dateOfBirth: '2023-03-12',
            ageMonths: 14,
            sex: 'FEMALE',
            isNeutered: false,
            isSpayed: true,
            isMilking: false,
            isPregnant: false,
            weightKg: 4.2,
            color: 'White',
            qrCodeFileName: 'milo-qr.png',
            profileCompleted: true,
            isActive: true,
            createdAt: '2025-03-01T10:00:00Z',
            updatedAt: '2025-03-12T10:00:00Z',
          ),
          vaccinations: [
            Vaccinations(
              vaccineId: 'vac-fvr',
              vaccineName: 'FVRCP',
              vaccineCode: 'FVRCP',
              status: 'DONE',
              vaccinationDate: '2025-02-10',
            ),
          ],
          documents: [],
          latestAssessment: LatestAssessment(
            assessmentId: 'mock-assessment-002',
            totalScore: 700,
            overallRisk: OverallRisk(
              level: 'MEDIUM',
              severity: 2,
              labelEn: 'Medium Risk',
              descriptionEn: 'Milo may need closer observation for appetite.',
            ),
            warningMessage: WarningMessage(
              textEn: 'Monitor appetite.',
            ),
          ),
        ),
      ],
      doctorProfileResponse: DoctorProfileResponse(
        doctorId: 'doc-001',
        userId: 'user-doc-001',
        fullName: 'Aisha Mehta',
        email: 'dr.aisha@vetnow.app',
        mobile: '+91 9988776655',
        profileImage: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&q=80',
        approvalStatus: 'APPROVED',
        consultationFee: 499,
        commissionPercent: 10,
        isEnabled: true,
        createdAt: '2025-01-01T10:00:00Z',
        updatedAt: '2025-01-01T10:00:00Z',
        doctorAvailabilityResponse: DoctorAvailabilityResponse.fromJson({
          'id': 'availability-001',
          'doctorId': 'doc-001',
          'workingDays': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
          'slotDurationMinutes': 20,
          'morningActive': true,
          'morningStart': '09:00',
          'morningEnd': '12:00',
          'afternoonActive': true,
          'afternoonStart': '13:00',
          'afternoonEnd': '16:00',
          'eveningActive': true,
          'eveningStart': '18:00',
          'eveningEnd': '20:00',
          'isActive': true,
        }),
      ),
      appointmentResponseList: [
        AppointmentResponse(
          id: 'f53de4ff-b308-4d5b-a8f2-9e69d3cc847c',
          doctor: AppointmentDoctor(
            doctorId: 'e4c78f87-d237-4588-8560-fece13f8fb7d',
            userId: 'f7b719c3-c478-48d7-a30d-981d7ea64cd6',
            fullName: 'Akash Singh',
            email: 'akash.singh@vetnow.com',
            mobile: '9992593104',
            approvalStatus: 'APPROVED',
            consultationFee: 300,
            isEnabled: true,
            createdAt: '2026-04-07T15:13:54.588975Z',
          ),
          petOwner: AppointmentPetOwner(
            id: 'c31afa06-ce03-46b5-a73d-d04b522840a3',
            firstName: 'Akash',
            lastName: 'Singh',
            email: 'akash.thakur5515@gmail.com',
            mobile: '9992593199',
            countryCode: '+91',
            address: 'House No - 145, Bata Colony, Sirsa, haryana',
            role: 'PET_OWNER',
            profileImage:
                'http://gwen-postmycotic-overtrustfully.ngrok-free.dev/uploads/profiles/46a02b63-9858-4702-b8d6-28baef21e8a2.jpeg',
            isActive: true,
          ),
          pet: AppointmentPet(
            id: '03fabace-8957-439c-96dc-5f01be7afedf',
            petUniqueId: 'VN-2026-000001',
            speciesId: '206567a7-0802-4a8d-8250-35ddad464c15',
            speciesName: 'Dog',
            breedId: 'b50e929b-ace7-42b6-986c-7c26f036a07a',
            breedName: 'Desi Dog',
            name: 'Tiger 3',
            dateOfBirth: '2023-05-10',
            ageMonths: 24,
            sex: 'FEMALE',
            isNeutered: false,
            isSpayed: true,
            isMilking: false,
            isPregnant: false,
            weightKg: 6.5,
            color: 'white',
            qrCodeFileName:
                'http://gwen-postmycotic-overtrustfully.ngrok-free.dev/uploads/pets/qr/d916ae76-426a-4210-8dae-013e98ed8114.png',
            profileCompleted: true,
            isActive: true,
            profileImage: '',
            createdAt: '2026-04-11T09:24:42.463340Z',
            updatedAt: '2026-04-11T09:28:04.963099Z',
          ),
          species: Species(
            id: '206567a7-0802-4a8d-8250-35ddad464c15',
            code: 'DOG',
            nameEn: 'Dog',
            nameHi: 'कुत्ता',
            iconUrl:
                'http://gwen-postmycotic-overtrustfully.ngrok-free.dev/uploads/species/bde7233d-c6cf-4e59-a65f-1e79162e98a6.jpeg',
            isActive: true,
            producesMilk: false,
          ),
          appointmentDate: '2026-04-13',
          appointmentTime: '10:30',
          bookedBy: 'PET_OWNER',
          status: 'PENDING_PAYMENT',
          paymentExpiresAt: '2026-04-12T16:38:23.708805Z',
          paymentStatus: 'PENDING',
          isExpired: false,
          dashboardStatus: 'PENDING_PAYMENT',
          notes: 'My pet has fever and vomiting',
          consultationType: 'VIDEO',
          createdAt: '2026-04-12T16:28:23.708805Z',
          updatedAt: '2026-04-12T16:28:23.708805Z',
          appointmentAttachmentResponse: [],
        ),
      ],
    );
  }

  static List<AssessmentResponseModel> assessmentQuestions() {
    return [
      AssessmentResponseModel(
        id: 'q-1',
        category: 'NUTRITION',
        questionEn: 'Which diet best describes {petName}?',
        questionHi: 'कौन सा आहार {petName} के लिए सही है?',
        inputType: 'OPTION',
        weight: 5,
        isMultiSelect: false,
        options: [
          OptionModel(id: '1', labelEn: 'Dry food', labelHi: 'ड्राई फूड', value: 'DRY', score: 2),
          OptionModel(id: '2', labelEn: 'Wet food', labelHi: 'वेट फूड', value: 'WET', score: 1),
          OptionModel(id: '3', labelEn: 'Mixed diet', labelHi: 'मिक्स्ड', value: 'MIX', score: 0),
        ],
      ),
      AssessmentResponseModel(
        id: 'q-2',
        category: 'ACTIVITY',
        questionEn: 'How active is {petName} on most days?',
        questionHi: 'अधिकतर दिनों में {petName} कितना सक्रिय है?',
        inputType: 'OPTION',
        weight: 5,
        isMultiSelect: false,
        options: [
          OptionModel(id: '4', labelEn: 'Very active', labelHi: 'बहुत सक्रिय', value: 'HIGH', score: 0),
          OptionModel(id: '5', labelEn: 'Moderately active', labelHi: 'मध्यम सक्रिय', value: 'MEDIUM', score: 1),
          OptionModel(id: '6', labelEn: 'Mostly resting', labelHi: 'ज्यादातर आराम', value: 'LOW', score: 2),
        ],
      ),
      AssessmentResponseModel(
        id: 'q-3',
        category: 'HEALTH',
        questionEn: 'Has {petName} shown any unusual symptoms recently?',
        questionHi: 'क्या हाल ही में {petName} में कोई असामान्य लक्षण दिखे हैं?',
        inputType: 'OPTION',
        weight: 8,
        isMultiSelect: false,
        options: [
          OptionModel(id: '7', labelEn: 'No symptoms', labelHi: 'कोई लक्षण नहीं', value: 'NONE', score: 0),
          OptionModel(id: '8', labelEn: 'Mild symptoms', labelHi: 'हल्के लक्षण', value: 'MILD', score: 2),
          OptionModel(id: '9', labelEn: 'Concerning symptoms', labelHi: 'चिंताजनक लक्षण', value: 'HIGH', score: 4),
        ],
      ),
    ];
  }

  static success.AssessmentSuccessModel assessmentSuccess({String petId = 'pet-001'}) {
    return success.AssessmentSuccessModel(
      assessmentId: 'assessment-001',
      pet: success.Pet(id: petId, name: 'Bruno'),
      assessmentType: 'GENERAL',
      totalScore: 18,
      overallRisk: success.OverallRisk(
        level: 'LOW',
        severity: 1,
        labelEn: 'Low risk',
        labelHi: 'कम जोखिम',
        descriptionEn: 'No major health concerns found in the mock assessment.',
        descriptionHi: 'मॉक असेसमेंट में कोई बड़ी समस्या नहीं मिली।',
      ),
      needsAttention: [
        success.NeedsAttention(
          category: 'NUTRITION',
          titleEn: 'Meal balance',
          titleHi: 'भोजन संतुलन',
          valueEn: 'Review meal portions once a week.',
          valueHi: 'सप्ताह में एक बार भोजन मात्रा जांचें।',
          severity: 'LOW',
        ),
      ],
      warningMessage: success.WarningMessage(
        textEn: 'This is mock assessment data for UI development.',
        textHi: 'यह UI विकास के लिए मॉक असेसमेंट डेटा है।',
      ),
      assessedAt: '2026-04-09T10:00:00Z',
    );
  }

  static List<SpeciesModel> species() {
    return [
      SpeciesModel(
        id: 'species-dog',
        code: 'DOG',
        nameEn: 'Dog',
        nameHi: 'कुत्ता',
        isActive: true,
        iconUrl: '',
      ),
      SpeciesModel(
        id: 'species-cat',
        code: 'CAT',
        nameEn: 'Cat',
        nameHi: 'बिल्ली',
        isActive: true,
        iconUrl: '',
      ),
    ];
  }

  static List<BreedsModel> breeds({required String speciesId}) {
    if (speciesId == 'species-cat') {
      return [
        BreedsModel(
          id: 'breed-persian',
          code: 'PERSIAN',
          nameEn: 'Persian',
          nameHi: 'पर्शियन',
          isActive: true,
          speciesId: speciesId,
        ),
        BreedsModel(
          id: 'breed-siamese',
          code: 'SIAMESE',
          nameEn: 'Siamese',
          nameHi: 'सियामी',
          isActive: true,
          speciesId: speciesId,
        ),
      ];
    }

    return [
      BreedsModel(
        id: 'breed-lab',
        code: 'LAB',
        nameEn: 'Labrador Retriever',
        nameHi: 'लैब्राडोर',
        isActive: true,
        speciesId: speciesId,
      ),
      BreedsModel(
        id: 'breed-golden',
        code: 'GOLDEN',
        nameEn: 'Golden Retriever',
        nameHi: 'गोल्डन रिट्रीवर',
        isActive: true,
        speciesId: speciesId,
      ),
    ];
  }

  static List<VaccineModel> vaccines({required String speciesId}) {
    if (speciesId == 'species-cat') {
      return [
        VaccineModel(
          id: 'vac-fvr',
          code: 'FVRCP',
          nameEn: 'FVRCP',
          nameHi: 'एफवीआरसीपी',
          descriptionEn: 'Core feline vaccine',
          descriptionHi: 'मुख्य बिल्ली वैक्सीन',
          isActive: true,
          speciesId: speciesId,
          vaccinationDate: '2025-02-10',
        ),
      ];
    }

    return [
      VaccineModel(
        id: 'vac-rabies',
        code: 'RAB',
        nameEn: 'Rabies',
        nameHi: 'रेबीज',
        descriptionEn: 'Anti-rabies vaccine',
        descriptionHi: 'रेबीज वैक्सीन',
        isActive: true,
        speciesId: speciesId,
        vaccinationDate: '2025-01-03',
      ),
      VaccineModel(
        id: 'vac-dhlpp',
        code: 'DHLPP',
        nameEn: 'DHLPP',
        nameHi: 'डीएचएलपीपी',
        descriptionEn: 'Core canine vaccine',
        descriptionHi: 'मुख्य कुत्ता वैक्सीन',
        isActive: true,
        speciesId: speciesId,
        vaccinationDate: '2025-07-03',
      ),
    ];
  }

  static PetProfileStep1 petStep1({
    String id = 'pet-003',
    String speciesId = 'species-dog',
    String breedId = 'breed-lab',
    String name = 'Coco',
    String sex = 'FEMALE',
    int ageMonths = 12,
    double weightKg = 7.5,
    String color = 'Brown',
  }) {
    return PetProfileStep1(
      id: id,
      petUniqueId: 'VET-$id',
      speciesId: speciesId,
      breedId: breedId,
      name: name,
      dateOfBirth: '2025-04-09',
      ageMonths: ageMonths,
      sex: sex,
      isSpayedNeutered: true,
      weightKg: weightKg,
      color: color,
      qrCodeFileName: '$id-qr.png',
      profileCompleted: false,
      createdAt: '2026-04-09T10:00:00Z',
      updatedAt: '2026-04-09T10:00:00Z',
    );
  }

  static CompleteProfileResponse completePetProfile({String petId = 'pet-003'}) {
    return CompleteProfileResponse(
      petResponse: PetResponse(
        id: petId,
        petUniqueId: 'VET-$petId',
        speciesId: 'species-dog',
        name: 'Coco',
        dateOfBirth: '2025-04-09',
        ageMonths: 12,
        sex: 'FEMALE',
        isSpayedNeutered: true,
        weightKg: 7.5,
        color: 'Brown',
        qrCodeFileName: '$petId-qr.png',
        profileCompleted: true,
        createdAt: '2026-04-09T10:00:00Z',
        updatedAt: '2026-04-09T10:00:00Z',
      ),
      petVaccinationResponse: [
        PetVaccinationResponse(
          vaccineId: 'vac-rabies',
          vaccineName: 'Rabies',
          vaccineCode: 'RAB',
          status: 'DONE',
          vaccinationDate: '2026-04-09',
        ),
      ],
      petDocumentResponse: [
        PetDocumentResponse(
          id: 'doc-002',
          petId: petId,
          documentType: 'VACCINATION',
          fileUrl: 'https://example.com/mock-vaccination.pdf',
          fileName: 'mock-vaccination.pdf',
          fileSizeKb: '256',
          createdAt: '2026-04-09T10:00:00Z',
        ),
      ],
    );
  }
}
