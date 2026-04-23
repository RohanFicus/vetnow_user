import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/di/service_locator.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/datasources/dashboard_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/repositories/dashboard_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/dashboard_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';
import 'package:vetnow_user/core/utils/pet_utils.dart';
import 'package:vetnow_user/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../components/AppButton.dart';
import './pet_profiledetail_screen.dart';

class MyPetsListScreen extends StatelessWidget {
  const MyPetsListScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(OwnerProfileCallLocally()),
      child: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (previous, current) =>
            previous.user != current.user ||
            previous.pets != current.pets ||
            previous.isLoading != current.isLoading ||
            previous.error != current.error,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.pets.isEmpty) {
              return _buildEmptyState(context);
            }

            return Scaffold(
              backgroundColor: context.appBackground,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: context.appText,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "My Pet Family",
                  style: TextStyle(
                    color: context.appText,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      child: Text(
                        "You have ${state.pets.length} pets registered",
                        style: TextStyle(
                          color: context.appMutedText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.pets.length,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        // Bottom padding for FAB
                        itemBuilder: (context, index) {
                          return _buildPetCard(context, state.pets[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, Pets pet) {
    final profile = pet.profile;
    final speciesImg = PetUtils.getSpeciesImage(pet.profile?.speciesName);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => PetProfileDetailScreen(pet: pet)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: context.appShadow,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Pet Image with Border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Image(
                      image: (profile?.qrCodeFileName != null &&
                              profile!.qrCodeFileName!.isNotEmpty &&
                              (profile.qrCodeFileName!.startsWith('http') ||
                                  profile.qrCodeFileName!.startsWith('https')))
                          ? NetworkImage(profile.qrCodeFileName!)
                          : NetworkImage(speciesImg),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          speciesImg,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Pet Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.name ?? "Unnamed Pet",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: context.appText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.fingerprint,
                          size: 14,
                          color: context.appMutedText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "ID: ${profile?.petUniqueId ?? 'N/A'}",
                          style: TextStyle(
                            color: context.appMutedText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Optional Badges (e.g., Breed/Species)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        " ${profile?.breedName ?? 'N/A'}",
                        // You can replace this with pet.breed
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action Arrow
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.appSurfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: context.appText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.appText,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pets, size: 80, color: Colors.orange),
              ),
              const SizedBox(height: 32),
              Text(
                "No Pets Found",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: context.appText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Your pet family is empty. Add your first pet to start tracking their health and records.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.appMutedText,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              AppButton(
                text: "Add New Pet",
                onPressed: () {
                  // This is a bit tricky since we are in a Stateless widget 
                  // and may need to pass the bloc or just use a new one in the wizard
                  Navigator.pushNamed(context, '/add-pet'); // Assuming route exists or use Navigator.push
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
