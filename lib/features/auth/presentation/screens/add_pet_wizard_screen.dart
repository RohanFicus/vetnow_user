import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/core/theme/app_color.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/breeds_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/speice_response_model.dart';
import 'package:vetnow_user/features/auth/data/models/vaccine_response_model.dart';
import 'package:vetnow_user/features/auth/data/repositories/profile_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/entities/vaccine_entity.dart';
import 'package:vetnow_user/features/auth/domain/usecases/profile_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_state.dart';
import 'package:vetnow_user/features/auth/presentation/components/AppButton.dart';
import 'package:vetnow_user/features/auth/presentation/screens/pet_profile_success_screen.dart';
import 'package:vetnow_user/features/auth/presentation/screens/sign_in_screen.dart';

import '../bloc/pet_profile/profile_event.dart';
import '../components/app_text_field.dart';
import '../components/custom_dropdown.dart';
import './dashboard_screen.dart';

class AddPetWizardScreen extends StatefulWidget {
  final bool existing;
  final SpeciesModel? speciesModel;
  final Pets? pet; // Add this for edit mode
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const AddPetWizardScreen({
    super.key,
    required this.speciesModel,
    required this.existing,
    required this.onComplete,
    required this.onBack,
    this.pet, // Optional pet data for editing
  });

  @override
  State<AddPetWizardScreen> createState() => _AddPetWizardScreenState();
}

