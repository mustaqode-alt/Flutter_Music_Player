import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/data/datasource/local/db_manager.dart';
import 'package:music_player/data/datasource/local/db_manager_impl.dart';
import 'package:music_player/data/datasource/remote/firebase_service.dart';
import 'package:music_player/data/datasource/remote/firebase_service_impl.dart';
import 'package:music_player/data/repository/user_repository_impl.dart';
import 'package:music_player/domain/entity/user_data.dart';
import 'package:music_player/domain/repository/user_repository.dart';
import 'package:music_player/domain/result.dart';
import 'package:music_player/domain/usecase/logout_use_case.dart';
import 'package:music_player/presentation/screens/login/login_controller.dart';

import '../domain/usecase/get_user_favourites_use_case.dart';
import '../domain/usecase/login_or_signup_use_case.dart';
import '../domain/usecase/update_favourites_to_db_use_case.dart';
import '../domain/usecase/update_favourites_to_server_use_case.dart';
import '../presentation/connectivity/internet_connectivity_notifier.dart';
import '../presentation/screens/home/home_controller.dart';

/// Firebase

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// Data Source - Local & Remote

final dbManagerProvider =
    Provider.autoDispose<DbManager>((ref) => DbManagerImpl());

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firebaseFirestore = ref.read(firebaseFirestoreProvider);
  return FirebaseServiceImpl(firebaseAuth, firebaseFirestore);
});

/// Repository

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  final dbManager = ref.read(dbManagerProvider);
  return UserRepositoryImpl(firebaseService, dbManager);
});

/// UseCase

final getUserFavouritesUseCaseProvider =
    Provider<GetUserFavouritesUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return GetUserFavouritesUseCase(userRepository);
});

final loginOrSignupUseCaseProvider = Provider<LoginOrSignupUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return LoginOrSignupUseCase(userRepository);
});

final updateFavouritesToDbUseCaseProvider =
    Provider<UpdateFavouritesToDbUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UpdateFavouritesToDbUseCase(userRepository);
});

final updateFavouritesToServerUseCaseProvider =
    Provider<UpdateFavouritesToServerUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UpdateFavouritesToServerUseCase(userRepository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return LogoutUseCase(userRepository);
});

/// Controllers

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, Result<UserData>>((ref) {
  final loginUseCase = ref.watch(loginOrSignupUseCaseProvider);
  return LoginController(loginUseCase);
});

final homeControllerProvider =
    StateNotifierProvider.autoDispose<HomeController, List<String>>((ref) =>
        HomeController(
            ref.read(updateFavouritesToServerUseCaseProvider),
            ref.read(updateFavouritesToDbUseCaseProvider),
            ref.read(getUserFavouritesUseCaseProvider),
            ref.read(logoutUseCaseProvider)));

/// other

final internetConnectivityProvider =
    StateNotifierProvider.autoDispose<InternetConnectivityNotifier, bool>(
        (ref) {
  final updateFavouritesToServerUseCase =
      ref.watch(updateFavouritesToServerUseCaseProvider);
  return InternetConnectivityNotifier(updateFavouritesToServerUseCase);
});
