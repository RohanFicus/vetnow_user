import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/domain/entities/payment_verify_request.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/confirmation_screen.dart';

import '../../../../core/theme/app_color.dart';
import '../components/AppButton.dart';
import '../components/app_bar.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final String selectedTime;
  final AppointmentRequest? appointmentRequest;

  const PaymentSummaryScreen({
    super.key,
    required this.selectedTime,
    this.appointmentRequest,
  });

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  late Razorpay _razorpay;
  bool _isPaymentStarted = false; // Prevent multiple calls
  bool _hasAutoTriggered = false; // Prevents auto-reopening loop after failure
  bool _isPaymentCompleted = false; // Lock once payment success callback is received

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _isPaymentStarted = false;
    _isPaymentCompleted = true;
    if (!mounted) return;
    final state = context.read<DashboardBloc>().state;
    final appointmentId = state.lastBookedAppointment?.appointmentId;
    if (appointmentId != null) {
      context.read<DashboardBloc>().add(
        VerifyPaymentEvent(
          PaymentVerifyRequest(
            appointmentId: appointmentId,
            razorpayOrderId: response.orderId ??
                state.lastBookedAppointment?.paymentOrderId ??
                '',
            razorpayPaymentId: response.paymentId ?? '',
            razorpaySignature: response.signature ?? '',
          ),
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _isPaymentStarted = false;
    _isPaymentCompleted = false;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _isPaymentStarted = false;
    _isPaymentCompleted = false;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void _startPayment(int amount, String? orderId) {
    if (_isPaymentStarted || _isPaymentCompleted) return;
    _isPaymentStarted = true;

    final user = context.read<DashboardBloc>().state.user;
    final Map<String, dynamic> options = {
      'key': 'rzp_live_TcIvBGGoxl1A49',
      'amount': amount,
      'name': 'VetNow',
      'description': 'Appointment Booking',
    };

    final Map<String, dynamic> prefill = {};
    if (user?.mobile != null && user!.mobile!.trim().isNotEmpty) {
      prefill['contact'] = user.mobile!.trim();
    }
    if (user?.email != null && user!.email!.trim().isNotEmpty) {
      prefill['email'] = user.email!.trim();
    }
    if (prefill.isNotEmpty) {
      options['prefill'] = prefill;
    }

    if (orderId != null && !orderId.contains("demo") && orderId.trim().isNotEmpty) {
      options['order_id'] = orderId.trim();
    }

    try {
      _razorpay.open(options);
    } catch (e) {
      _isPaymentStarted = false;
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.bookingSuccess &&
            state.lastBookedAppointment != null &&
            !state.isLoading &&
            !_isPaymentStarted &&
            !_hasAutoTriggered &&
            !_isPaymentCompleted &&
            !state.paymentSuccess) {
          _hasAutoTriggered = true;
          _startPayment(
            state.lastBookedAppointment!.amount,
            state.lastBookedAppointment!.paymentOrderId,
          );
        }

        if (state.paymentSuccess) {
          final int feePaise = state.lastBookedAppointment?.amount ?? 110000;
          final fee = (feePaise / 100).toStringAsFixed(2);
          final dashboardBloc = context.read<DashboardBloc>();
          // Allow Razorpay native Android SDK 1-second redirect animation to complete smoothly
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: dashboardBloc,
                  child: ConfirmationScreen(
                    appointmentRequest: widget.appointmentRequest,
                    selectedTime: widget.selectedTime,
                    fee: fee,
                  ),
                ),
              ),
            );
          });
        }

        if (state.error != null && !state.bookingSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final int feePaise = state.lastBookedAppointment?.amount ?? 110000;
          final double fee = feePaise / 100;
          final double total = fee;

          return Scaffold(
            backgroundColor: context.appBackground,
            appBar: buildSimpleAppBar(context, "Book Appointment"),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _card(
                    context,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Consultation Fee",
                          style: TextStyle(color: context.appMutedText),
                        ),
                        Text(
                          "₹${fee.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.appText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _card(
                    context,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Slot Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.appText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.appBorder),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.selectedTime,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: context.appText,
                                      ),
                                    ),
                                    Text(
                                      "${widget.appointmentRequest?.appointmentDate ?? '15 December 2025'} | ₹${fee.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: context.appMutedText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _card(
                    context,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Booking Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.appText,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _priceRow(context, "Slots Booked", "1x Slot"),
                        _priceRow(
                          context,
                          "Slots Price",
                          "₹${fee.toStringAsFixed(2)}",
                        ),
                        _priceRow(context, "Convenience Fee", "0.0"),
                        Divider(height: 30, color: context.appBorder),
                        _priceRow(
                          context,
                          "Amount to Pay",
                          "₹${total.toStringAsFixed(2)}",
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${total.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: context.appText,
                            ),
                          ),
                          Text(
                            "including all taxes",
                            style: TextStyle(
                              color: context.appMutedText,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 150,
                        height: 45,
                        child: AppButton(
                          text: state.isLoading ? "Loading..." : "Pay Now",
                          textColor: Colors.white,
                          color: AppColors.primary,
                          onPressed: state.isLoading || state.paymentSuccess || _isPaymentCompleted
                              ? null
                              : () {
                                  if (state.lastBookedAppointment != null) {
                                    _startPayment(
                                      state.lastBookedAppointment!.amount,
                                      state
                                          .lastBookedAppointment!
                                          .paymentOrderId,
                                    );
                                  } else if (widget.appointmentRequest !=
                                      null) {
                                    context.read<DashboardBloc>().add(
                                      BookAppointmentEvent(
                                        widget.appointmentRequest!,
                                      ),
                                    );
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.appBorder),
      boxShadow: [BoxShadow(color: context.appShadow, blurRadius: 5)],
    ),
    child: child,
  );

  Widget _priceRow(
    BuildContext context,
    String label,
    String val, {
    bool isBold = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? context.appText : context.appMutedText,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: context.appText,
          ),
        ),
      ],
    ),
  );
}
