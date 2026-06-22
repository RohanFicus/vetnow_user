import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetnow_user/core/network/api_exception.dart';
import 'package:vetnow_user/core/storage/secure_storage_service.dart';
import 'package:vetnow_user/features/auth/data/models/dashboard_response_model.dart';
import 'package:vetnow_user/features/auth/domain/entities/owner_profile_entity.dart';
import 'package:vetnow_user/features/auth/domain/usecases/verify_otp_usecase.dart';

import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final SecureStorageService storageService;

  OtpBloc(this.verifyOtpUseCase, this.storageService)
    : super(OtpState.initial()) {
    on<OtpChanged>(_onOtpChanged);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<OtpResendRequested>(_onOtpResend);
  }

  void _onOtpChanged(OtpChanged event, Emitter<OtpState> emit) {
    emit(
      state.copyWith(
        otp: event.otp,
        isComplete: event.otp.length == 6,
        error: null,
      ),
    );
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    if (!state.isComplete) return;

    final requestId = await storageService.getRequestId();

    if (requestId == null) {
      throw Exception("Request ID not found");
    }
    print("Pressed");
    // API call or navigation handled via BlocListener
    emit(state.copyWith(isLoading: true, error: null, otpVerifyEntity: null));
    try {
      final result = await verifyOtpUseCase.call(
        requestId: requestId,
        otp: state.otp,
      );
      print("Id===>${result.meta?.accessToken}");
      var token = result.meta?.accessToken?.toString();
      await storageService.saveToken(token.toString());
      DashBoardResponseModal? dashBoardResponseModal = result.data;
      storageService.saveDashboardDataJson(dashBoardResponseModal!.toJson());

      OwnerProfileEntity ownerProfileEntity = OwnerProfileEntity(
        firstName: result.data?.user?.firstName.toString(),
        lastName: result.data?.user?.lastName.toString(),
        mobile: result.data?.user?.mobile.toString(),
        email: result.data?.user?.email.toString(),
        isActive: result.data?.user?.isActive,
        role: result.data?.user?.role.toString(),
        id: result.data?.user?.id.toString(),
        profileImage: result.data?.user?.profileImage.toString(),
        address: result.data?.user?.address.toString(),
      );
      storageService.saveCustomerProfileJson(ownerProfileEntity.toJson());

      emit(state.copyWith(isLoading: false, otpVerifyEntity: result.data));
    } catch (e) {
      print("Error===>${e.toString()}");
      String message = "Failed to verify OTP";
      if (e is ApiException) {
        message = e.message;
      }
      emit(state.copyWith(isLoading: false, error: message));
    }
  }

  void _onOtpResend(OtpResendRequested event, Emitter<OtpState> emit) {
    emit(const OtpState());
  }
}
