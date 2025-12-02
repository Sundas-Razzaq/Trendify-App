import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendify/utils/providers/auth_provider.dart';
import 'package:get/get.dart';
import 'package:trendify/features/authentication/screens/onboarding.dart';
import 'package:trendify/utils/theme/theme.dart';
import 'package:trendify/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        home: const OnboardingScreen(),
        getPages: AppRoutes.routes,
      ),
    );
  }
}
