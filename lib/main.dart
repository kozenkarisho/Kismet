import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/app_state.dart';
import 'services/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize app state (loads persisted data)
  final appState = AppState();
  await appState.initialize();

  // Initialize Gemini service
  final geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final geminiService = GeminiService(apiKey: geminiApiKey);

  runApp(KismetApp(appState: appState, geminiService: geminiService));
}

class KismetApp extends StatelessWidget {
  final AppState appState;
  final GeminiService geminiService;

  const KismetApp({
    super.key,
    required this.appState,
    required this.geminiService,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Kismet',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.themeMode,
          home: HomeScreen(appState: appState, geminiService: geminiService),
        );
      },
    );
  }
}
