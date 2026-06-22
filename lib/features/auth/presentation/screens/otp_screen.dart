import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/features/auth/presentation/screens/dashboard_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/main_flow_controller.dart';

import '../../../../core/theme/app_color.dart';
import '../bloc/otp/otp_bloc.dart';
import '../bloc/otp/otp_event.dart';
import '../bloc/otp/otp_state.dart';
import '../components/AppButton.dart';
import './onboard_screen.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key, required this.number});

  final String number;
  final pinController = TextEditingController();
  var otpCompleted = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 22,
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return BlocProvider(
      create: (_) => sl<OtpBloc>(),
      child: BlocListener<OtpBloc, OtpState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.otpVerifyEntity != current.otpVerifyEntity ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  left: 20,
                  right: 20,
                ),
              ),
            );
          }
          final entity = state.otpVerifyEntity;

          if (!state.isLoading && state.isComplete && entity != null) {
            final hasPets = entity.pets?.isNotEmpty == true;
            final hasEmailEmpty = entity.user?.email?.isEmpty == true;

            if (hasPets) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainDashboard()),
              );
            } else if (hasEmailEmpty) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainFlowController()),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
              );
            }
          }
        },
        child: BlocBuilder<OtpBloc, OtpState>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Title
                      Text(
                        "Enter the OTP",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 3. Subtitle with Bold Phone Number
                      RichText(
                        text: TextSpan(
                          text: "we sent a verification code on your number\n",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: number,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 4. The OTP Input Fields (6 boxes)
                      Center(
                        child: Pinput(
                          controller: pinController,
                          length: 6,
                          // Matches the 6 boxes in your image
                          defaultPinTheme: defaultPinTheme,
                          // Style when a box is focused
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          // The hyphen placeholder
                          preFilledWidget: const Text(
                            '-',
                            style: TextStyle(color: Colors.grey, fontSize: 24),
                          ),
                          // Keyboard type
                          keyboardType: TextInputType.number,
                          // Auto focus the first field
                          autofocus: true,
                          onChanged: (pin) {
                            debugPrint('onChanged pin: $pin');
                            context.read<OtpBloc>().add(OtpChanged(pin));
                          },
                          onCompleted: (pin) {
                            debugPrint('Submitted pin: $pin');
                            // context
                            //     .read<OtpBloc>()
                            //     .add(OtpChanged(pin));
                          },
                        ),
                      ),

                      const Spacer(), // Pushes the bottom content down
                      // 5. Resend Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Did not get the OTP? ",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () {
                              pinController.clear();
                              context.read<OtpBloc>().add(OtpResendRequested());
                            },
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 6. The "Verify" Button
                      AppButton(
                        text: state.isLoading ? "Verifying..." : "Verify",
                        color: state.isComplete
                            ? AppColors.primary
                            : Colors.grey,
                        onPressed: () => {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (_) => OnBoardingScreen(),
                          //   ),
                          // )
                          state.isComplete
                              ? {context.read<OtpBloc>().add(OtpSubmitted())}
                              : {},
                        },
                      ),
                      // Add some space at the bottom (or above keyboard)
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
