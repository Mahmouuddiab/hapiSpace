import 'package:get_it/get_it.dart';
import 'package:habiSpace/features/History/data/history_data_source.dart';
import 'package:habiSpace/features/History/data/history_data_source_impl.dart';
import 'package:habiSpace/features/History/data/history_repo_impl.dart';
import 'package:habiSpace/features/History/domain/Repository/history_repo.dart';
import 'package:habiSpace/features/chat/data/chat_repo_impl/chat_repo_impl.dart';
import 'package:habiSpace/features/chat/data/datasource/chat_remote_dataSource.dart';
import 'package:habiSpace/features/chat/domain/chat_repo/chat_repo.dart';
import 'package:habiSpace/features/chat/domain/usescases/get_conversation_usecase.dart';
import 'package:habiSpace/features/chat/domain/usescases/get_conversations_usecase.dart';
import 'package:habiSpace/features/chat/domain/usescases/send_message_usecase.dart';
import 'package:habiSpace/features/chat/domain/usescases/start_conversation_usecase.dart';
import 'package:habiSpace/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:habiSpace/features/details/data/datasource/details_remote_datasource.dart';
import 'package:habiSpace/features/details/data/details_repo_impl/details_repo_impl.dart';
import 'package:habiSpace/features/details/domain/details_repo/details_repo.dart';
import 'package:habiSpace/features/details/domain/useCases/add_review_usecase.dart';
import 'package:habiSpace/features/details/domain/useCases/getProperty_detail_useCase.dart';
import 'package:habiSpace/features/details/domain/useCases/getProperty_reviews_useCase.dart';
import 'package:habiSpace/features/details/presentation/cubit/details_cubit.dart';
import 'package:habiSpace/features/favorite/data/datasource/FavoriteRemoteDataSource.dart';
import 'package:habiSpace/features/favorite/data/favo_repo_impl/FavoriteRepositoryImpl.dart';
import 'package:habiSpace/features/favorite/domain/repositories/Favorite_repository.dart';
import 'package:habiSpace/features/favorite/domain/useCases/Add_to_favourite.dart';
import 'package:habiSpace/features/favorite/domain/useCases/Get_list_favourite.dart';
import 'package:habiSpace/features/favorite/domain/useCases/Remove_favourite.dart';
import 'package:habiSpace/features/favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import 'package:habiSpace/features/home/data/datasource/home_remote_datasource.dart';
import 'package:habiSpace/features/home/data/home_repo_impl/home_repo_impl.dart';
import 'package:habiSpace/features/home/domain/home_repo/home_repo.dart';
import 'package:habiSpace/features/home/domain/useCases/filter_properties_usecase.dart';
import 'package:habiSpace/features/home/domain/useCases/get_home_usecase.dart';
import 'package:habiSpace/features/home/domain/useCases/search_properties_usecase.dart';
import 'package:habiSpace/features/home/presentation/cubit/home_cubit.dart';
import 'package:habiSpace/features/profile/data/datasource/Profile_data_source_impl.dart';
import 'package:habiSpace/features/profile/data/repo/Profile_repo_impl.dart';
import 'package:habiSpace/features/profile/domain/Repository/Profile_repo.dart';
import 'package:habiSpace/features/profile/domain/Use%20Cases/Delete_Profile_Usecae.dart';
import 'package:habiSpace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import '../../features/History/domain/Use Cases/Get_Orders.dart';
import '../../features/History/presentation/Cubit/cubit/history_cubit.dart';
import '../../features/auth/data/datasource/auth_datasource.dart';
import '../../features/auth/data/datasource/auth_datasource_impl.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/presentation/logic/auth_bloc.dart';
import '../../features/profile/domain/Use Cases/Get_Profile_Usecase.dart';
import '../../features/profile/domain/Use Cases/change_password_usecase.dart';
import '../../features/profile/domain/Use Cases/delete_account_use_case.dart';
import '../../features/profile/domain/Use Cases/updata_profile_usecase.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Prevent duplicate registrations
  if (sl.isRegistered<HomeRemoteDataSource>()) return;

  // ============================================================
  // HOME FEATURE
  // ============================================================

  sl.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sl()));

  sl.registerLazySingleton(() => GetHomeUseCase(sl<HomeRepo>()));
  sl.registerLazySingleton(() => SearchPropertiesUseCase(sl<HomeRepo>()));
  sl.registerLazySingleton(() => FilterPropertiesUseCase(sl<HomeRepo>()));

  sl.registerFactory(
        () => HomeCubit(
      sl<GetHomeUseCase>(),
      sl<SearchPropertiesUseCase>(),
      sl<FilterPropertiesUseCase>(),
    ),
  );

  // ============================================================
  // FAVORITE FEATURE
  // ============================================================

  sl.registerLazySingleton<FavoriteRemoteDataSource>(
        () => const FavoriteRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetListFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => AddToFavouriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavouriteUseCase(sl()));

  sl.registerFactory(
        () => FavoriteCubit(
      getListFavoriteUseCase: sl(),
      addToFavouriteUseCase: sl(),
      removeFavouriteUseCase: sl(),
    ),
  );

  // ============================================================
  // CHAT FEATURE
  // ============================================================

  sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ChatRepo>(
        () => ChatRepoImpl(sl<ChatRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetConversationUseCase(sl<ChatRepo>()));
  sl.registerLazySingleton(() => GetConversationsUseCase(sl<ChatRepo>()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl<ChatRepo>()));
  sl.registerLazySingleton(() => StartConversationUseCase(sl<ChatRepo>()));

  sl.registerFactory(
        () => ChatCubit(
      sl<GetConversationUseCase>(),
      sl<GetConversationsUseCase>(),
      sl<SendMessageUseCase>(),
      sl<StartConversationUseCase>(),
    ),
  );

  // ============================================================
  // AUTH FEATURE
  // ============================================================

  sl.registerLazySingleton<AuthDatasource>(() => AuthDatasourceImpl());

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(authDatasource: sl()),
  );

  sl.registerFactory<AuthBloc>(
        () => AuthBloc(authRepository: sl()),
  );

  // ============================================================
  // HISTORY FEATURE
  // ============================================================

  sl.registerLazySingleton<HistoryDatasource>(
        () => HistoryDataSourceImpl(),
  );

  sl.registerLazySingleton<HistoryRepo>(
        () => HistoryRepoImpl(historyDataSource: sl<HistoryDatasource>()),
  );

  sl.registerLazySingleton(() => GetOrders(sl<HistoryRepo>()));

  sl.registerFactory(
        () => HistoryCubit(sl<GetOrders>()),
  );

  // ============================================================
  // PROFILE FEATURE
  // ============================================================

  sl.registerLazySingleton<ProfileDataSourceImpl>(
        () => ProfileDataSourceImpl(),
  );

  sl.registerLazySingleton<ProfileRepo>(
        () => ProfileRepoImpl(
      repo: sl<ProfileDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton(
        () => GetProfileUsecase(
      repository: sl<ProfileRepo>(),
    ),
  );

  sl.registerLazySingleton(
        () => UpdateProfileUsecase(
      repository: sl<ProfileRepo>(),
    ),
  );

  sl.registerLazySingleton(
        () => ChangePasswordUsecase(
      repository: sl<ProfileRepo>(),
    ),
  );

  sl.registerLazySingleton(
        () => DeleteProfileUseCase(
      repo: sl<ProfileRepo>(),
    ),
  );

  sl.registerLazySingleton(
        () => LogOutProfileUseCase(
      sl<ProfileRepo>(),
    ),
  );

  sl.registerFactory(
        () => ProfileCubit(
      getProfileUsecase: sl<GetProfileUsecase>(),
      logOut: sl<LogOutProfileUseCase>(),
      updateProfileUsecase: sl<UpdateProfileUsecase>(),
      deleteProfileUsecase: sl<DeleteProfileUseCase>(),
      changePasswordUsecase: sl<ChangePasswordUsecase>(),
    ),
  );

  // ============================================================
  // DETAILS FEATURE
  // ============================================================

  sl.registerLazySingleton<DetailsRemoteDataSource>(
        () => DetailsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<DetailsRepo>(
        () => DetailsRepoImpl(
      sl<DetailsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton(
        () => GetPropertyDetailUseCase(sl<DetailsRepo>()),
  );

  sl.registerLazySingleton(
        () => GetPropertyReviewsUseCase(sl<DetailsRepo>()),
  );

  sl.registerLazySingleton(
        () => AddReviewUseCase(sl<DetailsRepo>()),
  );

  sl.registerFactory(
        () => DetailsCubit(
      getPropertyDetailUseCase: sl<GetPropertyDetailUseCase>(),
      getPropertyReviewsUseCase: sl<GetPropertyReviewsUseCase>(),
      addReviewUseCase: sl<AddReviewUseCase>(),
    ),
  );
}
