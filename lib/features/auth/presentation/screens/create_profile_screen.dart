import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/core/localization/app_strings.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_state.dart';

import '../../../../core/theme/app_color.dart';
import '../../data/models/SearchAddressModel.dart';
import '../components/AppButton.dart';
import '../components/address_search_screen.dart';
import '../components/address_service.dart';
import '../components/app_text_field.dart';
import './main_flow_controller.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final AddressService _addressService = AddressService();
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];
  bool isStatesLoading = false;
  bool isCitiesLoading = false;
  bool isLoadingStates = false;

  @override
  void initState() {
    super.initState();
    SecureStorageService().saveOnboardingStage('CREATE_PROFILE');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerProfileBloc>(),
      child: BlocListener<OwnerProfileBloc, OwnerProfileState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.ownerProfileEntity != current.ownerProfileEntity ||
            previous.error != current.error,
        listener: (context, state) async {
          if (!state.isLoading && state.ownerProfileEntity != null) {
            await SecureStorageService().saveOnboardingStage('ADD_PET');
            if (!context.mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainFlowController()),
            );
          }
        },
        child: BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
          builder: (context, state) {
            return PopScope(
              canPop: Navigator.of(context).canPop(),
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  SystemNavigator.pop();
                }
              },
              child: Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Back Button
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new, 
                              size: 18,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                SystemNavigator.pop();
                              }
                            },
                          ),
                        ),
                      const SizedBox(height: 24),

                      // 2. Title & Subtitle
                      Text(
                        context.strings.createYourProfile,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.strings.createProfileSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      AppTextField(
                        label: context.strings.firstName,
                        hint: context.strings.enterYourFirstName,
                        keyboardType: TextInputType.emailAddress,
                        value: state.firstName,
                        onChanged: (value) {
                          context.read<OwnerProfileBloc>().add(
                            FirstNameChanged(value),
                          );
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return context.strings.required;
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        label: context.strings.lastName,
                        hint: context.strings.enterYourLastName,
                        keyboardType: TextInputType.emailAddress,
                        value: state.lastName,
                        onChanged: (value) {
                          context.read<OwnerProfileBloc>().add(
                            LastNameChanged(value),
                          );
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return context.strings.required;
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        label: context.strings.email,
                        hint: context.strings.enterYourEmailAddress,
                        keyboardType: TextInputType.emailAddress,
                        value: state.email,
                        onChanged: (value) {
                          context.read<OwnerProfileBloc>().add(
                            EmailChanged(value),
                          );
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return context.strings.required;
                          if (!v.contains('@')) return context.strings.invalidEmail;
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        key: ValueKey("${state.city}-${state.state}"),
                        label: context.strings.locationAddress,
                        hint: context.strings.tapToSearchLocation,
                        readOnly: true,
                        // Prevents keyboard from opening
                        value: state.country.isNotEmpty
                            ? [state.city, state.state, state.country]
                            .where((s) => s.isNotEmpty)
                            .join(", ")
                            : "",
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        onTap: () async {
                          final SearchAddressModel? result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
                          );


                          if (result != null && mounted) {
                            context.read<OwnerProfileBloc>().add(
                              AddressSelected(
                                country: result.country,
                                state: result.state,
                                city: result.city,
                                address:
                                "${result.city}, ${result.state}, ${result.country}",
                              ),
                            );
                          }
                        },
                      ),

                      // STATE DROPDOWN
                      if (state.city.isNotEmpty) ...[
                        Text(
                          "Picked: ${state.city}, ${state.state}, ${state.country}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      AppButton(
                        text: context.strings.continueText,
                        textColor: state.isFormValid && !state.isLoading
                            ? Colors.white
                            : Colors.grey,
                        color: state.isFormValid && !state.isLoading
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        onPressed: () {
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(builder: (_) => const MainFlowController()),
                          // );
                          state.isFormValid && !state.isLoading
                              ? {
                                  context.read<OwnerProfileBloc>().add(
                                    OnSubmitted(),
                                  ),
                                }
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.strings.pleaseEnterValidDetails),
                                  ),
                                );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ));
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
