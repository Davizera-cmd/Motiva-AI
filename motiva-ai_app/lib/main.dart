import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:motiva_ai/controllers/abstinence_controller.dart';
import 'package:motiva_ai/controllers/diary_controller.dart';
import 'package:motiva_ai/controllers/onboarding_controller.dart';
import 'package:motiva_ai/services/storage_service.dart';
import 'package:motiva_ai/services/notification_service.dart';
import 'package:motiva_ai/core/theme/app_theme.dart';
import 'package:motiva_ai/views/screens/onboarding_screen.dart';
import 'package:motiva_ai/views/screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await StorageService.init();
  await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AbstinenceController()),
        ChangeNotifierProvider(create: (_) => DiaryController()),
      ],
      child: const MotivaAiApp(),
    ),
  );
}

class MotivaAiApp extends StatelessWidget {
  const MotivaAiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motiva-AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      home: const _AppRouter(),
    );
  }
}

class _AppRouter extends StatefulWidget {
  const _AppRouter();
  @override
  State<_AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<_AppRouter> {
  late String _currentScreen;
  @override
  void initState() {
    super.initState();
    _currentScreen = OnboardingController.isOnboardingCompleted() ? 'main' : 'onboarding';
  }
  void _goTo(String screen) => setState(() => _currentScreen = screen);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_currentScreen) {
        'onboarding' => OnboardingScreen(key: const ValueKey('onboarding'), onCompleted: () => _goTo('main')),
        _            => MainScreen(key: const ValueKey('main'), onSettingsTap: () {}),
      },
    );
  }
}
