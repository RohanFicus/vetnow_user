import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_client.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/core/utils/pet_utils.dart';
import 'package:vetnow_user/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/data/repositories/profile_repository_impl.dart';
import 'package:vetnow_user/features/auth/domain/usecases/profile_usecase.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/pet_profile/profile_state.dart';
import 'package:vetnow_user/features/auth/presentation/components/app_text_field.dart';
import 'package:vetnow_user/features/auth/presentation/components/custom_dropdown.dart';

import '../../../../core/theme/app_color.dart';
import '../../data/models/vaccine_response_model.dart';
import '../../domain/entities/vaccine_entity.dart';

class EditPetProfileScreen extends StatelessWidget {
  final Pets pet;

  EditPetProfileScreen({super.key, required this.pet});

  // Form values
  String gender = 'MALE';
  List<String> selectedVaccines = ['Rabies', 'DHPP'];

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
    return BlocProvider(
      create: (_) {
        final bloc = ProfileBloc(
          ProfileUseCase(
            ProfileRepositoryImpl(
              ProfileRemoteDataSourceImpl(ApiClient()),
              SecureStorageService(),
            ),
          ),
          SecureStorageService(),
        )..add(ProfileCallLocally());
        if (pet.profile!.speciesId.toString().isNotEmpty) {
          bloc.add(VaccineCall(pet.profile!.speciesId.toString().toString()));
        }

        return bloc;
      },
      child: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) => previous.petName != current.petName,
        listener: (context, state) {
          print("Step Success ${state.petName}");
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: context.appBackground,
              appBar: AppBar(
                backgroundColor: context.appBackground,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: context.appText,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "Pet Profile",
                  style: TextStyle(
                    color: context.appText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileImage(),
                          const SizedBox(height: 30),

                          _sectionHeader(context, "Basic Details"),
                          _buildBasicDetailsCard(state, context),

                          const SizedBox(height: 25),
                          _sectionHeader(context, "Physical Details"),
                          _buildPhysicalDetailsCard(state, context),

                          const SizedBox(height: 25),
                          _sectionHeader(context, "Medical Details"),
                          _buildMedicalDetailsCard(state, context),

                          const SizedBox(height: 100),
                          // Space for persistent button
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: _buildBottomSaveButton(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final profileImage =
        (pet.profile?.qrCodeFileName != null &&
            pet.profile!.qrCodeFileName!.startsWith('http'))
        ? pet.profile!.qrCodeFileName!
        : PetUtils.getSpeciesImage(pet.profile?.speciesName);

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: NetworkImage(profileImage),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 22,
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: context.appMutedText,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildBasicDetailsCard(ProfileState state, BuildContext context) {
    return _cardWrapper(context, [
      AppTextField(
        label: 'Pet Name',
        hint: "Enter Pet Name",
        keyboardType: TextInputType.emailAddress,
        value: pet.profile?.name ?? '',
        readOnly: true,
      ),
      const SizedBox(height: 15),
      AppTextField(
        label: 'Unique Pet ID',
        hint: "Enter Unique Pet ID",
        keyboardType: TextInputType.emailAddress,
        value: pet.profile?.petUniqueId ?? '',
        readOnly: true,
      ),

      const SizedBox(height: 15),
      AppTextField(
        label: 'Species',
        hint: "Enter Species",
        keyboardType: TextInputType.emailAddress,
        value: pet.profile?.speciesName ?? '',
        readOnly: true,
      ),

      const SizedBox(height: 15),
      AppTextField(
        label: 'Breed',
        hint: "Enter Breed",
        keyboardType: TextInputType.emailAddress,
        value: pet.profile?.breedName ?? '',
        readOnly: true,
      ),

      const SizedBox(height: 15),
      _inputLabel(context, "Gender"),
      _buildGenderToggle(pet.profile?.sex ?? '', context),
      const SizedBox(height: 15),
      // -------------------------------------------------------
      // 4. Additional Info for Cow & Buffalo (Livestock)
      // -------------------------------------------------------
      if (_isLivestock(state) && state.petSex == "FEMALE") ...[
        _inputLabel(context, "Milking Status"),
        const SizedBox(height: 10),
        _buildToggleButton(
          context: context,
          isSelected: state.milkingStatus == true,
          onTap: (val) =>
              context.read<ProfileBloc>().add(MilkingStatusChanged(val)),
        ),
        const SizedBox(height: 20),

        // Only ask Pregnancy if NOT milking
        if (state.milkingStatus == false) ...[
          _inputLabel(context, "Is the animal pregnant?"),
          const SizedBox(height: 10),
          _buildToggleButton(
            context: context,
            isSelected: state.pregnancyStatus == true,
            onTap: (val) =>
                context.read<ProfileBloc>().add(PregnancyStatusChanged(val)),
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
          isSelected: state.petSpayed == true,
          onTap: (val) =>
              context.read<ProfileBloc>().add(PetSpayedChanged(val)),
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
        ),
        const SizedBox(height: 20),
      ],
    ]);
  }

  Widget _buildPhysicalDetailsCard(ProfileState state, BuildContext context) {
    return _cardWrapper(context, [
      AppTextField(
        label: 'Weight (kg)',
        hint: "Enter Weight",
        keyboardType: TextInputType.emailAddress,
        value: pet.profile?.weightKg != null
            ? pet.profile!.weightKg.toString()
            : '',
        readOnly: true,
      ),
      const SizedBox(height: 15),
      AppTextField(
        label: 'Color',
        hint: "Enter Color",
        keyboardType: TextInputType.emailAddress,
        value: pet.profile?.color ?? '',
        readOnly: true,
      ),
    ]);
  }

  Widget _buildMedicalDetailsCard(ProfileState state, BuildContext context) {
    final hasFile = state.medicalFile?.path?.isNotEmpty;
    return _cardWrapper(context, [
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
              child: Text(vaccine.nameEn ?? ''),
            );
          }).toList(),

          onChanged: (vaccine) {
            if (vaccine == null) return;
            context.read<ProfileBloc>().add(VaccineSelected(vaccine));
          },
        ),
      const SizedBox(height: 12),
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
                  return _buildVaccineItem(context, vaccine, state, index);
                },
              ),
            )
          : SizedBox(),
      Wrap(
        spacing: 10,
        children: pet.vaccinations!
            .map((v) => _buildChip(context, v.vaccineName.toString()))
            .toList(),
      ),
      const SizedBox(height: 20),

      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Medical Records (Optional)",
          style: TextStyle(fontWeight: FontWeight.w500, color: context.appText),
        ),
      ),
      const SizedBox(height: 8),

      // File Item (Mock)
      GestureDetector(
        onTap: () => pickDocument(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: context.appSurfaceVariant,
            border: Border.all(color: context.appBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.description, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasFile == true
                      ? state.medicalFile!.name.toString()
                      : 'Select File',
                  style: TextStyle(color: context.appText),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<ProfileBloc>().add(FileRemoved());
                },
                child: Icon(Icons.close, color: Colors.red[400], size: 20),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
    ]);
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

  // --- Helper Components ---

  Widget _cardWrapper(BuildContext context, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _inputLabel(
    BuildContext context,
    String label, {
    bool isNonEditable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: context.appText,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Figtree',
          ),
          children: isNonEditable
              ? [
                  TextSpan(
                    text: " (Non-editable)",
                    style: TextStyle(
                      color: context.appMutedText,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _textField(
    String value, {
    bool isEnabled = true,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextFormField(
      initialValue: value,
      enabled: isEnabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        filled: !isEnabled,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _genderButton(
    String type,
    String petSex,
    VoidCallback onTap,
    BuildContext context,
  ) {
    bool isSelected = petSex == type;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderToggle(String petSex, BuildContext context) {
    return Row(
      children: [
        _genderButton("MALE", petSex, () {
          context.read<ProfileBloc>().add(const PetGenderChanged("MALE"));
        }, context),
        const SizedBox(width: 15),
        _genderButton("FEMALE", petSex, () {
          context.read<ProfileBloc>().add(const PetGenderChanged("FEMALE"));
        }, context),
      ],
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          items: const [],
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.appSoftPrimary,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.close, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, String fileName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border.all(color: context.appBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              style: TextStyle(fontSize: 14, color: context.appText),
            ),
          ),
          const Icon(Icons.close, color: Colors.red, size: 20),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border.all(color: context.appBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_outlined, color: context.appMutedText),
          const SizedBox(width: 8),
          Text(
            "Upload files",
            style: TextStyle(
              color: context.appMutedText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSaveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      context.read<ProfileBloc>().add(FileSelected(result.files.single));
    }
  }
}
