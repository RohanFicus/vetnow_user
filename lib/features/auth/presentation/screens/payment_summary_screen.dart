import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';

import '../components/app_bar.dart';
import '../components/AppButton.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vetnow_user/features/auth/domain/entities/payment_verify_request.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/screens/confirmation_screen.dart';
import '../../../../core/theme/app_color.dart';

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
    final appointmentId =
        context.read<DashboardBloc>().state.lastBookedAppointment?.appointmentId;
    if (appointmentId != null) {
      context.read<DashboardBloc>().add(
            VerifyPaymentEvent(
              PaymentVerifyRequest(
                appointmentId: appointmentId,
                razorpayOrderId: response.orderId ?? '',
                razorpayPaymentId: response.paymentId ?? '',
                razorpaySignature: response.signature ?? '',
              ),
            ),
          );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _isPaymentStarted = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _isPaymentStarted = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void _startPayment(int amount, String? orderId) {
    if (_isPaymentStarted) return;
    _isPaymentStarted = true;

    var options = {
      'key': 'rzp_test_Sd1PKsnAE8I24x',
      'amount': amount,
      'name': 'VetNow',
      'description': 'Appointment Booking',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': context.read<DashboardBloc>().state.user?.mobile ?? '',
        'email': context.read<DashboardBloc>().state.user?.email ?? '',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    if (orderId != null && !orderId.contains("demo")) {
      options['order_id'] = orderId;
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
        }

        if (state.error != null && !state.bookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final int feePaise = state.lastBookedAppointment?.amount ?? 110000;
          final double fee = feePaise / 100;
          final double total = fee + 20;

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
                              const Icon(Icons.cancel,
                                  color: Colors.red, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _card(
                    context,
                    Row(
                      children: [
                        const Icon(Icons.percent, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          "Apply Coupon",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: context.appText,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.chevron_right, color: context.appMutedText),
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
                        _priceRow(context, "Slots Price", "₹${fee.toStringAsFixed(2)}"),
                        _priceRow(context, "Convenience Fee", "+₹20.00"),
                        Divider(height: 30, color: context.appBorder),
                        _priceRow(context, "Amount to Pay", "₹${total.toStringAsFixed(2)}",
                            isBold: true),
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
                                color: context.appMutedText, fontSize: 10),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 150,
                        height: 45,
                        child: GestureDetector(
                          onLongPress: () {
                            // DEMO BYPASS: Long press to force success if Razorpay hangs
                            if (state.lastBookedAppointment != null) {
                               context.read<DashboardBloc>().add(
                                VerifyPaymentEvent(
                                  PaymentVerifyRequest(
                                    appointmentId: state.lastBookedAppointment!.appointmentId,
                                    razorpayOrderId: state.lastBookedAppointment!.paymentOrderId,
                                    razorpayPaymentId: 'pay_bypass_${DateTime.now().millisecondsSinceEpoch}',
                                    razorpaySignature: 'sig_bypass',
                                  ),
                                ),
                              );
                            }
                          },
                          child: AppButton(
                            text: state.isLoading ? "Loading..." : "Pay Now",
                            textColor: Colors.white,
                            color: AppColors.primary,
                            onPressed: state.isLoading || state.paymentSuccess
                                ? null
                                : () {
                                    if (state.lastBookedAppointment != null) {
                                      _startPayment(
                                        state.lastBookedAppointment!.amount,
                                        state.lastBookedAppointment!.paymentOrderId,
                                      );
                                    } else if (widget.appointmentRequest != null) {
                                      context.read<DashboardBloc>().add(
                                            BookAppointmentEvent(
                                                widget.appointmentRequest!),
                                          );
                                    }
                                  },
                          ),
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
          boxShadow: [
            BoxShadow(color: context.appShadow, blurRadius: 5),
          ],
        ),
        child: child,
      );

  Widget _priceRow(BuildContext context, String label, String val,
          {bool isBold = false}) =>
      Padding(
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
