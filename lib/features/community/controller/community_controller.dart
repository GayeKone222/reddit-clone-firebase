import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/storage_repository.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final userCommunitiesProvider = StreamProvider(
  (ref) {
    final communityController = ref.watch(communityControllerProvider.notifier);
    return communityController.getUserCommunities();
  },
);

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository,
      ref: ref,
      storageRepository: storageRepository);
});

final getCommunityPostsProvider =
    StreamProvider.family((ref, String communityName) {
  return ref
      .read(communityControllerProvider.notifier)
      .getCommunityPosts(communityName);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController(
      {required CommunityRepository communityRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uuid = _ref.read(userProvider)?.uuid ?? "";
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.bannerDefault,
        members: [uuid],
        mods: [uuid]);

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Community created successfully!");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uuid = _ref.read(userProvider)!.uuid;

    return _communityRepository.getUserCommunities(uuid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required File? bannerFile,
      required File? avatarFile,
      required Uint8List? bannerWebFile,
      required Uint8List? avatarWebFile,
      required BuildContext context,
      required Community community}) async {
    state = true;
    //store file if not null
    if (avatarFile != null || avatarWebFile != null) {
      // communities/profile/tiktok
      final res = await _storageRepository.storeFile(
          path: 'communities/profile',
          id: community.name,
          file: avatarFile,
          webFile: avatarWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (avatarUrl) => community = community.copyWith(avatar: avatarUrl));
    }

    //store file if not null
    if (bannerFile != null || bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/banner',
          id: community.name,
          file: bannerFile,
          webFile: bannerWebFile);

      res.fold((l) => showSnackBar(context, l.message),
          (bannerUrl) => community = community.copyWith(banner: bannerUrl));
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;

    if (community.members.contains(user.uuid)) {
      res =
          await _communityRepository.leaveCommunity(community.name, user.uuid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uuid);
    }

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(user.uuid)) {
        showSnackBar(context, 'Community left succesfully');
      } else {
        showSnackBar(context, 'community joined succesfully');
      }
    });
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _communityRepository.getCommunityposts(communityName);
  }
}
