import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

//use StateNotifierProvider instead of provider because we are using StateNotifier for AuthController
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(
        authRepositoryProvider,
      ),
      ref: ref),
);

//to be able to change the value of the user later, we user StateProvider instead of Provider
final userProvider = StateProvider<UserModel?>(
  (ref) => null,
);

final authStateChangeProvider = StreamProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChange;
  },
);

final getUserDataProvider = StreamProvider.family((ref, String uuid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getuserData(uuid);
});

//extend StateNotifier in order to be able to read loading state
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // represents loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<UserModel> getuserData(String uuid) {
    return _authRepository.getuserData(uuid);
  }

  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;
    //update the user model value if succes
    user.fold(
        (l) => showSnackBar(context, l.message),
        (newUserModel) =>
            _ref.read(userProvider.notifier).update((state) => newUserModel));
  }

    void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logOut() async {
    _authRepository.logOut();
  }
}
