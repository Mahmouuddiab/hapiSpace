import '../Repository/Profile_repo.dart';
import '../entities/Profile_Entity.dart';

class UpdateProfileUsecase {
  final ProfileRepo repository;
  UpdateProfileUsecase({required this.repository});

  Future<ProfileEntity> call({
    required String name,
    required String phone,
    required String location,
  }) =>
      repository.updateProfile(
        name: name,
        phone: phone,
        location: location,
      );
}