import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';

import 'package:vetnow_user/core/utils/pet_utils.dart';
import '../components/app_bar.dart';
import '../components/AppButton.dart';
import './payment_summary_screen.dart';
import '../../../../core/theme/app_color.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  late final DateTime _today;
  late DateTime _selectedDate;
  late DateTime _visibleDateStart;
  Pets? _selectedPet;
  Species? _selectedSpecies;
  String? selectedTime;
  final TextEditingController _notesController = TextEditingController();
  final Set<String> _selectedSymptoms = <String>{};
  final List<PlatformFile> _attachments = <PlatformFile>[];
  AppointmentRequest? _lastRequest;

  final List<String> morningSlots = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
  ];
  final List<String> afternoonSlots = [
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
    "01:30 PM",
    "02:00 PM",
    "02:30 PM",
  ];
  final List<String> eveningSlots = ["03:00 PM", "03:30 PM", "04:00 PM"];
  final List<String> symptoms = [
    "Loss of appetite",
    "Vomiting",
    "Diarrhea",
    "Lethargy",
    "Fever",
    "Coughing",
    "Limping",
    "Skin issues",
  ];

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _selectedDate = _today;
    _visibleDateStart = _today;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSlots();
    });
  }

  void _fetchSlots() {
    final state = context.read<DashboardBloc>().state;
    final doctorId = state.doctorAvailability?.doctorId ??
        state.doctorProfile?.doctorAvailabilityResponse?.doctorId ??
        state.doctorProfile?.doctorId ??
        "doc-001";
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    context.read<DashboardBloc>().add(
          FetchAvailableSlotsEvent(doctorId: doctorId, date: date),
        );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        if (state.bookingSuccess && _lastRequest != null) {
          final dashboardBloc = context.read<DashboardBloc>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: dashboardBloc,
                child: PaymentSummaryScreen(
                  selectedTime: selectedTime!,
                  appointmentRequest: _lastRequest,
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final visibleDates = List<DateTime>.generate(
          7,
          (index) => _visibleDateStart.add(Duration(days: index)),
        );
        final canGoToPreviousDates = _visibleDateStart.isAfter(_today);

        return Scaffold(
          backgroundColor: context.appBackground,
          appBar: buildSimpleAppBar(context, "Book Appointment"),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildSelectionHeader(state),

                      // Date Selector Strip
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        color: context.appSoftPrimary,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _monthLabel(_selectedDate),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: context.appText,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: canGoToPreviousDates
                                            ? () {
                                                setState(() {
                                                  final previousStart = _visibleDateStart
                                                      .subtract(const Duration(days: 7));
                                                  _visibleDateStart =
                                                      previousStart.isBefore(_today)
                                                          ? _today
                                                          : previousStart;
                                                  if (_selectedDate
                                                      .isBefore(_visibleDateStart)) {
                                                    _selectedDate = _visibleDateStart;
                                                    selectedTime = null;
                                                  }
                                                });
                                              }
                                            : null,
                                        child: Icon(
                                          Icons.chevron_left,
                                          size: 20,
                                          color: canGoToPreviousDates
                                              ? context.appText
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _visibleDateStart = _visibleDateStart.add(
                                              const Duration(days: 7),
                                            );
                                            if (_selectedDate.isBefore(_visibleDateStart) ||
                                                _selectedDate.isAfter(
                                                  _visibleDateStart.add(
                                                    const Duration(days: 6),
                                                  ),
                                                )) {
                                              _selectedDate = _visibleDateStart;
                                              selectedTime = null;
                                            }
                                          });
                                        },
                                        child: Icon(
                                          Icons.chevron_right,
                                          size: 20,
                                          color: context.appText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 70,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: visibleDates.length,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                itemBuilder: (context, index) {
                                  final date = visibleDates[index];
                                  final isSelected = _isSameDate(_selectedDate, date);
                                  final isPastDate = date.isBefore(_today);

                                  return GestureDetector(
                                    onTap: isPastDate
                                        ? null
                                        : () {
                                            setState(() {
                                              _selectedDate = date;
                                              selectedTime = null;
                                            });
                                            _fetchSlots();
                                          },
                                    child: Container(
                                      width: 50,
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary
                                            : isPastDate
                                                ? Colors.transparent
                                                : context.appSurface,
                                        borderRadius: BorderRadius.circular(10),
                                        border: isSelected
                                            ? null
                                            : Border.all(
                                                color: isPastDate
                                                    ? Colors.transparent
                                                    : context.appBorder,
                                              ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _weekdayLabel(date),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : isPastDate
                                                      ? Colors.grey.shade400
                                                      : Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "${date.day}",
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : isPastDate
                                                      ? Colors.grey.shade400
                                                      : context.appText,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Timeslot Selection
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Timeslot",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: context.appText,
                              ),
                            ),
                            const SizedBox(height: 15),
                            state.isLoading && state.availableSlots == null
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : _buildSlotsContent(state),
                            _buildSymptomsSection(state),
                            const SizedBox(height: 22),
                            _buildAdditionalNotesSection(),
                            const SizedBox(height: 22),
                            _buildAttachmentsSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  text: state.isLoading ? "Please wait..." : "Proceed to Payment",
                  textColor: _canProceed && !state.isLoading
                      ? Colors.white
                      : Colors.grey,
                  color: _canProceed && !state.isLoading
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  onPressed: _canProceed && !state.isLoading
                      ? () => _handleProceed(context, state)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleProceed(BuildContext context, DashboardState state) {
    _lastRequest = AppointmentRequest(
      doctorId: state.doctorAvailability?.doctorId ??
          state.doctorProfile?.doctorAvailabilityResponse?.doctorId ??
          state.doctorProfile?.doctorId ??
          "doc-001",
      petId: _selectedPet?.profile?.id ?? "",
      speciesId: _selectedSpecies?.id ?? _selectedPet?.profile?.speciesId ?? "",
      appointmentDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      appointmentTime: selectedTime!.replaceAll(RegExp(r' [AP]M'), ''), // Simple format conversion
      consultationType: "VIDEO",
      notes: _notesController.text,
      symptomIds: _selectedSymptoms.join(','),
      attachments: _attachments.isNotEmpty ? File(_attachments.first.path!) : null,
    );

    // Call the API
    context.read<DashboardBloc>().add(BookAppointmentEvent(_lastRequest!));
  }

  Widget _buildSymptomsSection(DashboardState state) {
    final displaySymptoms = state.symptomsList.isNotEmpty
        ? state.symptomsList.map((e) => e.nameEn).toList()
        : symptoms;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Symptoms", "Optional"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: displaySymptoms.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSymptoms.remove(symptom);
                  } else {
                    _selectedSymptoms.add(symptom);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : context.appSurfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.appBorder),
                ),
                child: Text(
                  symptom,
                  style: TextStyle(
                    color: isSelected ? Colors.white : context.appText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Additional Notes", "Optional"),
        const SizedBox(height: 10),
        TextField(
          controller: _notesController,
          style: TextStyle(color: context.appText),
          maxLines: 4,
          minLines: 4,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: "Describe any concerns or symptoms",
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: const EdgeInsets.all(14),
            filled: true,
            fillColor: context.appSurface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.appBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Attachments", "Optional"),
        const SizedBox(height: 10),
        ..._attachments.map(_buildAttachmentTile),
        GestureDetector(
          onTap: _pickAttachments,
          child: Container(
            width: double.infinity,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.appBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload_outlined,
                    size: 18, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text(
                  "Upload files",
                  style: TextStyle(
                    color: context.appMutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentTile(PlatformFile file) {
    final isPdf = file.extension?.toLowerCase() == "pdf";

    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Icon(
            isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
            size: 19,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.appText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close, color: Color(0xFFE53935), size: 20),
            onPressed: () {
              setState(() => _attachments.remove(file));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String trailing) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: context.appText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: " ($trailing)",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (!mounted || result == null) return;

    setState(() {
      _attachments.addAll(result.files);
    });
  }

  Widget _buildSlotsContent(DashboardState state) {
    final morning = state.availableSlots?.morning ?? [];
    final afternoon = state.availableSlots?.afternoon ?? [];
    final evening = state.availableSlots?.evening ?? [];

    if (morning.isEmpty && afternoon.isEmpty && evening.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "No slots available for this date",
            style: TextStyle(color: context.appMutedText),
          ),
        ),
      );
    }

    return Column(
      children: [
        _slotCategory(
          "Morning Slots",
          morning.map((e) => e.time ?? "").toList(),
          Icons.wb_sunny_outlined,
        ),
        _slotCategory(
          "Afternoon Slots",
          afternoon.map((e) => e.time ?? "").toList(),
          Icons.light_mode_outlined,
        ),
        _slotCategory(
          "Evening Slots",
          evening.map((e) => e.time ?? "").toList(),
          Icons.nights_stay_outlined,
        ),
      ],
    );
  }

  Widget _slotCategory(String title, List<String> slots, IconData icon) {
    if (slots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const Divider(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((time) {
            bool isSelected = selectedTime == time;
            return GestureDetector(
              onTap: () => setState(() => selectedTime = time),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primary : context.appSurface,
                  border: Border.all(color: context.appBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : context.appText,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildSelectionHeader(DashboardState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      color: context.appSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Pet",
            style: TextStyle(
              color: context.appText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Choose a registered pet or book by species.",
            style: TextStyle(color: context.appMutedText, fontSize: 13),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...state.pets.map(_buildPetCard),
                _buildOtherCard(state),
              ],
            ),
          ),
          if (_selectedPet != null || _selectedSpecies != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: context.appSoftPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedPet != null
                          ? "Booking for ${_selectedPet!.profile?.name ?? 'your pet'}"
                          : "Booking for ${_selectedSpecies?.nameEn ?? 'selected species'}",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPetCard(Pets pet) {
    final profile = pet.profile;
    final isSelected =
        _selectedPet?.profile?.petUniqueId == profile?.petUniqueId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPet = pet;
          _selectedSpecies = null;
          selectedTime = null;
          _selectedSymptoms.clear();
        });
        if (profile?.speciesId != null) {
          context
              .read<DashboardBloc>()
              .add(FetchSymptomsEvent(profile!.speciesId!));
        }
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : context.appSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.appBorder,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: context.appSurfaceVariant,
              backgroundImage: NetworkImage(
                PetUtils.getSpeciesImage(profile?.speciesName),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.name ?? "Unnamed",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: isSelected ? Colors.white : context.appText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.speciesName ?? "Pet",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white70 : context.appMutedText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherCard(DashboardState state) {
    final isSelected = _selectedPet == null && _selectedSpecies != null;

    return GestureDetector(
      onTap: () => _showSpeciesBottomSheet(state),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary : context.appSurfaceVariant,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.appBorder,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white24 : context.appSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
            Text(
              _selectedSpecies?.nameEn ?? "Other",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: isSelected ? Colors.white : context.appText,
              ),
            ),
            Text(
              "By species",
              style: TextStyle(
                fontSize: 8,
                color: isSelected ? Colors.white70 : context.appMutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSpeciesBottomSheet(DashboardState state) async {
    // Collect all species from appointments/pets or use a default list if needed.
    // Assuming you might want to show unique species from the dashboard state.
    final speciesOptions = state.pets.map((p) => p.profile?.speciesId).toSet();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Book By Species",
                  style: TextStyle(
                    color: context.appText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Select the species for which you want to book an appointment.",
                  style: TextStyle(color: context.appMutedText, fontSize: 13),
                ),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: state.pets.length, // Simplified for brevity
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                  ),
                  itemBuilder: (context, index) {
                    final pet = state.pets[index];
                    final species = Species(
                      id: pet.profile?.speciesId ?? "",
                      nameEn: pet.profile?.speciesName ?? "Species",
                    );
                    final isSelected = _selectedSpecies?.id == species.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSpecies = species;
                          _selectedPet = null;
                          selectedTime = null;
                          _selectedSymptoms.clear();
                        });
                        if (species.id != null) {
                          context
                              .read<DashboardBloc>()
                              .add(FetchSymptomsEvent(species.id!));
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : context.appSurfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : context.appBorder,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              PetUtils.getSpeciesIcon(species.nameEn),
                              color:
                                  isSelected ? Colors.white : AppColors.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              species.nameEn ?? "Species",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color:
                                    isSelected ? Colors.white : context.appText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _weekdayLabel(DateTime date) {
    const labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return labels[date.weekday % 7];
  }

  String _monthLabel(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  bool get _canProceed {
    return selectedTime != null &&
        (_selectedPet != null || _selectedSpecies != null);
  }

}
