import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/localization/app_strings.dart';
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
import './legal_text_screen.dart';
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
          if (state.otpResult != null &&
              state.otpResult?.requestId != null &&
              state.otpResult!.requestId!.isNotEmpty) {
            // ✅ Navigate only on SUCCESS with valid requestId
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => OtpScreen(number: state.phone)),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).scaffoldBackgroundColor
                              : null,
                          colorBlendMode:
                              Theme.of(context).brightness == Brightness.dark
                              ? BlendMode.multiply
                              : null,
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
                                              context.strings.welcomeToVetNow,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.7,
                                              child: Text(
                                                context.strings.signInSubtitle,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: AppSizes.s14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
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
                                                    context.strings.phoneNumberLabel,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppSizes.s10,
                                                  ),
                                                  AppPhoneField(
                                                    controller:
                                                        phoneNumberController,
                                                    hint: context.strings.enterPhoneNumberHint,
                                                    value: state.phone,
                                                    countryCode:
                                                        state.selectedCountryCode,
                                                    flag: state.selectedCountryFlag,
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
                                                        onSelected: (code, flag) {
                                                          context
                                                              .read<
                                                                SignInBloc
                                                              >()
                                                              .add(
                                                                CountrySelected(
                                                                  code,
                                                                  flag,
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
                                                        child: RichText(
                                                          textAlign: TextAlign.start,
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: AppSizes.s12,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: context.strings.termsByContinuing,
                                                              ),
                                                              TextSpan(
                                                                text: context.strings.termsAndConditions,
                                                                style: const TextStyle(
                                                                  decoration: TextDecoration.underline,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    Navigator.of(context).push(
                                                                      MaterialPageRoute(
                                                                        builder: (_) => const LegalTextScreen(
                                                                          title: "Terms of Service",
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                              ),
                                                              TextSpan(
                                                                text: context.strings.andSymbol,
                                                              ),
                                                              TextSpan(
                                                                text: context.strings.privacyPolicy,
                                                                style: const TextStyle(
                                                                  decoration: TextDecoration.underline,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    Navigator.of(context).push(
                                                                      MaterialPageRoute(
                                                                        builder: (_) => const LegalTextScreen(
                                                                          title: "Privacy Policy",
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                              ),
                                                              const TextSpan(
                                                                text: ".",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  AppButton(
                                                    text: state.isLoading
                                                        ? context.strings.sendingOtp
                                                        : context.strings.getOtpOnWhatsApp,
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
