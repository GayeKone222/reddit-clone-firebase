import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone/models/comment.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  return ref.watch(postControllerProvider.notifier).fetchUserPosts(communities);
});

final guestPostsProvider = StreamProvider((ref) {
  return ref.watch(postControllerProvider.notifier).fetchGuestPosts();
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

final getCommentsofPostProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getCommentsOfPost(postId);
});

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      postRepository: postRepository,
      ref: ref,
      storageRepository: storageRepository);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController(
      {required PostRepository postRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String description}) async {
    state = true;

    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider)!;

    final Post post = Post(
        id: postId,
        title: title,
        type: 'text',
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        userName: user.name,
        userUid: user.uuid,
        createdAt: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.addPost(post);
    //update user textPost karma
    _ref
        .watch(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted successfully!");
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required String link}) async {
    state = true;

    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider)!;

    final Post post = Post(
        id: postId,
        title: title,
        type: 'link',
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        userName: user.name,
        userUid: user.uuid,
        createdAt: DateTime.now(),
        awards: [],
        link: link);

    final res = await _postRepository.addPost(post);
    //update user textPost karma
    _ref
        .watch(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted successfully!");
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required Community selectedCommunity,
      required File? image, required Uint8List? imageWeb}) async {
    state = true;

    String postId = const Uuid().v1();
    final user = _ref.watch(userProvider)!;

    //store image to firestorage
    final imageRes = await _storageRepository.storeFile(
        path: 'post/${selectedCommunity.name}', id: postId, file: image, webFile: imageWeb);

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
          id: postId,
          title: title,
          type: 'image',
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upVotes: [],
          downVotes: [],
          commentCount: 0,
          userName: user.name,
          userUid: user.uuid,
          createdAt: DateTime.now(),
          awards: [],
          //r = image download url from firebase
          link: r);

      final res = await _postRepository.addPost(post);
      //update user textPost karma
      _ref
          .watch(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      // state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, "Posted successfully!");
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);

    //update user textPost karma
    _ref
        .watch(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);

    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, "Post Deleted succesfully!"));
  }

  void upvote(Post post) async {
    final user = _ref.read(userProvider)!;

    _postRepository.upvote(post, user.uuid);
  }

  void downvote(Post post) async {
    final user = _ref.read(userProvider)!;

    _postRepository.downvote(post, user.uuid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment(
      {required BuildContext context,
      required String text,
      required Post post}) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    Comment comment = Comment(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: post.id,
        userName: user.name,
        profilePic: user.profilePic);

    final res = await _postRepository.addComment(comment);
    //update user textPost karma
    _ref
        .watch(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uuid);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }
}
