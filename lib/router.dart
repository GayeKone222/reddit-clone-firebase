import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/add_mods_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:reddit_clone/features/post/screens/add_post_screen.dart';
import 'package:reddit_clone/features/post/screens/add_post_type_screen.dart';
import 'package:reddit_clone/features/post/screens/comments_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) =>
      MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!)),
  '/mod-tools/:name': (route) =>
      MaterialPage(child: ModtoolsScreen(name: route.pathParameters['name']!)),
  '/edit-community/:name': (route) => MaterialPage(
      child: EditCummunityScreen(name: route.pathParameters['name']!)),
  '/add-mods/:name': (route) =>
      MaterialPage(child: AddModsScreen(name: route.pathParameters['name']!)),
  '/u/:uid': (route) =>
      MaterialPage(child: UserProfileScreen(uid: route.pathParameters['uid']!)),
  '/edit-profile/:uid': (route) =>
      MaterialPage(child: EditProfileScreen(uid: route.pathParameters['uid']!)),
  '/add-post/:type': (routeData) => MaterialPage(
        child: AddPostTypeScreen(
          type: routeData.pathParameters['type']!,
        ),
      ),
  '/add-post': (routeData) => const MaterialPage(
        child: AddPostScreen(),
      ),
  '/post/:postId/comments': (route) => MaterialPage(
        child: CommentsScreen(
          postId: route.pathParameters['postId']!,
        ),
      ),
});
