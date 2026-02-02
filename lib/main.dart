import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:only_law_app/core/config/env_config.dart';
import 'package:only_law_app/core/theme/app_theme.dart';
import 'package:only_law_app/core/router/app_router.dart';
import 'package:only_law_app/features/feed/presentation/providers/feed_provider.dart';
import 'package:only_law_app/features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const OnlyLawApp());
}

class OnlyLawApp extends StatelessWidget {
  const OnlyLawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
      ],
      child: MaterialApp.router(
        title: EnvConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light.copyWith(
          appBarTheme: AppTheme.light.appBarTheme.copyWith(
            systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
            ),
          ),
        ),
        darkTheme: AppTheme.dark.copyWith(
          appBarTheme: AppTheme.dark.appBarTheme.copyWith(
            systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          // Apply system UI overlay based on current theme
          final brightness = Theme.of(context).brightness;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarIconBrightness:
                  brightness == Brightness.light ? Brightness.dark : Brightness.light,
            ),
          );
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
