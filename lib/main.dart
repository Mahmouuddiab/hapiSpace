import 'package:habiSpace/core/constant/api_constant.dart';
import 'package:habiSpace/core/constant/bloc_abserver.dart';
import 'package:habiSpace/core/constant/dio_helper.dart';
import 'package:habiSpace/core/constant/secure_storage.dart';
import 'package:habiSpace/core/router/app_router.dart';
import 'package:habiSpace/core/theme/app_theme.dart';
import 'package:habiSpace/core/theme/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'core/di/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ScreenUtil.ensureScreenSize;
  await AuthStorage().init();
  Bloc.observer = AppBlocObserver();
  setupLocator();
  DioHelper.init(baseUrl: ApiConstant.baseUrl);

  final initialRoute = AppRoutes.splash;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: BlocProvider(
        create: (_) => ThemeCubit()..loadTheme(),
        child: MyApp(initialRoute: initialRoute),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.initialRoute);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'HapiSpace',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: themeMode,
              routerConfig: _router,
            );
          },
        );
      },
    );
  }
}
