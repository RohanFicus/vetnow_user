import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
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
    //_loadCountries();
  }

  // void _loadCountries() async {
  //   final list = await _addressService.getCountries();
  //   setState(() => countries = list);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerProfileBloc>(),
      child: BlocListener<OwnerProfileBloc, OwnerProfileState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.ownerProfileEntity != current.ownerProfileEntity ||
            previous.error != current.error,
        listener: (context, state) {
          if (!state.isLoading && state.ownerProfileEntity != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainFlowController()),
            );
          }
        },
        child: BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
          builder: (context, state) {
            return Scaffold(
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
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                          color: Colors.black87,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Title & Subtitle
                      const Text(
                        "Create Your Profile",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your details help us personalize care for your pets.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      AppTextField(
                        label: 'First Name',
                        hint: "Enter your first name",
                        keyboardType: TextInputType.emailAddress,
                        value: state.firstName,
                        onChanged: (value) {
                          context.read<OwnerProfileBloc>().add(
                            FirstNameChanged(value),
                          );
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        label: 'Last Name',
                        hint: "Enter your last name",
                        keyboardType: TextInputType.emailAddress,
                        value: state.lastName,
                        onChanged: (value) {
                          context.read<OwnerProfileBloc>().add(
                            LastNameChanged(value),
                          );
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        label: 'Email Address',
                        hint: "Enter your email address",
                        keyboardType: TextInputType.emailAddress,
                        value: state.email,
                        onChanged: (value) {
                          context.read<OwnerProfileBloc>().add(
                            EmailChanged(value),
                          );
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (!v.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        key: ValueKey("${state.city}-${state.state}"),
                        label: 'Location / Address',
                        hint: "Tap to search your location",
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
                        text: "Continue",
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
                                    content: Text("Please enter valid details"),
                                  ),
                                );
                        },
                      ),

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