class _AddPetWizardScreenState extends State<AddPetWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0; // 0, 1, 2

  void _nextPage() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      if (widget.pet != null) {
        // Edit mode - go back to previous screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      } else if (widget.existing == true) {
        // Add existing pet mode - go to dashboard
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      } else {
        // New pet mode - call onComplete
        widget.onComplete();
      }
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      if (widget.pet != null) {
        // Edit mode - go back to previous screen
        Navigator.pop(context);
      } else if (widget.existing == true) {
        // Add existing pet mode - go to dashboard
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
        );
      } else {
        // New pet mode - call onBack
        widget.onBack();
      }
    }
  }

  //void reset() => setState(() => _currentFlowIndex = 0);

  @override
  Widget build(BuildContext context) {
    // Progress calculation
    double progressWidth =
        (MediaQuery.of(context).size.width / 3) * (_currentStep + 1);

    print("widget.existing===> ${widget.existing}");
    void goToDashBoard() {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainDashboard()),
      );
    }

    return BlocProvider(
      create: (_) {
        final bloc =
            ProfileBloc(
              ProfileUseCase(
                ProfileRepositoryImpl(
                  ProfileRemoteDataSourceImpl(ApiClient()),
                  SecureStorageService(),
                ),
              ),
              SecureStorageService(),
            )..add(
              widget.speciesModel?.id?.isNotEmpty == true
                  ? BreedsCall(widget.speciesModel!.id.toString())
                  : SpeciesCall(),
            );

        // Handle edit mode - pre-populate data
        if (widget.pet != null && widget.pet!.profile != null) {
          final petProfile = widget.pet!.profile!;
          final petVaccination = widget.pet!.vaccinations!;

          // First, fetch all species to find the matching one
          bloc.add(SpeciesCall());

          // Listen for species data and select the matching one
          StreamSubscription? subscription;
          subscription = bloc.stream.listen((state) {
            if (state.speciesEntityList.isNotEmpty &&
                petProfile.speciesId != null) {
              // Find exact matching species by ID
              SpeciesModel matchingSpecies;
              try {
                matchingSpecies = state.speciesEntityList.firstWhere(
                  (species) =>
                      species.id.toString() == petProfile.speciesId.toString(),
                );
              } catch (e) {
                // If exact match not found, use first species as fallback
                matchingSpecies = state.speciesEntityList.first;
              }

              // Select the matching species
              bloc.add(SpeciesSelected(matchingSpecies));

              // Load breeds and vaccines for this species
              bloc.add(BreedsCall(petProfile.speciesId.toString()));
              bloc.add(VaccineCall(petProfile.speciesId.toString()));

              subscription?.cancel();
            }
          });

          // Set pet name
          if (petProfile.name?.isNotEmpty == true) {
            bloc.add(PetNameChanged(petProfile.name!));
          }

          // Set birthday if available
          if (petProfile.dateOfBirth?.isNotEmpty == true) {
            bloc.add(PetBirthdayChanged(petProfile.dateOfBirth!));
          }

          // Set breed if available
          if (petProfile.breedId != null) {
            bloc.add(
              BreedsSelected(
                BreedsModel(
                  id: petProfile.breedId,
                  code: '',
                  nameEn: '',
                  nameHi: '',
                  isActive: true,
                  speciesId: petProfile.speciesId ?? '',
                ),
              ),
            );
          }

          // Set age if available
          if (petProfile.ageMonths != null) {
            bloc.add(PetAgeChanged(petProfile.ageMonths!));
          }

          // Set gender if available
          if (petProfile.sex?.isNotEmpty == true) {
            bloc.add(PetGenderChanged(petProfile.sex!));
          }

          // Set weight if available
          if (petProfile.weightKg != null) {
            bloc.add(PetWeightChanged(petProfile.weightKg!));
          }
          // Set weight if available
          if (petProfile.color != null) {
            bloc.add(PetColorChanged(petProfile.color!));
          }
          // Set weight if available
          if (petProfile.id != null) {
            print("object===> ${petProfile.id.toString()}");
            bloc.add(PetIdChanged(petProfile.id.toString()));
          }
          if (petProfile.isSpayed != null) {
            bloc.add(PetSpayedChanged(petProfile.isSpayed!));
          }
          if (petProfile.isNeutered != null) {
            bloc.add(PetNeuteredChanged(petProfile.isNeutered!));
          }
          if (petProfile.isMilking != null) {
            bloc.add(MilkingStatusChanged(petProfile.isMilking!));
          }
          if (petProfile.isPregnant != null) {
            bloc.add(PregnancyStatusChanged(petProfile.isPregnant!));
          }
          if (petVaccination.isNotEmpty) {
            bloc.add(
              VaccineSelected(
                VaccineModel(
                  id: petVaccination.first.vaccineId,
                  nameEn: petVaccination.first.vaccineName,
                  code: petVaccination.first.vaccineCode,
                  isActive: petVaccination.first.status == "YES" ? true : false,
                  nameHi: '',
                  descriptionEn: '',
                  descriptionHi: '',
                  speciesId: petProfile.speciesId,
                  vaccinationDate: petVaccination.first.vaccinationDate,
                ),
              ),
            );
          }
        }

        // Handle new pet mode with species pre-selected
        if (widget.speciesModel?.id?.isNotEmpty == true && widget.pet == null) {
          bloc.add(PetSpeciesChanged(widget.speciesModel!.id.toString()));
          bloc.add(VaccineCall(widget.speciesModel!.id.toString()));
          bloc.add(
            PetNameChanged(
              widget.speciesModel?.nameEn == "Cow"
                  ? "Cow1"
                  : widget.speciesModel?.nameEn == "Buffalo"
                  ? "Buffalo1"
                  : "",
            ),
          );
          bloc.add(
            SpeciesSelected(
              widget.speciesModel ??
                  SpeciesModel(
                    code: '',
                    iconUrl: '',
                    id: null,
                    isActive: false,
                    nameEn: '',
                    nameHi: '',
                  ),
            ),
          );
        }

        return bloc;
      },
      child: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.step1Success != current.step1Success ||
            previous.step2Success != current.step2Success ||
            previous.step3Success != current.step3Success ||
            previous.error != current.error,
        listener: (context, state) {
          print("Step Success ${state.breedsEntityList}");
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
            if (state.error == "ACCESS_TOKEN_EXPIRED") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            }
            return;
          }
          // ✅ Step navigation
          if (state.step1Success && _currentStep == 0) {
            _nextPage();
          }

          if (state.step2Success && _currentStep == 1) {
            _nextPage();
          }

          if (state.skipSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PetProfileSuccessScreen(
                  onAddAnother: () {},
                  onDashboard: goToDashBoard,
                ),
              ),
            );
          }

          // ✅ Final success
          if (state.step3Success && _currentStep == 2) {
            if (widget.pet != null) {
              // Edit mode - go back to previous screen
              Navigator.pop(context);
            } else if (widget.existing) {
              // Add existing pet mode - go to dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainDashboard()),
              );
            } else {
              // New pet mode - call onComplete
              widget.onComplete();
            }
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: context.appBackground,
              appBar: _buildModernWizardHeader(context),
              body: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable swipe
                      children: [
                        Step1BasicDetails(
                          speciesModel: widget.speciesModel,
                          pet: widget.pet,
                          existing: widget.existing,
                        ),
                        Step2PhysicalDetails(pet: widget.pet),
                        Step3MedicalDetails(pet: widget.pet),
                      ],
                    ),
                  ),
                  _buildBottomNavigation(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernWizardHeader(BuildContext context) {
    return AppBar(
      backgroundColor: context.appBackground,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, size: 18, color: context.appText),
        onPressed: _prevPage,
      ),
      title: Column(
        children: [
          Text(
            widget.pet != null ? "Edit Profile" : "New Pet",
            style: TextStyle(
              color: context.appText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          _buildStepIndicator(context),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        bool isActive = index == _currentStep;
        bool isDone = index < _currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 24 : 6,
          decoration: BoxDecoration(
            color: isActive || isDone ? AppColors.primary : context.appBorder,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, ProfileState state) {
    bool isValid =
        (_currentStep == 0 && state.isStep1Valid) ||
        (_currentStep == 1 && state.isStep2Valid) ||
        (_currentStep == 2 && state.isStep3Valid);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: context.appSurface,
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep != 0 || widget.existing) ...[
            Expanded(
              flex: 1,
              child: AppButton(
                text: "Skip",
                color: Colors.transparent,
                textColor: context.appMutedText,
                onPressed: widget.existing
                    ? () => _nextPage()
                    : () => context.read<ProfileBloc>().add(SkipSubmit()),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: 2,
            child: AppButton(
              isLoading: state.isLoading,
              text: _currentStep == 2 ? "Finish" : "Continue",
              color: isValid ? AppColors.primary : context.appBorder,
              textColor: isValid ? Colors.white : context.appMutedText,
              onPressed: isValid
                  ? () {
                      if (_currentStep == 0) {
                        context.read<ProfileBloc>().add(Step1Submit());
                      }
                      if (_currentStep == 1) {
                        context.read<ProfileBloc>().add(Step2Submit());
                      }
                      if (_currentStep == 2) {
                        context.read<ProfileBloc>().add(Step3Submit());
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Wizard Step 1: Basic Details ---
class Step1BasicDetails extends StatelessWidget {
  final SpeciesModel? speciesModel;
  final Pets? pet;
  final bool existing;

  const Step1BasicDetails({
    super.key,
    required this.speciesModel,
    this.pet,
    required this.existing,
  });

  // Helper to check if livestock (Cow/Buffalo)
  bool _isLivestock(ProfileState state) {
    final name = state.specieSelected?.nameEn?.toUpperCase() ?? "";
    return name.contains("COW") || name.contains("BUFFALO");
  }

  // Helper to check if common pet (Dog/Cat)
  bool _isCommonPet(ProfileState state) {
    final name = state.specieSelected?.nameEn?.toUpperCase() ?? "";
    return name.contains("DOG") || name.contains("CAT");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(
                "Basic Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.appText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Provide basic information about your pet",
                style: TextStyle(color: context.appMutedText),
              ),
              const SizedBox(height: 10),

              // --- Pet Name ---
              AppTextField(
                label: 'Pet Name',
                hint: "Enter pet name",
                value: state.petName,
                onChanged: (name) =>
                    context.read<ProfileBloc>().add(PetNameChanged(name)),
              ),
              const SizedBox(height: 10),

              // --- Birthday ---
              AppTextField(
                label: 'Birthday',
                hint: "Enter pet birthday",
                value: state.petBirthday,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    final formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    context.read<ProfileBloc>().add(
                      PetBirthdayChanged(formattedDate),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),

              // --- Age ---
              AppTextField(
                label: 'Age (in months)',
                hint: "Enter age",
                readOnly: true,
                value: state.petAgeInYears == 0
                    ? ''
                    : state.petAgeInYears.toString(),
              ),
              const SizedBox(height: 10),

              // --- Species Selection ---
              if (speciesModel?.id == null)
                CustomDropdown<SpeciesModel>(
                  label: "Species",
                  hint: "Select species",
                  value: state.specieSelected,
                  list: state.speciesEntityList.map((species) {
                    return DropdownMenuItem<SpeciesModel>(
                      value: species,
                      child: Text(
                        species.nameEn ?? '',
                        style: TextStyle(color: context.appText),
                      ),
                    );
                  }).toList(),
                  onChanged: (species) {
                    if (species == null) return;
                    context.read<ProfileBloc>().add(SpeciesSelected(species));
                    context.read<ProfileBloc>().add(BreedReset());
                    context.read<ProfileBloc>().add(
                      BreedsCall(species.id.toString()),
                    );
                    context.read<ProfileBloc>().add(
                      VaccineCall(species.id.toString()),
                    );
                  },
                ),
              const SizedBox(height: 10),

              // --- Breed Selection ---
              existing == false
                  ? CustomDropdown(
                      label: "Breed",
                      hint: "Select breed",
                      value:
                          state.breedsEntityList.contains(state.breedSelected)
                          ? state.breedSelected
                          : null,
                      list: state.breedsEntityList.map((breed) {
                        return DropdownMenuItem<BreedsModel>(
                          value: breed,
                          child: Text(
                            breed.nameEn ?? '',
                            style: TextStyle(color: context.appText),
                          ),
                        );
                      }).toList(),
                      onChanged: (breed) {
                        if (breed == null) return;
                        context.read<ProfileBloc>().add(BreedsSelected(breed));
                      },
                    )
                  : SizedBox(),

              existing == true && pet?.profile?.breedName?.isNotEmpty == true
                  ? AppTextField(
                      label: 'Breed',
                      hint: "Select breed",
                      readOnly: true,
                      enabled: false,
                      onChanged: (breed) {
                        context.read<ProfileBloc>().add(
                          OtherBreedChanged(breed),
                        );
                      },

                      value: pet?.profile?.breedName,
                    )
                  : SizedBox(),

              const SizedBox(height: 10),
              state.breedSelected?.nameEn == "Other"
                  ? AppTextField(
                      label: '  (Optional*)',
                      hint: "Enter Breed Name",
                      readOnly: false,
                      onChanged: (breed) {
                        context.read<ProfileBloc>().add(
                          OtherBreedChanged(breed),
                        );
                      },

                      value: state.otherBread,
                    )
                  : SizedBox(),
              const SizedBox(height: 10),
              _inputLabel(context, "Gender"),
              const SizedBox(height: 10),
              _buildGenderToggle(context, state),
              const SizedBox(height: 10),

              // -------------------------------------------------------
              // 4. Additional Info for Cow & Buffalo (Livestock)
              // -------------------------------------------------------
              if (_isLivestock(state) && state.petSex == "FEMALE") ...[
                _inputLabel(context, "Milking Status"),
                const SizedBox(height: 10),
                _buildToggleButton(
                  context: context,
                  isSelected: state.milkingStatus == true,
                  onTap: (val) => context.read<ProfileBloc>().add(
                    MilkingStatusChanged(val),
                  ),
                ),
                const SizedBox(height: 20),

                // Only ask Pregnancy if NOT milking
                if (state.milkingStatus == false) ...[
                  _inputLabel(context, "Is the animal pregnant?"),
                  const SizedBox(height: 10),
                  _buildToggleButton(
                    context: context,
                    isSelected: state.pregnancyStatus == true,
                    onTap: (val) => context.read<ProfileBloc>().add(
                      PregnancyStatusChanged(val),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
              // -------------------------------------------------------
              // 5. Reproductive Info for Dogs & Cats
              // -------------------------------------------------------
              if (_isCommonPet(state) ||
                  (_isLivestock(state) && state.petSex == "MALE")) ...[
                _inputLabel(
                  context,
                  state.petSex == "MALE"
                      ? "Neutered (Castrated)"
                      : "Spayed (Sterilized)",
                ),
                const SizedBox(height: 10),
                _buildToggleButton(
                  context: context,
                  isSelected: state.petSex == "MALE"
                      ? state.petNeutered == true
                      : state.petSpayed == true,
                  onTap: (val) {
                    state.petSex == "MALE"
                        ? context.read<ProfileBloc>().add(
                            PetNeuteredChanged(val),
                          )
                        : context.read<ProfileBloc>().add(
                            PetSpayedChanged(val),
                          );
                  },
                ),
                const SizedBox(height: 20),
              ] else if (!_isLivestock(state)) ...[
                // Default fallback for other animals if needed
                _inputLabel(context, "Spayed / Neutered"),
                const SizedBox(height: 10),
                _buildToggleButton(
                  context: context,
                  isSelected: state.petSpayed == true,
                  onTap: (val) =>
                      context.read<ProfileBloc>().add(PetSpayedChanged(val)),
                  //context: context,
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _inputLabel(BuildContext context, String label) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        label,
        style: TextStyle(
          color: context.appText,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  // A generic toggle builder to keep code DRY
  Widget _buildToggleButton({
    required BuildContext context,
    required bool isSelected,
    required Function(bool) onTap,
  }) {
    return Row(
      children: [
        _selectableButton(
          context,
          "YES",
          isSelected == true,
          () => onTap(true),
        ),
        const SizedBox(width: 15),
        _selectableButton(
          context,
          "NO",
          isSelected == false,
          () => onTap(false),
        ),
      ],
    );
  }

  Widget _buildGenderToggle(BuildContext context, ProfileState state) {
    return Row(
      children: [
        _selectableButton(context, "MALE", state.petSex == "MALE", () {
          context.read<ProfileBloc>().add(const PetGenderChanged("MALE"));
        }),
        const SizedBox(width: 15),
        _selectableButton(context, "FEMALE", state.petSex == "FEMALE", () {
          context.read<ProfileBloc>().add(const PetGenderChanged("FEMALE"));
        }),
      ],
    );
  }

  Widget _selectableButton(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? context.appSoftPrimary : context.appSurface,
            border: Border.all(
              color: isActive ? AppColors.primary : context.appBorder,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : context.appMutedText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Wizard Step 2: Physical Details ---
class Step2PhysicalDetails extends StatelessWidget {
  final Pets? pet;

  const Step2PhysicalDetails({super.key, this.pet});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              /// 🔹 Dark Background Section
              Container(
                margin: const EdgeInsets.only(top: 260),
                padding: const EdgeInsets.fromLTRB(24, 120, 24, 24),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: context.isDarkMode
                        ? [context.appSurfaceVariant, context.appBackground]
                        : [const Color(0xFF0D1B2A), const Color(0xFF08121F)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "These details help vets provide better care and track your pet's health over time.",
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.4,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔹 Wizard Card (Floating)
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: context.appShadow,
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Text(
                            "Physical Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.appText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add physical measurements and any special notes about your pet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.appMutedText),
                    ),
                    const SizedBox(height: 30),

                    /// Weight
                    AppTextField(
                      label: 'Weight (kg)',
                      hint: "Enter pet weight",
                      value: state.weight == 0 ? '' : state.weight.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        context.read<ProfileBloc>().add(
                          PetWeightChanged(double.tryParse(value) ?? 0),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Color
                    AppTextField(
                      label: 'Color',
                      hint: "Enter pet color",
                      value: state.color,
                      onChanged: (color) {
                        context.read<ProfileBloc>().add(PetColorChanged(color));
                      },
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Wizard Step 3: Medical Details ---
class Step3MedicalDetails extends StatelessWidget {
  final Pets? pet;

  const Step3MedicalDetails({super.key, this.pet});

  @override
  Widget build(BuildContext context) {
    Future<void> pickDocument(BuildContext context) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        context.read<ProfileBloc>().add(FileSelected(result.files.single));
      }
    }

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final hasFile = state.medicalFile?.path?.isNotEmpty == true;
        return SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              /// 🔹 Dark Background Section
              if (state.vaccineList.length == 1)
                Container(
                  margin: const EdgeInsets.only(top: 260),
                  padding: const EdgeInsets.fromLTRB(24, 120, 24, 24),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: context.isDarkMode
                          ? [context.appSurfaceVariant, context.appBackground]
                          : [const Color(0xFF0D1B2A), const Color(0xFF08121F)],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "These details help vets provide better care and track your pet's health over time.",
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.4,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              /// 🔹 Wizard Floating Card
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 10,
                ),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: context.appShadow,
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Medical Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.appText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Select vaccines and upload records",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.appMutedText),
                    ),
                    const SizedBox(height: 14),

                    /// Vaccine Dropdown
                    if (state.vaccineEntityList.isEmpty == true)
                      CustomDropdown(
                        label: "Vaccine Administered",
                        hint: "Select vaccine",
                        value: null,
                        list: const [],
                        onChanged: null,
                      )
                    else
                      CustomDropdown(
                        label: "Vaccine Administered",
                        hint: "Select vaccine",
                        value: null,
                        list: state.vaccineEntityList.map((vaccine) {
                          return DropdownMenuItem<VaccineModel>(
                            value: vaccine,
                            child: Text(
                              vaccine.nameEn ?? '',
                              style: TextStyle(color: context.appText),
                            ),
                          );
                        }).toList(),
                        onChanged: (vaccine) {
                          if (vaccine == null) return;
                          context.read<ProfileBloc>().add(
                            VaccineSelected(vaccine),
                          );
                        },
                      ),

                    const SizedBox(height: 10),
                    state.vaccineList.isNotEmpty
                        ? SizedBox(
                            height: state.vaccineList.length == 1
                                ? MediaQuery.of(context).size.height * 0.25
                                : MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: state.vaccineList.length,
                              itemBuilder: (context, index) {
                                final vaccine = state.vaccineList[index];
                                return _buildVaccineItem(
                                  context,
                                  vaccine,
                                  state,
                                  index,
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                    const SizedBox(height: 24),

                    /// Upload Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Medical Records (*Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: context.appText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () => pickDocument(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: context.appSurfaceVariant,
                          border: Border.all(color: context.appBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            hasFile == true
                                ? const Icon(
                                    Icons.description,
                                    color: Colors.blue,
                                  )
                                : const SizedBox(),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                hasFile == true
                                    ? state.medicalFile!.name
                                    : '🗂️ Upload files',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: hasFile == true
                                      ? context.appText
                                      : context.appMutedText,
                                ),
                              ),
                            ),
                            if (hasFile == true)
                              GestureDetector(
                                onTap: () {
                                  context.read<ProfileBloc>().add(
                                    FileRemoved(),
                                  );
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red[400],
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVaccineItem(
    BuildContext context,
    VaccineEntity vaccine,
    ProfileState state,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border.all(width: 1, color: context.appBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vaccine.vaccineName ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.appText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Was this vaccine given?",
            style: TextStyle(color: context.appMutedText),
          ),
          const SizedBox(height: 5),
          _buildSpayedToggle(context, state, index, vaccine),
          const SizedBox(height: 10),

          AppTextField(
            label: 'Vaccinated on (Optional)',
            hint: "Enter vaccination date",
            readOnly: true,
            value: vaccine.vaccinationDate ?? "",
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            onTap: () async {
              {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  final formattedDate =
                      "${pickedDate.year.toString().padLeft(4, '0')}-"
                      "${pickedDate.month.toString().padLeft(2, '0')}-"
                      "${pickedDate.day.toString().padLeft(2, '0')}";

                  context.read<ProfileBloc>().add(
                    VaccineDateChanged(
                      index: index,
                      vaccinatedDate: formattedDate,
                    ),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 5),
          Text(
            "You can skip this if you don't remember the exact date.",
            style: TextStyle(fontSize: 11, color: context.appMutedText),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSpayedToggle(
    BuildContext context,
    ProfileState state,
    int index,
    VaccineEntity vaccine,
  ) {
    return Row(
      children: [
        _spayedButton("YES", context, state, index, vaccine),
        const SizedBox(width: 15),
        _spayedButton("NO", context, state, index, vaccine),
        const SizedBox(width: 15),
        _spayedButton("NOT SURE", context, state, index, vaccine),
      ],
    );
  }

  Widget _spayedButton(
    String type,
    BuildContext context,
    ProfileState state,
    int index,
    VaccineEntity vaccine,
  ) {
    bool isSelected = vaccine.status == type;
    return Expanded(
      child: InkWell(
        onTap: () => {
          context.read<ProfileBloc>().add(
            VaccineStatusChanged(index: index, status: type),
          ),
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? context.appSoftPrimary : context.appSurface,
            border: Border.all(
              color: isSelected ? AppColors.primary : context.appBorder,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? AppColors.primary : context.appMutedText,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
