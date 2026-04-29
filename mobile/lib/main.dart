import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:techarrow_2026_app/screens/auth_screen/screen.dart';
import 'package:techarrow_2026_app/screens/index_screen/screen.dart';
import 'package:techarrow_2026_app/services/auth.dart';
import 'package:techarrow_2026_app/services/quest.dart';
import 'package:techarrow_2026_app/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env', isOptional: true);
  } catch (_) {
    dotenv.loadFromString(isOptional: true);
  }
  runApp(
    StreamAuthScope(
      child: StreamQuestScope(child: const MainApp()),
    ),
  );
}

final _router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {
    final bool loggedIn = await StreamAuthScope.of(context).isSignedIn();
    final loggingIn = state.matchedLocation == '/auth';
    if (!loggedIn) {
      return '/auth';
    }

    if (loggingIn) {
      return '/';
    }

    return "/";
  },
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return const IndexScreen();
      },
    ),
    GoRoute(
      path: "/auth",
      builder: (context, state) {
        return const AuthorizationScreen();
      },
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: MaterialTheme(TextTheme()).light(),
    );
  }
}
