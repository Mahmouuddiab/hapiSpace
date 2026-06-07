import '../Repository/Profile_repo.dart';

class LogOutProfileUseCase {
  final ProfileRepo repo;

  LogOutProfileUseCase(this.repo);
  Future<void>execute ()async{
    await repo.logOut();
  }
}