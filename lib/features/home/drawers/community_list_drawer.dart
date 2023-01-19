import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCummunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCummunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    print('isGuest : $isGuest');
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          isGuest
              ? const SignInButton(
                  isFromLogin: false,
                )
              : ListTile(
                  title: const Text("Create a community"),
                  leading: const Icon(Icons.add),
                  onTap: (() => navigateToCreateCummunity(context)),
                ),
          if (!isGuest)
            ref.watch(userCommunitiesProvider).when(
                data: (communities) =>
                    // communities.isEmpty
                    //     ? const SizedBox()
                    //     :
                    Expanded(
                      child: ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: (context, index) {
                            final community = communities[index];
                            return ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(community.avatar)),
                              title: Text('r/${community.name}'),
                              onTap: () =>
                                  navigateToCummunity(context, community),
                            );
                          }),
                    ),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader())
        ],
      )),
    );
  }
}
