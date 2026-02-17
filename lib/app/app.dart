import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_n_found/app/theme/app_theme.dart';
import 'package:lost_n_found/app/theme/theme_cubit.dart';
import 'package:lost_n_found/core/di/service_locator.dart';
import 'package:lost_n_found/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lost_n_found/features/batch/presentation/bloc/batch_bloc.dart';
import 'package:lost_n_found/features/category/presentation/bloc/category_bloc.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_bloc.dart';
import 'package:lost_n_found/features/splash/presentation/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(prefs: serviceLocator<SharedPreferences>()),
        ),
        BlocProvider<AuthBloc>(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider<ItemBloc>(create: (_) => serviceLocator<ItemBloc>()),
        BlocProvider<CategoryBloc>(
          create: (_) => serviceLocator<CategoryBloc>(),
        ),
        BlocProvider<BatchBloc>(create: (_) => serviceLocator<BatchBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Lost & Found',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
