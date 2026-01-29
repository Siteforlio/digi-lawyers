import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:only_law_app/core/config/env_config.dart';
import 'package:only_law_app/core/theme/app_theme.dart';
import 'package:only_law_app/core/router/app_router.dart';
import 'package:only_law_app/features/feed/presentation/providers/feed_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  runApp(const OnlyLawApp());
}

class OnlyLawApp extends StatelessWidget {
  const OnlyLawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedProvider()),
      ],
      child: MaterialApp.router(
        title: EnvConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
