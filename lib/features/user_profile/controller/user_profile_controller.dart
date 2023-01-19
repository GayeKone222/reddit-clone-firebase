import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
      userProfileRepository: userProfileRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserposts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required UserProfileRepository userProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editUserProfile(
      {required File? bannerFile,
      required File? avatarFile,
      required Uint8List? bannerWebFile,
      required Uint8List? avatarWebFile,
      required BuildContext context,
      required String name}) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    //store file if not null
    if (avatarFile != null  || avatarWebFile != null) {
      // communities/profile/tiktok
      final res = await _storageRepository.storeFile(
          path: 'users/profile', id: user.uuid, file: avatarFile, webFile: avatarWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (avatarUrl) => user = user.copyWith(profilePic: avatarUrl));
    }

    //store file if not null
    if (bannerFile != null|| bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/banner', id: user.uuid, file: bannerFile,webFile: bannerWebFile);

      res.fold((l) => showSnackBar(context, l.message),
          (bannerUrl) => user = user.copyWith(banner: bannerUrl));
    }

    user = user.copyWith(name: name);

    final res = await _userProfileRepository.editUserProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        //update the userProvider with new user
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Post>> getUserposts(String uid) {
    return _userProfileRepository.getUserposts(uid);
  }

  void updateUserKarma(UserKarma userKarma) async {
    UserModel user = _ref.read(userProvider)!;

    user = user.copyWith(karma: user.karma + userKarma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold(
      (l) => null,
      (r) {
        //update the userProvider with new user
        _ref.read(userProvider.notifier).update((state) => user);
      },
    );
  }
}
