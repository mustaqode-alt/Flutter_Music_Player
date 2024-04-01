import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/di/providers.dart';
import 'package:music_player/domain/customds/pair.dart';
import 'package:music_player/domain/entity/song.dart';
import 'package:music_player/presentation/config/palette.dart';
import 'package:music_player/presentation/config/routes.dart';
import 'package:music_player/presentation/config/theme/custom_theme.dart';
import 'package:music_player/presentation/config/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';

import 'data/datasource/local/db_boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Palette.primaryDark));
  await Firebase.initializeApp();
  await initDb();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initDb() async {
  await Hive.initFlutter();
  await Hive.openBox(Boxes.hiveBoxUserFavourites);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeProvider);

    return MaterialApp.router(
        routerConfig: _router(ref),
        title: 'Flutter Demo',
        theme: CustomThemes.lightTheme,
        darkTheme: CustomThemes.darkTheme,
        themeMode: themeMode);
  }
}

GoRouter _router(WidgetRef ref) {
  return GoRouter(
    initialLocation: Routes.login,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          final auth = ref.read(firebaseAuthProvider); // Access FirebaseAuth via DI
          final user = auth.currentUser;
          if (user != null) {
            return const Center(); // Replace with your logged in screen
          } else {
            return const Center(); // Replace with your login screen
          }
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const Center(),
      ),
      GoRoute(
        path: Routes.song,
        builder: (context, state) {
          final extras = state.extra as Pair<Song, bool>;
          return const Center();
        },
      ),
    ],
  );
}
