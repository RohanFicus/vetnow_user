import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/core/theme/app_color.dart';
import 'package:vetnow_user/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/repositories/profile_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/profile_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_state.dart';
import 'package:vetnow_user/features/auth/presentation/screens/sign_in_screen.dart';
import '../components/AppButton.dart';

class EmptyPetsScreen extends StatelessWidget {
  final void Function(SpeciesModel? petType) onAddPet;

  const EmptyPetsScreen({super.key, required this.onAddPet});

  @override
  Widget build(BuildContext context) {
    late SpeciesModel selectedSpeciesModel;
    return BlocProvider(
      create: (_) => ProfileBloc(
        ProfileUseCase(
          ProfileRepositoryImpl(ProfileRemoteDataSourceImpl(ApiClient()), SecureStorageService()),
        ),
        SecureStorageService(),
      )..add(SpeciesCall()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          /* your listener */
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            // Ultra light slate background
            body: Stack(
              children: [
                // 1. Modern Header with Gradient and Decorative Paws
                _buildHeaderBackground(),

                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _buildHeroSection(),
                      const SizedBox(height: 20),

                      // 2. Selection Area
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              _buildDragHandle(),
                              // Decorative handle
                              const SizedBox(height: 20),
                              _buildTitleSection(),

                              Expanded(
                                child: state.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : _buildPremiumGrid(context, state),
                              ),

                              const SizedBox(height: 100),
                              // Space for floating button
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Floating Bottom Button
                _buildFloatingButton(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0F2FE), Color(0xFFF8FAFC)],
        ),
      ),
      child: Stack(
        children: [
          Position(
            top: 40,
            left: 20,
            child: Opacity(opacity: 0.1, child: Icon(Icons.pets, size: 100)),
          ),
          Position(
            top: 150,
            right: -20,
            child: Opacity(opacity: 0.1, child: Icon(Icons.pets, size: 120)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.pets_rounded, color: Color(0xFF0061CE), size: 50),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "No Pets Found",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Every great journey starts with a paw.",
          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return const Row(
      children: [
        Text(
          "Choose your pet type",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF334155),
          ),
        ),
        Spacer(),
        Icon(Icons.info_outline, size: 18, color: Colors.grey),
      ],
    );
  }

  Widget _buildPremiumGrid(BuildContext context, ProfileState state) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row looks more premium
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: state.speciesEntityList.length,
      itemBuilder: (context, index) {
        final pet = state.speciesEntityList[index];
        final isSelected = state.spiecesId == pet.id.toString();

        return GestureDetector(
          onTap: ()
          {context.read<ProfileBloc>().add(
            PetSpeciesChanged(pet.id.toString()),
          );
            context.read<ProfileBloc>().add(
            SpeciesSelected(pet),
          );

            },
          child: AnimatedScale(
            scale: isSelected ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0061CE)
                      : Colors.grey.shade200,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              pet.iconUrl ?? '',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          pet.nameEn ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF0061CE)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xFF0061CE),
                        child: Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingButton(ProfileState state) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white.withOpacity(0), Colors.white, Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: AppButton(
          text:
              "Continue with ${state.spiecesId.isNotEmpty ? 'Selection' : 'New Pet'}",
          color: state.spiecesId.isNotEmpty
              ? const Color(0xFF0061CE)
              : Colors.grey.shade400,
          onPressed: state.spiecesId.isNotEmpty
              ? () => onAddPet(state.specieSelected)
              : () {},
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        height: 5,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Simple Positioned Helper to clean code
class Position extends StatelessWidget {
  final double? top, left, right, bottom;
  final Widget child;

  const Position({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Positioned(
    top: top,
    left: left,
    right: right,
    bottom: bottom,
    child: child,
  );
}
