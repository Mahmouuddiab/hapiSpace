import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habiSpace/core/error/app_exception.dart';
import 'package:habiSpace/core/router/app_router.dart';
import 'package:habiSpace/core/theme/theme_cubit.dart';
import 'package:habiSpace/core/utils/app_sizes.dart';
import 'package:habiSpace/core/utils/app_texts.dart';
import 'package:habiSpace/features/profile/presentation/Cubit/cubit/profile_cubit.dart';
import 'package:habiSpace/features/profile/presentation/widgets/delete_my_account_widget.dart';
import 'package:habiSpace/features/profile/presentation/widgets/glass_card.dart';
import 'package:habiSpace/features/profile/presentation/widgets/glass_user_card.dart';
import 'package:habiSpace/features/profile/presentation/widgets/language_tile.dart';
import 'package:habiSpace/features/profile/presentation/widgets/menu_tile.dart';
import 'package:habiSpace/features/profile/presentation/widgets/section_title.dart';
import 'package:habiSpace/features/profile/presentation/widgets/switch_tile.dart';
import 'package:habiSpace/shared/error_view.dart';
import 'package:habiSpace/shared/profile_skelton.dart';
import 'package:habiSpace/shared/skelton/shimmer.dart';
import 'package:habiSpace/shared/skelton/skelton_widget.dart';

///  LOGOUT DIALOG
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to logout from your account?",
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final cubit = context.read<ProfileCubit>();
              Navigator.of(dialogContext, rootNavigator: true).pop();
              await cubit.logOutProfile();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}

///  PROFILE SLIVERS
List<Widget> profileViewSlivers(BuildContext context, ProfileState state) {
  if (state is ProfileInitial || state is ProfileLoading) {
    return [
      SliverToBoxAdapter(
        child: AppSkeleton(
          isLoading: true,
          skeleton: ProfileSkeleton(),
          child: SkeletonWidget(),
        ),
      ),
    ];
  }

  if (state is ProfileError) {
    return [
      SliverErrorView(
        message: state.message,
        type: AppExceptionType.unknown,
        onRetry: () => context.read<ProfileCubit>().getProfile(),
      ),
    ];
  }

  if (state is ProfileLoaded) {
    final user = state.profile.isNotEmpty ? state.profile.first : null;

    return [
      SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.h50),

                /// HERO PROFILE CARD
                GlassUserCard(user: user),

                SizedBox(height: AppSizes.h28),

                /// ACCOUNT
                SectionTitle(title: AppTexts.profileAccountSetting.tr()),

                GlassCard(
                  children: [
                    MenuTile(
                      icon: Icons.person_outline_rounded,
                      title: AppTexts.profilePersonalInfo.tr(),
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.updateProfile,
                          extra: {
                            'user': user,
                            'profileCubit': context.read<ProfileCubit>(),
                          },
                        );
                      },
                    ),
                    MenuTile(
                      icon: Icons.manage_accounts_outlined,
                      title: AppTexts.profileMyAccount.tr(),
                      isLast: true,
                      onTap: () => DeleteAccountPopup.show(context),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.h20),

                /// SECURITY
                SectionTitle(title: AppTexts.profileSettingSecurity.tr()),

                GlassCard(
                  children: [
                    MenuTile(
                      icon: Icons.lock_outline_rounded,
                      title: AppTexts.profileChangePassword.tr(),
                      onTap: () => context.pushNamed(AppRoutes.changePassword),
                    ),

                    MenuTile(
                      icon: Icons.notifications_none_rounded,
                      title: AppTexts.profileNotificationPref.tr(),
                      onTap: () => context.pushNamed(AppRoutes.notifications),
                    ),

                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        final isDark = themeMode == ThemeMode.dark;

                        return SwitchTile(
                          icon: isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          title: isDark ? "Dark Mode" : "Light Mode",
                          value: isDark,
                          onChanged: (_) =>
                              context.read<ThemeCubit>().toggleTheme(),
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        final isArabic = context.locale.languageCode == 'ar';

                        return LanguageTile(
                          isArabic: isArabic,
                          onTap: () => context.setLocale(
                            isArabic ? const Locale('en') : const Locale('ar'),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.h20),

                /// DANGER ZONE
                SectionTitle(title: "Danger Zone"),

                GlassCard(
                  color: Colors.red.withOpacity(0.05),
                  borderColor: Colors.red.withOpacity(0.15),
                  children: [
                    MenuTile(
                      icon: Icons.logout_rounded,
                      title: AppTexts.profilelogout.tr(),
                      isDestructive: true,
                      isLast: true,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.h80),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  return [
    SliverFillRemaining(
      child: Center(child: Text(AppTexts.profileSomethingWrong.tr())),
    ),
  ];
}
