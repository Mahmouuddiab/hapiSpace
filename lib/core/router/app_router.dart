import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habiSpace/core/di/get_it.dart';
import 'package:habiSpace/features/3d/presentation/ui/3d_view.dart';
import 'package:habiSpace/features/History/presentation/Cubit/cubit/history_cubit.dart';
import 'package:habiSpace/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:habiSpace/features/chat/presentation/ui/chat_view.dart';
import 'package:habiSpace/features/chat/presentation/ui/conversations_view.dart';
import 'package:habiSpace/features/details/domain/entities/property_detail_entity.dart';
import 'package:habiSpace/features/details/presentation/cubit/details_cubit.dart';
import 'package:habiSpace/features/details/presentation/ui/details_view.dart';
import 'package:habiSpace/features/favorite/domain/entities/favorite_property_entity.dart';
import 'package:habiSpace/features/favorite/presentation/cubit/FavoriteCubit/favorite_cubit_cubit.dart';
import 'package:habiSpace/features/favorite/presentation/pages/favoriteMainPage.dart';
import 'package:habiSpace/features/favorite/presentation/pages/favorite_details_page.dart';
import 'package:habiSpace/features/home/domain/entities/home_property_entity.dart';
import 'package:habiSpace/features/home/presentation/cubit/home_cubit.dart';
import 'package:habiSpace/features/home/presentation/widgets/all_properties_page.dart';
import 'package:habiSpace/features/layout/presentation/ui/main_layout.dart';
import 'package:habiSpace/features/on_boarding/presentation/ui/on_boarding.dart';
import 'package:habiSpace/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:habiSpace/features/payment/presentation/ui/payment_view.dart';
import 'package:habiSpace/features/profile/domain/entities/Profile_Entity.dart';
import 'package:habiSpace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import 'package:habiSpace/features/profile/presentation/UI/change_password_screen.dart';
import 'package:habiSpace/features/profile/presentation/UI/update_profile_view.dart';
import 'package:habiSpace/splash.dart';
import '../../features/auth/presentation/logic/auth_bloc.dart';
import '../../features/auth/presentation/screens/forget_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/forget_password/otp_screen.dart';
import '../../features/auth/presentation/forget_password/reset_password_screen.dart';
part 'app_routes.dart';

GoRouter createRouter(String initialLocation) => GoRouter(
  initialLocation: initialLocation,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.onBoarding,
      name: AppRoutes.onBoarding,
      builder: (context, state) => const OnBoarding(),
    ),
    GoRoute(
      path: AppRoutes.details,
      name: AppRoutes.details,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final propertyId = extra['propertyId'] as int;
        final favoriteCubit = extra['favoriteCubit'] as FavoriteCubit;
        final similar =
            (extra['similarProperties'] as List<HomePropertyEntity>?) ?? [];
        return MultiBlocProvider(
          providers: [
            BlocProvider<DetailsCubit>(create: (_) => sl<DetailsCubit>()),
            BlocProvider<FavoriteCubit>.value(value: favoriteCubit),
          ],
          child: DetailsView(
            propertyId: propertyId,
            similarProperties: similar,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: LoginScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signup,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: SignupScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPassword,
      builder: (context, state) => BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
        child: ForgetPasswordScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.otp,
      name: AppRoutes.otp,
      builder: (context, state) {
        final email = state.extra as String;
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: OtpScreen(email: email),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.resetPassword,
      name: AppRoutes.resetPassword,
      builder: (context, state) {
        final args = state.extra as Map<String, String>;
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: ResetPasswordScreen(email: args['email']!, otp: args['otp']!),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()..getHome()),
          BlocProvider<FavoriteCubit>(
            create: (_) => sl<FavoriteCubit>()..getFavorites(),
          ),
          BlocProvider<HistoryCubit>(create: (_) => sl<HistoryCubit>()),
          BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
        ],
        child: const MainLayout(),
      ),
    ),

    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: AppRoutes.payment,
      name: AppRoutes.payment,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong.')),
          );
        }
        return BlocProvider(
          create: (_) => sl<PaymentCubit>(),
          child: PaymentView(
            property: extra['property'] as PropertyDetailEntity,
          ),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.conversations,
      name: AppRoutes.conversations,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ChatCubit>(),
        child: const ConversationsView(),
      ),
    ),

    GoRoute(
      path: AppRoutes.explore,
      name: AppRoutes.explore,
      builder: (context, state) => const ExploreView(),
    ),

    GoRoute(
      path: AppRoutes.updateProfile,
      name: AppRoutes.updateProfile,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final user = extra['user'] as ProfileEntity?;
        final profileCubit = extra['profileCubit'] as ProfileCubit;
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Personal Information')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return BlocProvider.value(
          value: profileCubit,
          child: UpdateProfileView(user: user),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.changePassword,
      name: AppRoutes.changePassword,
      builder: (context, state) {
        return BlocProvider.value(
          value: sl<ProfileCubit>(),
          child: ChangePasswordScreen(),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.chat,
      name: AppRoutes.chat,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (_) => sl<ChatCubit>(),
          child: ChatView(
            conversationId: extra['conversationId'] as int,
            agentName: extra['agentName'] as String,
          ),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.allProperties,
      name: AppRoutes.allProperties,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return AllPropertiesPage(
          title: extra['title'] as String,
          properties: extra['properties'] as List<HomePropertyEntity>,
        );
      },
    ),

    GoRoute(
      path: AppRoutes.favoriteBody,
      name: AppRoutes.favoriteBody,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) return const SizedBox();
        final favoriteCubit = extra['favoriteCubit'] as FavoriteCubit;
        return BlocProvider.value(
          value: favoriteCubit,
          child: FavoriteBody(
            categoryFilter: extra['categoryFilter'] as String?,
          ),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.favoriteDetails,
      name: AppRoutes.favoriteDetails,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) return const SizedBox();
        final favoriteCubit = extra['favoriteCubit'] as FavoriteCubit;
        return BlocProvider.value(
          value: favoriteCubit,
          child: FavoriteDetailsPage(
            property: extra['property'] as FavoritePropertyEntity,
            allFavorites:
                extra['allFavorites'] as List<FavoritePropertyEntity>? ??
                const [],
          ),
        );
      },
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('${'pageNotFound'.tr()}: ${state.error}')),
  ),
);
