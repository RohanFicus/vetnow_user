class AppointmentBookingResponseModel {
  final String appointmentId;
  final String paymentOrderId;
  final int amount;

  AppointmentBookingResponseModel({
    required this.appointmentId,
    required this.paymentOrderId,
    required this.amount,
  });

  factory AppointmentBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingResponseModel(
      appointmentId: json['appointmentId'] ?? '',
      paymentOrderId: json['paymentOrderId'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'paymentOrderId': paymentOrderId,
      'amount': amount,
    };
  }
}
