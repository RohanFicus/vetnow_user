import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vetnow_user/core/localization/app_strings.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';
import 'package:vetnow_user/core/utils/pet_utils.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/appointment_request.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_bloc.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_event.dart';
import 'package:vetnow_user/features/auth/presentation/bloc/dashboardProfile/dashboard_state.dart';

import '../../../../core/theme/app_color.dart';
import '../components/AppButton.dart';
import '../components/app_bar.dart';
import './payment_summary_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _today = _dateOnly(DateTime.now());
    _selectedDate = _today;
    _visibleDateStart = _today;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSlots();
      context.read<DashboardBloc>().add(FetchAllSpeciesEvent());

      final state = context.read<DashboardBloc>().state;
      if (state.pets.isNotEmpty) {
        final defaultPet = state.pets.first;
        setState(() {
          _selectedPet = defaultPet;
        });
        if (defaultPet.profile?.speciesId != null) {
          context.read<DashboardBloc>().add(
            FetchSymptomsEvent(defaultPet.profile!.speciesId!),
          );
        }
      }
    });
  }

  void _fetchSlots() {
    final state = context.read<DashboardBloc>().state;
    final doctorId =
        state.doctorAvailability?.doctorId ??
        state.doctorProfile?.doctorAvailabilityResponse?.doctorId ??
        state.doctorProfile?.doctorId;

    if (doctorId == null) return;

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
        if (state.bookingSuccess && _lastRequest != null) {
          final req = _lastRequest;
          _lastRequest = null;
          final dashboardBloc = context.read<DashboardBloc>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: dashboardBloc,
                child: PaymentSummaryScreen(
                  selectedTime: selectedTime!,
                  appointmentRequest: req,
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
          appBar: buildSimpleAppBar(context, context.strings.bookAppointment),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _monthLabel(_selectedDate, context),
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
                                                  final previousStart =
                                                      _visibleDateStart
                                                          .subtract(
                                                            const Duration(
                                                              days: 7,
                                                            ),
                                                          );
                                                  _visibleDateStart =
                                                      previousStart.isBefore(
                                                        _today,
                                                      )
                                                      ? _today
                                                      : previousStart;
                                                  if (_selectedDate.isBefore(
                                                    _visibleDateStart,
                                                  )) {
                                                    _selectedDate =
                                                        _visibleDateStart;
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
                                            _visibleDateStart =
                                                _visibleDateStart.add(
                                                  const Duration(days: 7),
                                                );
                                            if (_selectedDate.isBefore(
                                                  _visibleDateStart,
                                                ) ||
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                itemBuilder: (context, index) {
                                  final date = visibleDates[index];
                                  final isSelected = _isSameDate(
                                    _selectedDate,
                                    date,
                                  );
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
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _weekdayLabel(date, context),
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
                              context.strings.selectTimeSlot,
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
                            const SizedBox(height: 14),
                            _buildAdditionalNotesSection(),
                            const SizedBox(height: 14),
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
                  text: state.isLoading
                      ? context.strings.pleaseWait
                      : context.strings.continueText,
                  textColor: _canProceed && !state.isLoading
                      ? Colors.white
                      : Colors.grey,
                  color: _canProceed && !state.isLoading
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  onPressed: _canProceed && !state.isLoading
                      ? () => _showConsentBottomSheet(context, state)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConsentBottomSheet(BuildContext context, DashboardState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => TelemedicineConsentBottomSheet(
        onAccept: () => _handleProceed(context, state, consentAccepted: true),
      ),
    );
  }

  void _handleProceed(
    BuildContext context,
    DashboardState state, {
    bool consentAccepted = true,
  }) {
    final doctorId =
        state.doctorAvailability?.doctorId ??
        state.doctorProfile?.doctorAvailabilityResponse?.doctorId ??
        state.doctorProfile?.doctorId;

    if (doctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Doctor information is missing")),
      );
      return;
    }

    _lastRequest = AppointmentRequest(
      doctorId: doctorId,
      petId: _selectedPet?.profile?.id ?? "",
      speciesId: _selectedSpecies?.id ?? _selectedPet?.profile?.speciesId ?? "",
      appointmentDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      appointmentTime: selectedTime!.replaceAll(
        RegExp(r' [AP]M'),
        '',
      ), // Simple format conversion
      consultationType: "VIDEO",
      notes: _notesController.text,
      symptomIds: _selectedSymptoms.join(','),
      attachments: _attachments.isNotEmpty
          ? File(_attachments.first.path!)
          : null,
      consentAccepted: consentAccepted,
    );

    // Call the API
    context.read<DashboardBloc>().add(BookAppointmentEvent(_lastRequest!));
  }

  Widget _buildSymptomsSection(DashboardState state) {
    if (state.symptomsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.strings.selectSymptoms, context.strings.optional),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: state.symptomsList.map((symptom) {
            final isSelected = _selectedSymptoms.contains(symptom.id);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSymptoms.remove(symptom.id);
                  } else {
                    _selectedSymptoms.add(symptom.id);
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
                  _getLocalizedSymptomName(context, symptom.nameEn),
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
        _buildSectionTitle(context.strings.additionalNotes, context.strings.optional),
        const SizedBox(height: 10),
        TextField(
          controller: _notesController,
          style: TextStyle(color: context.appText),
          maxLines: 4,
          minLines: 4,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: context.strings.describeConcernsOrSymptoms,
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
        _buildSectionTitle(context.strings.attachments, context.strings.optional),
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
                Icon(
                  Icons.upload_outlined,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  context.strings.uploadFilesText,
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
            context.strings.noSlotsAvailable,
            style: TextStyle(color: context.appMutedText),
          ),
        ),
      );
    }

    return Column(
      children: [
        _slotCategory(
          context.strings.morningSlots,
          morning.map((e) => e.time ?? "").toList(),
          Icons.wb_sunny_outlined,
        ),
        _slotCategory(
          context.strings.afternoonSlots,
          afternoon.map((e) => e.time ?? "").toList(),
          Icons.light_mode_outlined,
        ),
        _slotCategory(
          context.strings.eveningSlots,
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
                  color: isSelected ? AppColors.primary : context.appSurface,
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
            context.strings.selectPetForBooking,
            style: TextStyle(
              color: context.appText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.strings.choosePetOrSpecies,
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
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.strings.bookingFor(
                        _selectedPet != null
                            ? (_selectedPet!.profile?.name ?? context.strings.petFallback)
                            : (_selectedSpecies?.nameEn ?? context.strings.bySpecies),
                      ),
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
          context.read<DashboardBloc>().add(
            FetchSymptomsEvent(profile!.speciesId!),
          );
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
                    profile?.name ?? context.strings.unnamedPet,
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
                    profile?.speciesName ?? context.strings.petFallback,
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
          color: isSelected ? AppColors.primary : context.appSurfaceVariant,
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
              _selectedSpecies?.nameEn ?? context.strings.other,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: isSelected ? Colors.white : context.appText,
              ),
            ),
            Text(
              context.strings.bySpecies,
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

  Future<void> _showSpeciesBottomSheet(DashboardState initialState) async {
    final dashboardBloc = context.read<DashboardBloc>();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.appSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: dashboardBloc,
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  final speciesList = state.allSpecies;
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
                            context.strings.bookBySpecies,
                            style: TextStyle(
                              color: context.appText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            context.strings.selectSpeciesForBooking,
                            style: TextStyle(
                              color: context.appMutedText,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 18),
                          if (state.isLoading && speciesList.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (speciesList.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  context.strings.noSpeciesFound,
                                  style: TextStyle(color: context.appMutedText),
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: GridView.builder(
                                controller: scrollController,
                                itemCount: speciesList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.6,
                                    ),
                                itemBuilder: (context, index) {
                                  final species = speciesList[index];
                                  final isSelected =
                                      _selectedSpecies?.id == species.id;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedSpecies = species;
                                        _selectedPet = null;
                                        selectedTime = null;
                                        _selectedSymptoms.clear();
                                      });
                                      if (species.id != null) {
                                        context.read<DashboardBloc>().add(
                                          FetchSymptomsEvent(species.id!),
                                        );
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            PetUtils.getSpeciesIcon(
                                              species.nameEn,
                                            ),
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.primary,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            species.nameEn ?? "Species",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? Colors.white
                                                  : context.appText,
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
                  );
                },
              );
            },
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

  String _weekdayLabel(DateTime date, BuildContext context) {
    const enLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    const hiLabels = ["रवि", "सोम", "मंगल", "बुध", "गुरु", "शुक्र", "शनि"];
    final isHi = context.strings.languageCode == 'hi' || AppStrings.currentLanguage == 'hi';
    final labels = isHi ? hiLabels : enLabels;
    return labels[date.weekday % 7];
  }

  String _monthLabel(DateTime date, BuildContext context) {
    const enMonths = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    const hiMonths = [
      "जनवरी", "फ़रवरी", "मार्च", "अप्रैल", "मई", "जून",
      "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"
    ];
    final isHi = context.strings.languageCode == 'hi' || AppStrings.currentLanguage == 'hi';
    final monthName = isHi ? hiMonths[date.month - 1] : enMonths[date.month - 1];
    return "$monthName ${date.year}";
  }

  String _getLocalizedSymptomName(BuildContext context, String? enName) {
    if (enName == null || enName.isEmpty) return '';
    final isHindi = context.strings.languageCode == 'hi' || AppStrings.currentLanguage == 'hi';
    if (!isHindi) return enName;

    const map = {
      "Diarrhea": "दस्त",
      "Lethargy": "सुस्ती",
      "Loss of Appetite": "भूख में कमी",
      "Complete Loss of Appetite": "भूख पूरी तरह खत्म",
      "Increased Appetite": "भूख बढ़ना",
      "Increased Thirst": "प्यास बढ़ना",
      "Decreased Water Intake": "कम पानी पीना",
      "Vomiting": "उल्टी",
      "Repeated Vomiting": "बार-बार उल्टी",
      "Hairball Regurgitation or Vomiting": "हेयरबॉल या उल्टी",
      "Blood in Vomit": "उल्टी में खून",
      "Bloody Diarrhea": "खूनी दस्त",
      "Mucus in Stool": "मल में बलगम",
      "Constipation": "कब्ज",
      "Fever": "बुखार",
      "Coughing": "खांसी",
      "Sneezing": "छींकना",
      "Itching": "खुजली",
      "Limping": "लंगड़ाना",
      "Eye Discharge": "आंखों से स्राव",
      "Nasal Discharge": "नाक से स्राव",
      "Ear Infection": "कान में संक्रमण",
      "Skin Rash": "त्वचा पर चकत्ते",
    };

    return map[enName] ?? enName;
  }

  bool get _canProceed {
    return selectedTime != null &&
        (_selectedPet != null || _selectedSpecies != null);
  }
}

class TelemedicineConsentBottomSheet extends StatefulWidget {
  final VoidCallback onAccept;

  const TelemedicineConsentBottomSheet({
    super.key,
    required this.onAccept,
  });

  @override
  State<TelemedicineConsentBottomSheet> createState() =>
      _TelemedicineConsentBottomSheetState();
}

class _TelemedicineConsentBottomSheetState
    extends State<TelemedicineConsentBottomSheet> {
  bool _isConsentChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.strings.telemedicineConsultation,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: context.appText,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: context.appMutedText),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Illustration Banner
          _buildIllustrationBanner(context),
          const SizedBox(height: 16),

          // Description Text
          Text(
            context.strings.telemedicineDesc,
            style: TextStyle(
              fontSize: 13.5,
              color: context.appMutedText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // 3 Info Points Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? context.appSurfaceVariant
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.appBorder.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  Icons.desktop_windows_outlined,
                  context.strings.telemedicineInfo1,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  Icons.description_outlined,
                  context.strings.telemedicineInfo2,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context,
                  Icons.medical_services_outlined,
                  context.strings.telemedicineInfo3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Checkbox Agreement Row
          GestureDetector(
            onTap: () {
              setState(() {
                _isConsentChecked = !_isConsentChecked;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _isConsentChecked
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _isConsentChecked
                          ? AppColors.primary
                          : context.appBorder,
                      width: 1.5,
                    ),
                  ),
                  child: _isConsentChecked
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.strings.telemedicineAgree,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: context.appText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Button
          AppButton(
            text: context.strings.acceptAndContinue,
            textColor: _isConsentChecked ? Colors.white : Colors.grey,
            color: _isConsentChecked
                ? AppColors.primary
                : (context.isDarkMode
                    ? const Color(0xFF1E293B)
                    : Colors.grey.shade300),
            onPressed: _isConsentChecked
                ? () {
                    Navigator.pop(context);
                    widget.onAccept();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationBanner(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.isDarkMode
              ? [const Color(0xFF0C2B64), const Color(0xFF1D4ED8)]
              : [const Color(0xFFDBEAFE), const Color(0xFF93C5FD)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft glow
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withValues(alpha: context.isDarkMode ? 0.3 : 0.4),
            ),
          ),
          // Doctor & Pets center avatars
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Dog avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text("🐶", style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 6),
                // Vet Doctor avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode ? const Color(0xFF1E3A8A) : Colors.white,
                    border: Border.all(color: AppColors.primary, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.person, size: 36, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 6),
                // Cat/Puppy avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text("🐱", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
          // Left chat badge
          Positioned(
            top: 16,
            left: 32,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          // Right video call badge
          Positioned(
            top: 16,
            right: 32,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.videocam_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: context.appMutedText),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: context.appText,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
