import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  Future<void> fetchUserProfile(String email) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(email);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('User Not Found'));
      }
    } catch (e) {}
  }

  Future<void> updatedProfile(
      {required String email,
      String? newBio,
      Uint8List? Unit8BytesWeb,
      String? filePathWeb}) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(email);
      if (currentUser == null) {
        emit(ProfileError('Faild to fetch user'));
        return;
      }

      String? downloadUrl;

      if (Unit8BytesWeb != null || filePathWeb != null) {
        if (Unit8BytesWeb != null) {
          downloadUrl =
              await storageRepo.uploadProfileImageWeb(Unit8BytesWeb, email);
        } else if (filePathWeb != null) {
          downloadUrl =
              await storageRepo.uploadProfileImageMobile(filePathWeb, email);
        }
      }
      if (downloadUrl == null) {
        emit(ProfileError('Faild to upload image'));
      }

      final updatedProfile = currentUser.copyWith(
          newBio: newBio ?? currentUser.bio,
          newProfileImageUrl: downloadUrl ?? currentUser.profileimageurl
          );

      await profileRepo.updateProfile(updatedProfile, email);

      await fetchUserProfile(email);
    } catch (e) {
      emit(ProfileError("Erroro updating profile: $e"));
    }
  }
}
