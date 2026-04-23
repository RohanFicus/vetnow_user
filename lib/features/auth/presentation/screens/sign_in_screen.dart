import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/components/dismiss_keyboard.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/sizes.dart';
import '../bloc/sign_in_bloc.dart';
import '../bloc/sign_in_event.dart';
import '../bloc/sign_in_state.dart';
import '../components/AppButton.dart';
import '../components/app_card.dart';
import '../components/app_scaffold.dart';
import '../components/country_picker_sheet.dart';
import '../components/phone_number_field.dart';
import './otp_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  var phoneNumberController = TextEditingController();
  var enableButton = false;
  var checkBoxEnable = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignInBloc>(),
      child: BlocListener<SignInBloc, SignInState>(
        listenWhen: (previous, current) =>
            previous.isButtonEnabled != current.isButtonEnabled ||
            previous.otpResult != current.otpResult ||
            previous.error != current.error,
        listener: (context, state) {
          print("OtpResult :: ${state.otpResult}");
          if (state.otpResult != null) {
            // ✅ Navigate on SUCCESS
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => OtpScreen(number: state.phone)),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            return AppScaffold(
              body: Center(
                child: DismissKeyboard(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentGeometry.center,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/png/signup_bg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SafeArea(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),

                          child: AnimatedPadding(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Center(
                              child: Stack(
                                alignment: AlignmentGeometry.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 100),
                                    child: AppCard(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: AppSizes.s20,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: AppSizes.appBarHeight,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Welcome to VetNow",
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.7,
                                              child: Text(
                                                "Your pet’s health companion to make your pet healthy and happy",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: AppSizes.s14,
                                                  color: AppColors.textGray,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: AppSizes.s14),
                                            AppCard(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: AppSizes.s14,
                                                vertical: AppSizes.s10,
                                              ),
                                              color: AppColors.cardColorAuth,
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Phone Number",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppSizes.s10,
                                                  ),
                                                  AppPhoneField(
                                                    controller:
                                                        phoneNumberController,
                                                    value: state.phone,
                                                    countryCode:
                                                        state.selectedCountry,
                                                    errorText: state.phoneError,
                                                    onChanged: (value) {
                                                      context
                                                          .read<SignInBloc>()
                                                          .add(
                                                            PhoneChanged(value),
                                                          );
                                                    },
                                                    onCountryTap: () {
                                                      showCountryPickerSheet(
                                                        context: context,
                                                        onSelected: (country) {
                                                          context
                                                              .read<
                                                                SignInBloc
                                                              >()
                                                              .add(
                                                                CountrySelected(
                                                                  country,
                                                                ),
                                                              );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: AppSizes.s10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Checkbox(
                                                        value:
                                                            state.termsAccepted,
                                                        onChanged: (value) {
                                                          context
                                                              .read<
                                                                SignInBloc
                                                              >()
                                                              .add(
                                                                TermsToggled(
                                                                  value ??
                                                                      false,
                                                                ),
                                                              );
                                                        },
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "By continuing, you agree to VetNow Terms and Condition & Privacy Policy.",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                AppSizes.s12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  AppButton(
                                                    text: state.isLoading
                                                        ? "Sending OTP..."
                                                        : "Get OTP on WhatsApp",
                                                    color: state.isButtonEnabled
                                                        ? AppColors.primary
                                                        : Colors.grey,
                                                    onPressed: () => {
                                                      state.isButtonEnabled
                                                          ? {
                                                              context
                                                                  .read<
                                                                    SignInBloc
                                                                  >()
                                                                  .add(
                                                                    SubmitPressed(),
                                                                  ),
                                                            }
                                                          : {},
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: Image.asset(
                                      'assets/png/pets.png',
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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
