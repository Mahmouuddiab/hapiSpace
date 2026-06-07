import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:habiSpace/core/error/app_exception.dart';
import 'package:habiSpace/features/profile/domain/entities/Profile_Entity.dart';
import 'package:meta/meta.dart';
import '../../../domain/Use Cases/Delete_Profile_Usecae.dart';
import '../../../domain/Use Cases/Get_Profile_Usecase.dart';
import '../../../domain/Use Cases/change_password_usecase.dart';
import '../../../domain/Use Cases/delete_account_use_case.dart';
import '../../../domain/Use Cases/updata_profile_usecase.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final LogOutProfileUseCase logOut;
  final UpdateProfileUsecase updateProfileUsecase;
  final DeleteProfileUseCase deleteProfileUsecase;

  final ChangePasswordUsecase changePasswordUsecase;

  ProfileCubit({
    required this.logOut,
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
    required this.deleteProfileUsecase,
    required this.changePasswordUsecase,
  }) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUsecase.call();
      emit(ProfileLoaded([profile]));
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }

  Future<void> logOutProfile() async {
    emit(ProfileLoading());
    try {
      await logOut.execute();
      emit(ProfileLogOut());
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }

  Future<void> deleteProfile() async {
    emit(ProfileLoading());
    try {
      await deleteProfileUsecase.execute();
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String location,
  }) async {
    emit(ProfileLoading());
    try {
      final updated = await updateProfileUsecase.call(
        name: name,
        phone: phone,
        location: location,
      );
      emit(ProfileLoaded([updated]));
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }


  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ProfileLoading());
    try {
      final message = await changePasswordUsecase.call(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(ProfilePasswordChanged(message));
    } catch (e) {
      emit(ProfileError(handleException(e).message));
    }
  }

}
