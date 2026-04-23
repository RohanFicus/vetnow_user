import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vetnow_user/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/owner_profile_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/ownerProfile/owner_profile_state.dart';

import '../../../../core/theme/app_color.dart';
import '../../data/models/SearchAddressModel.dart';
import '../components/AppButton.dart';
import '../components/address_search_screen.dart';
import '../components/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerProfileBloc(
        OwnerProfileUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(ApiClient()),
            AuthLocalDataSourceImpl(),
          ),
        ),
        SecureStorageService(),
      )..add(OwnerProfileCallLocally()),
      child: BlocListener<OwnerProfileBloc, OwnerProfileState>(
        listener: (context, state) {
          if (!state.isLoading && state.ownerProfileEntity != null) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<OwnerProfileBloc, OwnerProfileState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF8FAFC), // Modern off-white/blue tint
              appBar: _buildSimpleAppBar(context, "Edit Profile"),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [

                      const SizedBox(height: 32),

                      // 2. FORM SECTION
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader("Personal Information"),
                            const SizedBox(height: 16),

                            AppTextField(
                              label: 'First Name',
                              hint: "John",
                              prefixIcon: const Icon(Icons.person_outline, size: 20),
                              value: state.firstName,
                              onChanged: (v) => context.read<OwnerProfileBloc>().add(FirstNameChanged(v)),
                            ),
                            const SizedBox(height: 18),

                            AppTextField(
                              label: 'Last Name',
                              hint: "Doe",
                              prefixIcon: const Icon(Icons.person_outline, size: 20),
                              value: state.lastName,
                              onChanged: (v) => context.read<OwnerProfileBloc>().add(LastNameChanged(v)),
                            ),
                            const SizedBox(height: 18),

                            AppTextField(
                              label: 'Email Address',
                              hint: "john@example.com",
                              prefixIcon: const Icon(Icons.mail_outline, size: 20),
                              value: state.email,
                              onChanged: (v) => context.read<OwnerProfileBloc>().add(EmailChanged(v)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 3. ADDRESS SECTION
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader("Location Details"),
                            const SizedBox(height: 16),

                            AppTextField(
                              key: ValueKey("${state.city}-${state.state}"),
                              label: 'Location / Address',
                              hint: "Search your city...",
                              readOnly: true,
                              value: state.address,
                              prefixIcon: const Icon(Icons.location_on_outlined, size: 20, color: Colors.redAccent),
                              suffixIcon: const Icon(Icons.chevron_right, color: Colors.grey),
                              onTap: () async {
                                final SearchAddressModel? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
                                );
                                if (result != null && mounted) {
                                  context.read<OwnerProfileBloc>().add(AddressSelected(
                                    country: result.country,
                                    state: result.state,
                                    city: result.city,
                                    address: "${result.city}, ${result.state}, ${result.country}",
                                  ));
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 4. CONTINUE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: AppButton(
                          text: state.isLoading ? "" : "Save Changes",
                          textColor: state.isProfileEdited ? Colors.white : Colors.grey.shade600,
                          color: state.isProfileEdited ? AppColors.primary : Colors.grey.shade200,
                          onPressed: () {
                            if (state.isProfileEdited && !state.isLoading) {
                              context.read<OwnerProfileBloc>().add(OnSubmitted());
                            }
                          },
                          child: state.isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 32),
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

  Widget _buildAvatarSection(OwnerProfileState state) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: (state.ownerProfileEntity?.profileImage != null)
                  ? NetworkImage(state.ownerProfileEntity!.profileImage!)
                  : null,
              child: state.ownerProfileEntity?.profileImage == null
                  ? Icon(Icons.person, size: 50, color: Colors.blue.shade300)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        letterSpacing: 0.5,
      ),
    );
  }
}

// Updated AppBar Design
PreferredSizeWidget _buildSimpleAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: const Color(0xFFF8FAFC),
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.black),
      ),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}