import 'dart:io';

class AppointmentRequest {
  final String doctorId;
  final String petId;
  final String speciesId;
  final String appointmentDate;
  final String appointmentTime;
  final String consultationType;
  final String notes;
  final String symptomIds;
  final File? attachments;

  AppointmentRequest({
    required this.doctorId,
    required this.petId,
    required this.speciesId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.consultationType,
    required this.notes,
    required this.symptomIds,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'petId': petId,
      'speciesId': speciesId,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'consultationType': consultationType,
      'notes': notes,
      'symptomIds': symptomIds,
    };
  }
}
