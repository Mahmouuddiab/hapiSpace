import '../Repository/Profile_repo.dart';
import '../entities/Profile_Entity.dart';

class GetProfileUsecase {
  final ProfileRepo repository;

  GetProfileUsecase({required this.repository});

  Future<ProfileEntity> call() async {
   return  repository.getProfileData();
  }


}


